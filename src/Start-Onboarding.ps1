# Tar emot sökvägen till datafilen som parameter när scriptet körs.
# DemoMode gör att scriptet bara visar vad som skulle göras, utan att ändra i AD eller skapa mappar.
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$DataPath,

    [switch]$DemoMode
)

# Gör så att fel stoppar scriptet och kan hanteras med Try/Catch.
$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

try {
    # Importerar projektets grundmoduler.
    # Dessa behövs för att läsa in data, validera data och skriva loggar.
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Import.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Validation.psm1") -Force
    Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.Logging.psm1") -Force

    # Funktioner som alltid behövs, även i DemoMode.
    $requiredFunctions = @(
        "Import-OnboardifyUserData",
        "Test-OnboardifyUserData",
        "Write-OnboardifyLog"
    )

    # AD- och mappmoduler behövs bara vid skarp körning.
    # I DemoMode ska scriptet kunna testas utan att påverka AD eller filsystem.
    if (-not $DemoMode) {
        Import-Module (Join-Path $PSScriptRoot "modules\Onboardify.AD.psm1") -Force
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
        Write-OnboardifyLog "[DEMO] Demo-läge aktiverat. Inga ändringar sker i AD eller filsystem."
    }

    # Kontrollerar att datafilen finns innan vi försöker läsa in den.
    # Detta gör felmeddelandet tydligare om fel sökväg skickas in.
    if (-not (Test-Path $DataPath)) {
        throw "Datafilen hittades inte: $DataPath"
    }

    # Läser in användare från datafilen.
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

        # Skapar användarnamn på samma sätt som AD-modulen.
        # Detta gör att AD-konto och hemkatalog får samma namn.
        $username = ($user.firstName.Substring(0, 1) + $user.lastName).ToLower()

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