# Onboardify.Discovery.psm1


# Modul för att läsa av befintlig AD-struktur.
# Syftet med modulen är att hämta information från Active Directory
# som Onboardify kan använda i GUI:t.

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Export-OnboardifyADStructure {
    [CmdletBinding()]
    param(
        # Sökvägen där den genererade AD-strukturen ska sparas.
        # Om inget anges används config/ad-structure.generated.json.
        [string]$OutputPath,

        # Sökbas för grupper.
        # Om inget anges används Onboardifys standard-OU för grupper.
        [string]$GroupSearchBase
    )

    try {
        # Om ingen sökväg skickas in räknar vi ut projektets rotmapp.
        # Modulen ligger i src/modules, därför går vi två steg upp.
        if ([string]::IsNullOrWhiteSpace($OutputPath)) {
            $RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
            $OutputPath = Join-Path $RepoRoot "config\ad-structure.generated.json"
        }

        # Hämtar mappen där JSON-filen ska sparas.
        $OutputFolder = Split-Path $OutputPath -Parent

        # Skapar config-mappen om den inte redan finns.
        if (!(Test-Path $OutputFolder)) {
            New-Item -Path $OutputFolder -ItemType Directory -Force -ErrorAction Stop | Out-Null
        }

        # Laddar Active Directory-modulen.
        # Den behövs för kommandon som Get-ADOrganizationalUnit och Get-ADGroup.
        Import-Module ActiveDirectory -ErrorAction Stop

        # Hämtar domänens DistinguishedName.
        # Exempel: DC=onboardify,DC=local
        $DomainDistinguishedName = (Get-ADDomain -ErrorAction Stop).DistinguishedName

        # Om ingen GroupSearchBase anges använder vi Onboardifys grupp-OU.
        # Det gör att vi slipper få med inbyggda Windows-grupper som Administrators,
        # Account Operators och liknande.
        if ([string]::IsNullOrWhiteSpace($GroupSearchBase)) {
            $GroupSearchBase = "OU=Grupper,OU=Demokommun,OU=Onboardify,$DomainDistinguishedName"
        }

        # Hämtar alla OU:er från AD.
        # GUI:t använder dessa för att HR ska kunna välja rätt placering för användaren.
        $OrganizationalUnits = Get-ADOrganizationalUnit `
            -Filter * `
            -Properties Name, DistinguishedName `
            -ErrorAction Stop |
            Sort-Object DistinguishedName |
            Select-Object `
                @{ Name = "name"; Expression = { $_.Name } },
                @{ Name = "distinguishedName"; Expression = { $_.DistinguishedName } }

        # Kontrollerar att grupp-OU:n finns innan vi försöker läsa grupper därifrån.
        # Annars får vi ett tydligare felmeddelande.
        if (-not (Test-Path "AD:\$GroupSearchBase")) {
            throw "Grupp-OU hittades inte: $GroupSearchBase"
        }

        # Hämtar grupper från Onboardifys grupp-OU.
        # Dessa grupper kan sedan visas som valbara alternativ i GUI:t.
        $Groups = Get-ADGroup `
            -Filter * `
            -SearchBase $GroupSearchBase `
            -Properties Name, SamAccountName, DistinguishedName `
            -ErrorAction Stop |
            Sort-Object Name |
            Select-Object `
                @{ Name = "name"; Expression = { $_.Name } },
                @{ Name = "samAccountName"; Expression = { $_.SamAccountName } },
                @{ Name = "distinguishedName"; Expression = { $_.DistinguishedName } }

        # Bygger objektet som ska sparas till JSON.
        # Det här är strukturen som GUI:t senare läser in.
        $AdStructure = [PSCustomObject]@{
            generatedAt         = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            sourceDomain        = $env:USERDNSDOMAIN
            organizationalUnits = @($OrganizationalUnits)
            groups              = @($Groups)
        }

        # Sparar AD-strukturen som JSON.
        # Depth 5 gör att nästlade objekt inte kapas.
        $AdStructure |
            ConvertTo-Json -Depth 5 |
            Set-Content -Path $OutputPath -Encoding UTF8 -ErrorAction Stop

        Write-Host "AD-struktur sparad till: $OutputPath" -ForegroundColor Green

        # Returnerar även objektet så att GUI:t eller tester kan använda resultatet direkt.
        return $AdStructure
    }
    catch {
        # Skriver ut ett tydligt fel och kastar sedan felet vidare.
        # Det gör att huvudscriptet eller GUI:t kan fånga upp felet.
        Write-Host "Fel vid skanning av AD-struktur: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}

# Exporterar bara den funktion som andra script ska kunna använda.
Export-ModuleMember -Function Export-OnboardifyADStructure