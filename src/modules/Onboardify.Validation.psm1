# Onboardify.Validation.psm1

# Funktion för att validera användardata innan den används i onboarding-flödet. Den kontrollerar att alla nödvändiga fält finns och inte är tomma.
function Test-OnboardifyUserData {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [array]$Users
    )
    
    $requiredFields = @('FirstName', 'LastName', 'Email')

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

# Testdata för att verifiera att valideringen fungerar som den ska. Den sista användaren har en tom FirstName och bör inte passera valideringen.

$testUsers = @(
    @{
        FirstName = 'John'
        LastName  = 'Doe'
        Email     = 'john.doe@example.com'
    },
    @{
        FirstName = 'Jane'
        LastName  = 'Smith'
        Email     = 'jane.smith@example.com'
    },
    @{
        FirstName = ''
        LastName  = 'Johnson'
        Email     = 'bob.johnson@example.com'
    }
)

Test-OnboardifyUserData -Users $testUsers