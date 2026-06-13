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

        # Används i felmeddelanden. Username kan saknas eftersom det skapas automatiskt senare.
        $displayName = "$($user.firstName) $($user.lastName)".Trim()

        if ([string]::IsNullOrWhiteSpace($displayName)) {
            $displayName = "Okänd användare"
        }

        foreach ($field in $requiredFields) {

            # Kontrollerar att fältet finns på användarobjektet.
            if (-not ($user.PSObject.Properties.Name -contains $field)) {
                Write-Host "VALIDERINGSFEL: Saknat fält | Användare: $displayName | Fält: $field" -ForegroundColor Red
                return $false
            }

            # Hämtar värdet från fältet som kontrolleras.
            $value = $user.$field

            # groups är en lista och behöver därför kontrolleras lite annorlunda än vanliga textfält.
            if ($field -eq "groups") {

                # Kontrollerar att groups inte saknas helt.
                if ($null -eq $value) {
                    Write-Host "VALIDERINGSFEL: Saknar grupper | Användare: $displayName" -ForegroundColor Red
                    return $false
                }

                # Gör om groups till en lista så att både en grupp och flera grupper kan hanteras.
                $groups = @($value)

                # Letar efter tomma eller ogiltiga gruppnamn.
                $invalidGroups = @($groups | Where-Object {
                    [string]::IsNullOrWhiteSpace($_.ToString())
                })

                # Kontrollerar att minst en grupp finns och att gruppnamnen inte är tomma.
                if ($groups.Count -eq 0 -or $invalidGroups.Count -gt 0) {
                    Write-Host "VALIDERINGSFEL: Gruppfältet innehåller inga giltiga grupper | Användare: $displayName" -ForegroundColor Red
                    return $false
                }

                # Hoppar vidare till nästa fält när grupperna är kontrollerade.
                continue
            }

            # Kontrollerar att vanliga textfält inte är tomma.
            if ($null -eq $value -or [string]::IsNullOrWhiteSpace($value.ToString())) {
                Write-Host "VALIDERINGSFEL: Tomt fält | Användare: $displayName | Fält: $field" -ForegroundColor Red
                return $false
            }
        }

        # Validerar email om fältet finns och inte är tomt.
        # Email är inte obligatoriskt eftersom det kan skapas automatiskt av Onboardify.
        if ($user.PSObject.Properties.Name -contains "email" -and
            -not [string]::IsNullOrWhiteSpace($user.email)) {

            if ($user.email -notmatch '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') {
                Write-Host "VALIDERINGSFEL: Ogiltig e-post | Användare: $displayName | Värde: $($user.email)" -ForegroundColor Red
                return $false
            }
        }

        # Validerar username om fältet finns och inte är tomt.
        # Username är inte obligatoriskt eftersom det kan skapas automatiskt av Onboardify.
        if ($user.PSObject.Properties.Name -contains "username" -and
            -not [string]::IsNullOrWhiteSpace($user.username)) {

            if ($user.username -notmatch '^[a-zA-Z0-9._-]+$') {
                Write-Host "VALIDERINGSFEL: Ogiltigt användarnamn | Användare: $displayName | Värde: $($user.username)" -ForegroundColor Red
                return $false
            }
        }

        # Skrivs ut när en användare har passerat alla kontroller.
        Write-Host "VALIDERING OK | Användare: $displayName | Status: Godkänd" -ForegroundColor Green
    }

    # Om alla användare har kontrollerats utan fel returneras true.
    return $true
}
