
}# Importera modulen där funktionen finns
Import-Module "$PSScriptRoot\modules\Onboardify.Import.psm1" -Force

# Läs in testfilen
$userData = Import-OnboardifyUserData -Path "$PSScriptRoot\..\config\customer.sample.json"

# Visa resultatet om importen lyckas
if ($null -ne $userData) {
    Write-Host "Import lyckades!" -ForegroundColor Green
    $userData | Format-List
}
else {
    Write-Host "Import misslyckades." -ForegroundColor Red