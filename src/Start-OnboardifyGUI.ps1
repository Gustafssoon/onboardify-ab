# Start-OnboardifyGUI.ps1
# Enkel WinForms-prototyp för Onboardify AB.
# GUI:t ska hjälpa både IT och HR utan att lägga AD-logik direkt i formuläret.

$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Läser in WinForms och Drawing så att vi kan bygga ett Windows-fönster.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Räknar ut projektets rotmapp.
# Eftersom den här filen ligger i src går vi ett steg upp.
$script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

# Sökvägar som GUI:t använder.
$script:StructurePath = Join-Path $script:RepoRoot "config\ad-structure.generated.json"
$script:HrRequestFolder = Join-Path $script:RepoRoot "data\hr-requests\pending"

# ------------------------------------------------------------
# HJÄLPFUNKTIONER
# ------------------------------------------------------------

function Write-GuiStatus {
    param(
        [AllowEmptyString()]
        [string]$Message = ""
    )

    # Skriver en rad i statusrutan längst ner i GUI:t.
    # AllowEmptyString gör att vi kan skriva tomma rader i loggen.
    $txtStatus.AppendText("$Message`r`n")
}

function Clear-GuiStatus {
    # Rensar statusrutan innan ett nytt steg startar.
    $txtStatus.Clear()
}

function Start-OnboardifyAdScan {
    <#
        Kör Onboardifys befintliga AD-skanner.

        Viktigt:
        GUI:t ska inte själv innehålla AD-logik.
        Därför importerar vi Onboardify.Discovery.psm1 och anropar
        Export-OnboardifyADStructure, som redan finns i projektet.
    #>

    $discoveryModule = Join-Path $PSScriptRoot "modules\Onboardify.Discovery.psm1"

    if (-not (Test-Path $discoveryModule)) {
        throw "Discovery-modulen hittades inte: $discoveryModule"
    }

    Import-Module $discoveryModule -Force -ErrorAction Stop

    $structure = Export-OnboardifyADStructure -OutputPath $script:StructurePath

    return $structure
}

# ------------------------------------------------------------
# HUVUDFÖNSTER
# ------------------------------------------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "Onboardify AB"
$form.Size = New-Object System.Drawing.Size(780, 560)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Rubrik högst upp.
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Onboardify AB - Onboardingverktyg"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(720, 35)
$form.Controls.Add($lblTitle)

# Kort beskrivning under rubriken.
$lblDescription = New-Object System.Windows.Forms.Label
$lblDescription.Text = "IT förbereder AD-struktur, HR skapar underlag och IT kör onboarding."
$lblDescription.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblDescription.Location = New-Object System.Drawing.Point(22, 55)
$lblDescription.Size = New-Object System.Drawing.Size(720, 25)
$form.Controls.Add($lblDescription)

# Flikar för de tre huvudstegen.
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(20, 95)
$tabs.Size = New-Object System.Drawing.Size(720, 300)
$form.Controls.Add($tabs)

# Flik 1: IT förbereder miljön.
$tabITPrepare = New-Object System.Windows.Forms.TabPage
$tabITPrepare.Text = "IT - Förbered"

# Flik 2: HR skapar onboarding-underlag.
$tabHR = New-Object System.Windows.Forms.TabPage
$tabHR.Text = "HR - Underlag"

# Flik 3: IT kör onboarding.
$tabITRun = New-Object System.Windows.Forms.TabPage
$tabITRun.Text = "IT - Kör onboarding"

$tabs.TabPages.Add($tabITPrepare)
$tabs.TabPages.Add($tabHR)
$tabs.TabPages.Add($tabITRun)

# ------------------------------------------------------------
# IT - FÖRBERED
# ------------------------------------------------------------

$lblITPrepare = New-Object System.Windows.Forms.Label
$lblITPrepare.Text = "Steg 1: IT skannar AD för att skapa godkända val till HR."
$lblITPrepare.Location = New-Object System.Drawing.Point(20, 25)
$lblITPrepare.Size = New-Object System.Drawing.Size(650, 25)
$tabITPrepare.Controls.Add($lblITPrepare)

$lblITPrepareInfo = New-Object System.Windows.Forms.Label
$lblITPrepareInfo.Text = "Skanningen sparar AD-strukturen till config/ad-structure.generated.json."
$lblITPrepareInfo.Location = New-Object System.Drawing.Point(20, 55)
$lblITPrepareInfo.Size = New-Object System.Drawing.Size(650, 25)
$tabITPrepare.Controls.Add($lblITPrepareInfo)

