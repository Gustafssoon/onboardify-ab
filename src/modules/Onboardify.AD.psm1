# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function New-OnboardifyADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject]$User
    )

    #Skapa användarnamn genom att kombinera förnamn och efternamn
    $username = ($User.firstName.Substring(0, 1) + $User.lastName).ToLower()

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
        #Kontrollera om användaren redan finns i AD
        if (Get-ADUser -Filter { sAMAccountName -eq $username }) {
            Write-Host "Användaren $username finns redan i AD." -ForegroundColor Yellow
            return
        }
        
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
        
