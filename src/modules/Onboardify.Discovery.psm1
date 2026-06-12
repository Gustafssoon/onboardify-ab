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

    # Om ingen sökväg anges sparas filen i config-mappen.
    if ([string]::IsNullOrWhiteSpace($OutputPath)) {
        $RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
        $OutputPath = Join-Path $RepoRoot "config\ad-structure.generated.json"
    }

    # Skapar output-mappen om den saknas.
    $OutputFolder = Split-Path $OutputPath -Parent

    if (!(Test-Path $OutputFolder)) {
        New-Item -Path $OutputFolder -ItemType Directory -Force | Out-Null
    }

    Write-Host "AD-struktur kommer sparas till: $OutputPath"

    return $OutputPath
}

Export-ModuleMember -Function Export-OnboardifyADStructure