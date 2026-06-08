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

# Sökväg till loggmappen och loggfilen
$LogFolder = ".\logs"
$LogFile = ".\logs\onboarding-log.txt"

# Skapa loggmappen om den inte redan finns
if (-not (Test-Path $LogFolder)) {
    New-Item -ItemType Directory -Path $LogFolder | Out-Null
}

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

# Funktion som kontrollerar att viktig onboarding-data finns
function Test-OnboardingData {
    param(
        $Users
    )

    if ($null -eq $Users) {
        throw "Ingen onboarding-data kunde läsas in."
    }

    foreach ($user in $Users) {
        if ([string]::IsNullOrWhiteSpace($user.firstName)) {
            throw "Förnamn saknas för en användare."
        }

        if ([string]::IsNullOrWhiteSpace($user.lastName)) {
            throw "Efternamn saknas för en användare."
        }

        if ([string]::IsNullOrWhiteSpace($user.department)) {
            throw "Avdelning saknas för en användare."
        }
    }

    Write-OnboardingLog "Grundläggande validering är klar."
}

# Funktion som skriver logg både till terminalen och till loggfilen
function Write-OnboardingLog {
    param(
        [string]$Message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logText = "$timestamp - $Message"

    Write-Host $logText
    Add-Content -Path $LogFile -Value $logText
}

# Startmeddelanden
Write-OnboardingLog "Startar onboarding-script..."
Write-OnboardingLog "Datafil: $DataPath"

# Läs in användare från datafilen
$users = @(Read-OnboardingData -Path $DataPath)

# Kontrollera att datan innehåller de viktigaste fälten
Test-OnboardingData -Users $users

# Skriv ut resultat från inläsningen
Write-OnboardingLog "Onboarding-data har lästs in."
Write-OnboardingLog "Antal användare: $($users.Count)"

# Loopa igenom användarna och visa vilka som hittades
foreach ($user in $users) {
    Write-OnboardingLog "Hittade användare: $($user.firstName) $($user.lastName)"
}