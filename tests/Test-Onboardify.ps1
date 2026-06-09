# Test-Onboardify.ps1
# Enkelt testscript för Onboardify-moduler.

$ErrorActionPreference = "Stop"

Write-Host "Startar tester för Onboardify..." -ForegroundColor Cyan

# Sökvägar till moduler
$ImportModulePath = ".\src\modules\Onboardify.Import.psm1"
$ValidationModulePath = ".\src\modules\Onboardify.Validation.psm1"
$LoggingModulePath = ".\src\modules\Onboardify.Logging.psm1"

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
    Write-Host "Testscriptet är klart." -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "TEST MISSLYCKADES" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}