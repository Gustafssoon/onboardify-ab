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
    $username = ($User.firstName.Substring(0,1) + $User.lastName).ToLower()

    #Skapa en tabell med de attribut som skall användas för att skapa användaren i AD
    $userAttributes = @{
        "sAMAccountName" = $username
        "givenName" = $User.firstName
        "sn" = $User.lastName
        "displayName" = "$($User.firstName) $($User.lastName)"
        "mail" = $User.email
        "Path" = $User.organizationUnit
        "memberOf" = $User.groups
    }

    #Kontrollera att användaren inte redan finns i AD
    if (Get-ADUser -Filter { sAMAccountName -eq $username }) {
        throw "Användaren $username finns redan i AD."
        return
    }
    else {
        #Skapa användaren i AD med attribut från $userAttributes och randomizerat lösenord med 12 tecken och 2 icke-alfanumeriska tecken.
        $password = [System.Web.Security.Membership]::GeneratePassword(12, 2)
        New-ADUser @userAttributes -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) -enabled $true
        Write-Host "Användaren $username har skapats i AD med lösenord: $password"
        return
    }
}
        