# Tar emot sökvägen till datafilen som parameter när scriptet körs
# Lade till en switch för DemoMode ska inte påverka AD.
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$DataPath,

    [switch]$DemoMode
)

# Gör så att fel stoppar scriptet och kan hanteras med Try/Catch
$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Importerar projektets moduler
Import-Module "$PSScriptRoot\modules\Onboardify.Import.psm1" -Force
Import-Module "$PSScriptRoot\modules\Onboardify.Validation.psm1" -Force
Import-Module "$PSScriptRoot\modules\Onboardify.Logging.psm1" -Force

# Kontrollerar att funktionerna som huvudscriptet behöver finns
# Funktionerna byggs i separata issues
$requiredFunctions = @(
    "Import-OnboardifyUserData",
    "Test-OnboardifyUserData",
    "Write-OnboardifyLog"
)

foreach ($functionName in $requiredFunctions) {
    if (-not (Get-Command $functionName -ErrorAction SilentlyContinue)) {
        throw "Funktionen $functionName saknas. Kontrollera att rätt modul är klar och importerad."
    }
}

try {
    # Startar onboarding-flödet
    Write-OnboardifyLog "Startar onboarding-script..."
    Write-OnboardifyLog "Datafil: $DataPath"

if ($DemoMode) {
    #Lade till en if att om DemoMode är aktiverat skickas detta meddelande.
    Write-OnboardifyLog "[DEMO] Demo-läge aktiverat inga ändringar sker i AD"
}
    # Läser in användare från datafilen
    $users = @(Import-OnboardifyUserData -Path $DataPath)

    if ($null -eq $users -or $users.Count -eq 0) {
        throw "Ingen onboarding-data kunde läsas in."
    }

    # Validerar datan innan något skapas
    Test-OnboardifyUserData -Users $users

    Write-OnboardifyLog "Onboarding-data har lästs in."
    Write-OnboardifyLog "Antal användare: $($users.Count)"

    # Kör huvudflödet för varje användare
    foreach ($user in $users) {
        Write-OnboardifyLog "Startar onboarding för $($user.firstName) $($user.lastName)"

        # TODO: Koppla till AD-modul när funktionen finns
        # New-OnboardifyADUser -User $user

        # TODO: Koppla till OU-funktion när den finns
        # Set-OnboardifyUserOU -User $user

        # TODO: Koppla till gruppfunktion när den finns
        # Add-OnboardifyUserGroups -User $user

        # TODO: Koppla till hemkatalogfunktion när den finns
        # New-OnboardifyHomeFolder -User $user

        Write-OnboardifyLog "Onboarding-flöde klart för $($user.firstName) $($user.lastName)"
    }

    if ($DemoMode) {
        #Avslutingen av logg för demokörning.
        Write-OnboardifyLog "[DEMO] Onboarding-script klart."
    }
    
    Write-OnboardifyLog "Onboarding-script klart."
}
catch {
    Write-Host "Fel i onboarding-scriptet: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}
