# Onboardify.Discovery.psm1
# ==========================================
# Modul för att läsa av befintlig AD-struktur.
# Den här modulen ska bara läsa information och inte ändra något i AD.
# ==========================================

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

function Export-OnboardifyADStructure {
    [CmdletBinding()]
    param(
        [string]$OutputPath
    )

    try {
        # Importerar loggmodulen om den finns.
        $LoggingModulePath = Join-Path $PSScriptRoot "Onboardify.Logging.psm1"

        if (Test-Path $LoggingModulePath) {
            Import-Module $LoggingModulePath -Force
        }

        # Om ingen sökväg anges sparas filen i config-mappen.
        if ([string]::IsNullOrWhiteSpace($OutputPath)) {
            $RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
            $OutputPath = Join-Path $RepoRoot "config\ad-structure.generated.json"
        }

        # Skapar output-mappen om den saknas.
        $OutputFolder = Split-Path $OutputPath -Parent

        if (!(Test-Path $OutputFolder)) {
            New-Item `
                -Path $OutputFolder `
                -ItemType Directory `
                -Force `
                -ErrorAction Stop | Out-Null
        }

        # ActiveDirectory-modulen krävs för Get-ADOrganizationalUnit.
        Import-Module ActiveDirectory -ErrorAction Stop

        if (Get-Command Write-OnboardifyLog -ErrorAction SilentlyContinue) {
            Write-OnboardifyLog "Startar skanning av OU-struktur i Active Directory."
        }

        # Hämtar alla OU:er från AD.
        # Detta är endast läsning och gör inga ändringar i AD.
        $OrganizationalUnits = Get-ADOrganizationalUnit `
            -Filter * `
            -Properties Name, DistinguishedName `
            -ErrorAction Stop |
            Sort-Object DistinguishedName |
            Select-Object `
                @{ Name = "name"; Expression = { $_.Name } },
                @{ Name = "distinguishedName"; Expression = { $_.DistinguishedName } }

        # Skapar ett tydligt JSON-objekt.
        $AdStructure = [PSCustomObject]@{
            generatedAt         = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            sourceDomain        = $env:USERDNSDOMAIN
            organizationalUnits = @($OrganizationalUnits)
        }

        # Sparar resultatet till JSON.
        $AdStructure |
            ConvertTo-Json -Depth 5 |
            Set-Content -Path $OutputPath -Encoding UTF8 -ErrorAction Stop

        if (Get-Command Write-OnboardifyLog -ErrorAction SilentlyContinue) {
            Write-OnboardifyLog "OU-struktur sparad till: $OutputPath" "OK"
        }
        else {
            Write-Host "OU-struktur sparad till: $OutputPath"
        }

        return $AdStructure
    }
    catch {
        if (Get-Command Write-OnboardifyLog -ErrorAction SilentlyContinue) {
            Write-OnboardifyLog "Fel vid skanning av OU-struktur: $($_.Exception.Message)" "FEL"
        }

        throw
    }
}

Export-ModuleMember -Function Export-OnboardifyADStructure