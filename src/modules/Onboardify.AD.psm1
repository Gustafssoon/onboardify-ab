# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
function Convert-ToAscii {
    param(
        [string]$Text
    )

    $Text = $Text.ToLower()

    $replacements = @{
        'å' = 'a'
        'ä' = 'a'
        'ö' = 'o'
        'é' = 'e'
        'è' = 'e'
        'ê' = 'e'
        'ü' = 'u'
        'û' = 'u'
    }

    foreach ($key in $replacements.Keys) {
        $Text = $Text.Replace($key, $replacements[$key])
    }

    return $Text
}
function Get-NextSamAccountName {
    param(
        [string]$FirstName,
        [string]$LastName
    )

    $firstNameClean = Convert-ToAscii $FirstName
    $lastNameClean = Convert-ToAscii $LastName

    $prefix = (
        $firstNameClean.Substring(0,3) +
        $lastNameClean.Substring(0,1)
    ).ToLower()

    $existingUsers = Get-ADUser `
        -Filter "SamAccountName -like '$prefix*'" `
        -Properties SamAccountName

    $highestNumber = 99

    foreach ($existingUser in $existingUsers) {

        if ($existingUser.SamAccountName -match "^$prefix(\d+)$") {

            $number = [int]$matches[1]

            if ($number -gt $highestNumber) {
                $highestNumber = $number
            }
        }
    }

    return "$prefix$($highestNumber + 1)"
}
function New-OnboardifyADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject]$User
    )

    #Skapa användarnamn genom att kombinera förnamn och efternamn
    $username = Get-NextSamAccountName `
    -FirstName $User.firstName `
    -LastName $User.lastName

    # Skapa en tabell med attribut som används för att skapa användaren i AD
    $userAttributes = @{
        SamAccountName = $username
        GivenName      = $User.firstName
        Surname        = $User.lastName
        DisplayName    = "$($User.firstName) $($User.lastName)"
        EmailAddress   = $User.email
        Path           = $User.organizationUnit
        Name           = "$($User.firstName) $($User.lastName)"
    }

    try {
        
        # Skapa randomiserat lösenord med 12 tecken och 2 icke-alfanumeriska tecken
        $password = [System.Web.Security.Membership]::GeneratePassword(12, 2)

        # Skapa användaren i AD
        New-ADUser @userAttributes `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true `
            -ErrorAction Stop

        # Lägg till användaren i grupper efter att kontot har skapats
        foreach ($group in $User.groups) {
            Add-ADGroupMember -Identity $group -Members $username -ErrorAction Stop
        }

        Write-Host "Användaren $username har skapats i AD med lösenord: $password" -ForegroundColor Green
    }
    catch {
        Write-Host "Fel vid skapande av användaren $username: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}
        
