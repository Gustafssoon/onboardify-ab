# Onboardify.Validation.psm1

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Funktion för att validera användardata innan den används i onboarding-flödet.
# Den kontrollerar att alla nödvändiga fält finns och inte är tomma.
function Test-OnboardifyUserData {
    [CmdletBinding()]
    param (
        # Lista med användare som ska valideras.
        [Parameter(Mandatory = $true)]
        [array]$Users
    )

    # Definierar de fält som måste finnas för varje användare.
    $requiredFields = @(
        "firstName",
        "lastName",
        "username",
        "title",
        "organizationUnit",
        "department",
        "groups",
        "license",
        "homeFolder",
        "email"
    )

    <#
    Loopar igenom varje användare och kontrollerar att alla nödvändiga fält finns och inte är tomma.

    JSON-data som läses in med ConvertFrom-Json blir PowerShell-objekt.
    Därför kontrollerar vi fält med PSObject.Properties.Name istället för ContainsKey.

    Om något fält saknas eller är tomt skrivs ett felmeddelande ut och funktionen returnerar $false.
    Om alla användare är giltiga returnerar funktionen $true.
    #>
    foreach ($user in $Users) {

        foreach ($field in $requiredFields) {

            # Kontrollerar att fältet finns på användarobjektet.
            if (-not ($user.PSObject.Properties.Name -contains $field)) {
                Write-Host "Användardata saknar fält: $field" -ForegroundColor Red
                return $false
            }

            # Hämtar värdet från fältet som kontrolleras.
            $value = $user.$field

            # Kontrollerar att fältet inte är tomt.
            if ($null -eq $value -or [string]::IsNullOrWhiteSpace($value.ToString())) {
                Write-Host "Användardata har tomt fält: $field" -ForegroundColor Red
                return $false
            }
        }

        # Skrivs ut när en användare har passerat alla kontroller.
        Write-Host "Användardata för $($user.firstName) $($user.lastName) är giltig." -ForegroundColor Green
    }

    # Om alla användare har kontrollerats utan fel returneras true.
    return $true
}