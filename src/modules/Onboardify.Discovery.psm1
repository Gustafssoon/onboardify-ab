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

    Write-Host "AD-skanner är inte implementerad ännu."
}

Export-ModuleMember -Function Export-OnboardifyADStructure