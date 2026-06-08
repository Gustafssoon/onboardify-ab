# Tar emot sökvägen till datafilen som parameter när scriptet körs
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$DataPath
)

# Gör så att fel stoppar scriptet och kan hanteras senare med Try/Catch
$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Funktion som läser in onboarding-data från en JSON-fil
function Read-OnboardingData {
    param(
        [string]$Path
    )

    # Kontrollera att datafilen finns innan vi försöker läsa den
    if (-not (Test-Path $Path)) {
        throw "Datafilen hittades inte: $Path"
    }

    # Läs in JSON-filen och konvertera den till PowerShell-objekt
    $data = Get-Content -Path $Path -Raw | ConvertFrom-Json

    return $data
}

# Startmeddelanden
Write-Host "Startar onboarding-script..."
Write-Host "Datafil: $DataPath"

# Läs in användare från datafilen
$users = Read-OnboardingData -Path $DataPath

# Skriv ut resultat från inläsningen
Write-Host "Onboarding-data har lästs in."
Write-Host "Antal användare: $($users.Count)"

# Loopa igenom användarna och visa vilka som hittades
foreach ($user in $users) {
    Write-Host "Hittade användare: $($user.firstName) $($user.lastName)"
}