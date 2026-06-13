# Onboardify.Validation.psm1

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
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

    # Definierar de fält som HR eller testdata måste fylla i.
    # Tekniska fält som username, email och homeFolder skapas automatiskt av Onboardify.
    $requiredFields = @(
        "firstName",
        "lastName",
        "title",
        "organizationUnit",
        "department",
        "groups",
        "license"
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

            # groups är en lista och behöver därför kontrolleras lite annorlunda än vanliga textfält.
            if ($field -eq "groups") {

                # Kontrollerar att groups inte saknas helt.
                if ($null -eq $value) {
                    Write-Host "Användardata har inga grupper angivna." -ForegroundColor Red
                    return $false
                }

                # Gör om groups till en lista så att både en grupp och flera grupper kan hanteras.
                $groups = @($value)

                # Letar efter tomma eller ogiltiga gruppnamn.
                $invalidGroups = @($groups | Where-Object { [string]::IsNullOrWhiteSpace($_.ToString()) })

                # Kontrollerar att minst en grupp finns och att gruppnamnen inte är tomma.
                if ($groups.Count -eq 0 -or $invalidGroups.Count -gt 0) {
                    Write-Host "Användardata har tomt eller ogiltigt gruppfält." -ForegroundColor Red
                    return $false
                }

                # Hoppar vidare till nästa fält när grupperna är kontrollerade.
                continue
            }

            # Kontrollerar att vanliga textfält inte är tomma.
            if ($null -eq $value -or [string]::IsNullOrWhiteSpace($value.ToString())) {
                Write-Host "Användardata har tomt fält: $field" -ForegroundColor Red
                return $false
            }
        }
        # VALIDERING: E-POST
        if ($user.email -notmatch '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') {
         Write-Host "Ogiltigt e-postformat: $($user.email)" -ForegroundColor Red
         return $false
        }
        # validering: användarnamn
        if ($user.username -notmatch '^[a-zA-Z0-9._-]+$') {
        Write-Host "Ogiltigt användarnamn: $($user.username)" -ForegroundColor Red
        return $false
        }
        # validering: grupp
        if ($user.groups -isnot [array] -or $user.groups.Count -eq 0) {
        Write-Host "Användaren $($user.username) måste tillhöra minst en grupp." -ForegroundColor Red
        return $false
        }

        # Skrivs ut när en användare har passerat alla kontroller.
        Write-Host "Användardata för $($user.firstName) $($user.lastName) är giltig." -ForegroundColor Green
    }

    # Om alla användare har kontrollerats utan fel returneras true.
    return $true
}