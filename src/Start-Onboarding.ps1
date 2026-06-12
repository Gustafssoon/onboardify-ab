# Tar emot sökvägen till datafilen som parameter när scriptet körs.
# DemoMode gör att scriptet bara visar vad som skulle göras, utan att skapa användare eller mappar.
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$DataPath,

    # Sökväg till den genererade AD-strukturen.
    # Om inget anges används config/ad-structure.generated.json.
    [string]$StructurePath,

    [switch]$DemoMode
)

# Gör så att fel stoppar scriptet och kan hanteras med Try/Catch.
$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    # Importerar projektets grundmoduler.
    # Dessa behövs för att skanna AD, läsa in data, validera data och skriva loggar.
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Logging.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Discovery.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Import.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Validation.psm1") -Force

    # Funktioner som alltid behövs.
    $requiredFunctions = @(
        "Write-OnboardifyLog",
        "Export-OnboardifyADStructure",
        "Import-OnboardifyUserData",
        "Test-OnboardifyUserData"
    )

    # AD-modulen behövs både i DemoMode och vid skarp körning.
    # I DemoMode används den för att räkna ut realistiska användarnamn.
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.AD.psm1") -Force

    $requiredFunctions += @(
        "Get-NextSamAccountName",
        "Test-OnboardifyExistingPerson"
    )

    # Mappmodulen behövs bara vid skarp körning.
    # I DemoMode ska scriptet inte skapa användare eller mappar.
    if (-not $DemoMode) {
        Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Folders.psm1") -Force

        $requiredFunctions += @(
            "New-OnboardifyADUser",
            "New-OnboardifyHomeFolder"
        )
    }

    # Kontrollerar att funktionerna som huvudscriptet behöver finns.
    # Om någon funktion saknas stoppas scriptet direkt med ett tydligt fel.
    foreach ($functionName in $requiredFunctions) {
        if (-not (Get-Command $functionName -ErrorAction SilentlyContinue)) {
            throw "Funktionen $functionName saknas. Kontrollera att rätt modul är klar och importerad."
        }
    }

    # Startar onboarding-flödet.
    Write-OnboardifyLog "Startar onboarding-script..."
    Write-OnboardifyLog "Datafil: $DataPath"

    if ($DemoMode) {
        Write-OnboardifyLog "[DEMO] Demo-läge aktiverat. Inga användare eller mappar skapas."
    }

    # Om ingen sökväg anges sparas/läses AD-strukturen från config-mappen.
    if ([string]::IsNullOrWhiteSpace($StructurePath)) {
        $RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")
        $StructurePath = Join-Path $RepoRoot "config\ad-structure.generated.json"
    }

    # Skannar AD-strukturen först.
    # Detta skapar config/ad-structure.generated.json som sedan kan användas som underlag för HR-data.
    Write-OnboardifyLog "Startar AD-skanner..."
    Export-OnboardifyADStructure -OutputPath $StructurePath | Out-Null

    # Läser in den genererade AD-strukturen.
    # I nuläget används den som underlag och kvitto på aktuell AD-struktur.
    # Nästa steg kan bli att validera HR-data mot denna fil.
    if (-not (Test-Path $StructurePath)) {
        throw "AD-strukturfilen skapades inte: $StructurePath"
    }

    $adStructure = Get-Content -Path $StructurePath -Raw | ConvertFrom-Json

    Write-OnboardifyLog "AD-struktur har skannats och lästs in."
    Write-OnboardifyLog "AD-strukturfil: $StructurePath"

    if ($adStructure.organizationalUnits) {
        Write-OnboardifyLog "Antal OU:er i AD-strukturen: $($adStructure.organizationalUnits.Count)"
    }

    # Kontrollerar att datafilen finns innan vi försöker läsa in den.
    # Detta gör felmeddelandet tydligare om fel sökväg skickas in.
    if (-not (Test-Path $DataPath)) {
        throw "Datafilen hittades inte: $DataPath"
    }

    # Läser in användare från HR-datafilen.
    $users = @(Import-OnboardifyUserData -Path $DataPath)

    if ($null -eq $users -or $users.Count -eq 0) {
        throw "Ingen onboarding-data kunde läsas in."
    }

    # Validerar datan innan något skapas.
    # Om valideringen misslyckas avbryts scriptet så att inga felaktiga objekt skapas.
    if (-not (Test-OnboardifyUserData -Users $users)) {
        throw "Valideringen misslyckades. Onboarding avbryts."
    }

    Write-OnboardifyLog "Onboarding-data har lästs in."
    Write-OnboardifyLog "Antal användare: $($users.Count)"

    # Kör huvudflödet för varje användare.
    foreach ($user in $users) {
        Write-OnboardifyLog "Startar onboarding för $($user.firstName) $($user.lastName)"

        # Räknar ut användarnamn med samma logik som AD-modulen.
        # Om användaren redan finns används befintligt användarnamn.
        $existingPerson = Test-OnboardifyExistingPerson `
            -FirstName $user.firstName `
            -LastName $user.lastName `
            -OrganizationUnit $user.organizationUnit

        if ($existingPerson) {
            $username = $existingPerson.SamAccountName
        }
        else {
            $username = Get-NextSamAccountName `
                -FirstName $user.firstName `
                -LastName $user.lastName
}

        if ($DemoMode) {
            # I DemoMode loggar vi bara vad scriptet skulle ha gjort.
            Write-OnboardifyLog "[DEMO] Skulle skapa AD-användare för: $username"
            Write-OnboardifyLog "[DEMO] Skulle placera användaren i OU: $($user.organizationUnit)"

            if ($user.groups) {
                Write-OnboardifyLog "[DEMO] Skulle lägga användaren i grupper: $($user.groups -join ', ')"
            }

            Write-OnboardifyLog "[DEMO] Skulle skapa hemkatalog för: $username"
            Write-OnboardifyLog "[DEMO] Onboarding klar för $($user.firstName) $($user.lastName)"
        }
        else {
            # Skapar AD-användaren med hjälp av AD-modulen.
            # AD-modulen ansvarar för användarens attribut, OU-placering och gruppmedlemskap.
            New-OnboardifyADUser -User $user

            # Skapar hemkatalog för användaren.
            # Samma användarnamn används här som vid skapandet av AD-kontot.
            New-OnboardifyHomeFolder -UserName $username

            Write-OnboardifyLog "Onboarding-flöde klart för $($user.firstName) $($user.lastName)"
        }
    }

    if ($DemoMode) {
        Write-OnboardifyLog "[DEMO] Onboarding-script klart."
    }
    else {
        Write-OnboardifyLog "Onboarding-script klart."
    }
}
catch {
    # Sparar felmeddelandet så det kan visas och loggas på samma sätt.
    $errorMessage = "Fel i onboarding-scriptet: $($_.Exception.Message)"

    # Försöker logga felet om loggfunktionen har hunnit laddas.
    # Om felet sker innan loggmodulen är importerad visas felet ändå i terminalen.
    if (Get-Command Write-OnboardifyLog -ErrorAction SilentlyContinue) {
        Write-OnboardifyLog $errorMessage "FEL"
    }

    Write-Host $errorMessage -ForegroundColor Red
    exit 1
}