$btnScanAD = New-Object System.Windows.Forms.Button
$btnScanAD.Text = "Skanna AD"
$btnScanAD.Location = New-Object System.Drawing.Point(20, 95)
$btnScanAD.Size = New-Object System.Drawing.Size(160, 40)
$tabITPrepare.Controls.Add($btnScanAD)

$lblScanResult = New-Object System.Windows.Forms.Label
$lblScanResult.Text = "Status: AD är inte skannat ännu."
$lblScanResult.Location = New-Object System.Drawing.Point(20, 150)
$lblScanResult.Size = New-Object System.Drawing.Size(650, 25)
$tabITPrepare.Controls.Add($lblScanResult)

# När IT klickar på knappen körs AD-skannern.
$btnScanAD.Add_Click({
    try {
        Clear-GuiStatus
        Write-GuiStatus "Startar AD-skanning..."

        $structure = Start-OnboardifyAdScan

        Write-GuiStatus "AD-skanning klar."
        Write-GuiStatus "Strukturfil sparad:"
        Write-GuiStatus $script:StructurePath

        if ($structure.organizationalUnits) {
            Write-GuiStatus "Antal OU:er hittade: $($structure.organizationalUnits.Count)"
        }

        Write-GuiStatus ""
        Write-GuiStatus "Nästa steg:"
        Write-GuiStatus "Ärendet är redo att skickas vidare till HR."

        $lblScanResult.Text = "Status: AD-skanning klar. Ärendet är redo för HR."
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
        $lblScanResult.Text = "Status: AD-skanning misslyckades."
    }
})

# ------------------------------------------------------------
# HR - UNDERLAG
# ------------------------------------------------------------

$lblHR = New-Object System.Windows.Forms.Label
$lblHR.Text = "Steg 2: HR fyller i uppgifter om nyanställda."
$lblHR.Location = New-Object System.Drawing.Point(20, 25)
$lblHR.Size = New-Object System.Drawing.Size(650, 25)
$tabHR.Controls.Add($lblHR)

$lblHRInfo = New-Object System.Windows.Forms.Label
$lblHRInfo.Text = "Den här vyn byggs ut senare så HR kan skapa JSON-underlag."
$lblHRInfo.Location = New-Object System.Drawing.Point(20, 60)
$lblHRInfo.Size = New-Object System.Drawing.Size(650, 25)
$tabHR.Controls.Add($lblHRInfo)

# ------------------------------------------------------------
# IT - KÖR ONBOARDING
# ------------------------------------------------------------

$lblITRun = New-Object System.Windows.Forms.Label
$lblITRun.Text = "Steg 3: IT läser HR-underlaget och kör onboarding."
$lblITRun.Location = New-Object System.Drawing.Point(20, 25)
$lblITRun.Size = New-Object System.Drawing.Size(650, 25)
$tabITRun.Controls.Add($lblITRun)

$lblITRunInfo = New-Object System.Windows.Forms.Label
$lblITRunInfo.Text = "Den här vyn byggs ut senare så IT kan köra DemoMode eller skarp körning."
$lblITRunInfo.Location = New-Object System.Drawing.Point(20, 60)
$lblITRunInfo.Size = New-Object System.Drawing.Size(650, 25)
$tabITRun.Controls.Add($lblITRunInfo)

# ------------------------------------------------------------
# STATUSLOGG
# ------------------------------------------------------------

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Statuslogg:"
$lblStatus.Location = New-Object System.Drawing.Point(20, 410)
$lblStatus.Size = New-Object System.Drawing.Size(720, 20)
$form.Controls.Add($lblStatus)

$txtStatus = New-Object System.Windows.Forms.TextBox
$txtStatus.Multiline = $true
$txtStatus.ReadOnly = $true
$txtStatus.ScrollBars = "Vertical"
$txtStatus.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtStatus.Location = New-Object System.Drawing.Point(20, 435)
$txtStatus.Size = New-Object System.Drawing.Size(720, 70)
$form.Controls.Add($txtStatus)

Write-GuiStatus "Onboardify GUI startat."
Write-GuiStatus "Börja med fliken IT - Förbered och kör AD-skanning."

# Startar själva Windows-fönstret.
[void]$form.ShowDialog()