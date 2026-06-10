# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function New-OnboardifyADUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [PSObject]$User,

        [Parameter(Mandatory = $false)]
        [string]$Path = 'CN=Users,DC=example,DC=com'
    )

    #Skapa användarnamn genom att kombinera förnamn och efternamn
    $username = ($User.firstName.Substring(0,1) + $User.lastName).ToLower()
}
        