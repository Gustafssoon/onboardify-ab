# Onboardify.Validation.psm1

# Funktion för att validera användardata innan den används i onboarding-flödet. Den kontrollerar att alla nödvändiga fält finns och inte är tomma.
function Test-OnboardifyUserData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Users
    )
    
    # Definierar de fält som valideras för varje användare.
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

    <# Loopar igenom varje användare och kontrollerar att alla nödvändiga fält finns och inte är tomma.
     Om något fält saknas eller är tomt, skrivs ett meddelande ut och funktionen returnerar $false.
    Om alla fält är giltiga, skrivs ett bekräftelsemeddelande ut och funktionen returnerar $true.#>
    foreach ($user in $Users) {
        foreach ($field in $requiredFields) {
            if (-not $user.ContainsKey($field) -or [string]::IsNullOrEmpty($user[$field])) {
                Write-Host "Användardata saknas för fält: $field",
                return $false
            }

            else {
                Write-Host "Användardata för $($user['FirstName']) $($user['LastName']) är giltig.",
                return $true
            }
        }
    }
}