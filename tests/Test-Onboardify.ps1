# Test-Onboardify.ps1
# Enkelt testscript för Onboardify-moduler.

$ErrorActionPreference = "Stop"

Write-Host "Startar tester för Onboardify..." -ForegroundColor Cyan

# Sökvägar till moduler och testdata
$ImportModulePath = ".\src\modules\Onboardify.Import.psm1"
$ValidationModulePath = ".\src\modules\Onboardify.Validation.psm1"
$LoggingModulePath = ".\src\modules\Onboardify.Logging.psm1"
$TestDataPath = ".\config\customer.sample.json"

try {
    Write-Host ""
    Write-Host "Test 1: Kontrollerar att modulfiler finns"

    if (-not (Test-Path $ImportModulePath)) {
        throw "Importmodulen saknas."
    }

    if (-not (Test-Path $ValidationModulePath)) {
        throw "Valideringsmodulen saknas."
    }

    if (-not (Test-Path $LoggingModulePath)) {
        throw "Loggningsmodulen saknas."
    }

    Write-Host "OK - Alla modulfiler finns" -ForegroundColor Green


    Write-Host ""
    Write-Host "Test 2: Importerar moduler"

    Import-Module $ImportModulePath -Force
    Import-Module $ValidationModulePath -Force
    Import-Module $LoggingModulePath -Force

    Write-Host "OK - Moduler importerades" -ForegroundColor Green


    Write-Host ""
    Write-Host "Test 3: Kontrollerar att viktiga funktioner finns"

    if (-not (Get-Command Import-OnboardifyUserData -ErrorAction SilentlyContinue)) {
        throw "Funktionen Import-OnboardifyUserData saknas."
    }

    if (-not (Get-Command Test-OnboardifyUserData -ErrorAction SilentlyContinue)) {
        throw "Funktionen Test-OnboardifyUserData saknas."
    }

    if (-not (Get-Command Initialize-OnboardifyLog -ErrorAction SilentlyContinue)) {
        throw "Funktionen Initialize-OnboardifyLog saknas."
    }

    if (-not (Get-Command Write-OnboardifyLog -ErrorAction SilentlyContinue)) {
        throw "Funktionen Write-OnboardifyLog saknas."
    }

    if (-not (Get-Command Get-OnboardifyLogFile -ErrorAction SilentlyContinue)) {
        throw "Funktionen Get-OnboardifyLogFile saknas."
    }

    Write-Host "OK - Viktiga funktioner finns" -ForegroundColor Green


    Write-Host ""
    Write-Host "Test 4: Testar loggning"

    Initialize-OnboardifyLog -Path ".\logs\test"
    Write-OnboardifyLog -Message "Test av loggning från testscript" -Level "INFO"

    $LogFile = Get-OnboardifyLogFile

    if (-not (Test-Path $LogFile)) {
        throw "Loggfilen skapades inte."
    }

    Write-Host "OK - Loggning fungerar" -ForegroundColor Green


    Write-Host ""
    Write-Host "Test 5: Läser in JSON-data"

    if (-not (Test-Path $TestDataPath)) {
        throw "Testdata saknas."
    }

    $Users = @(Import-OnboardifyUserData -Path $TestDataPath)

    if ($Users.Count -eq 0) {
        throw "Ingen användardata lästes in."
    }

    Write-Host "OK - JSON-data lästes in" -ForegroundColor Green
    Write-Host "Antal användare: $($Users.Count)"


    Write-Host ""
    Write-Host "Test 6: Validerar användardata"

    $ValidationResult = Test-OnboardifyUserData -Users $Users

    if ($ValidationResult -ne $true) {
        throw "Valideringen returnerade inte true."
    }

    Write-Host "OK - Användardata validerades" -ForegroundColor Green


    Write-Host ""
    Write-Host "Alla tester lyckades!" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "TEST MISSLYCKADES" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}