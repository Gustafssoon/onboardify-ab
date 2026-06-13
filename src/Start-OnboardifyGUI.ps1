# Start-OnboardifyGUI.ps1
# Enkel WinForms-prototyp för Onboardify AB.
# Den här filen är bara själva GUI-skalet.
# AD-logik och onboarding-logik ska ligga kvar i befintliga moduler och script.

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

# Sökvägar som GUI:t kommer använda senare.
$script:StructurePath = Join-Path $script:RepoRoot "config\ad-structure.generated.json"
$script:HrRequestFolder = Join-Path $script:RepoRoot "data\hr-requests\pending"

# ------------------------------------------------------------
# HJÄLPFUNKTIONER
# ------------------------------------------------------------

function Write-GuiStatus {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Message
    )

    # Skriver en rad i statusrutan längst ner i GUI:t.
    $txtStatus.AppendText("$Message`r`n")
}

# ------------------------------------------------------------
# HUVUDFÖNSTER
# ------------------------------------------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "Onboardify AB"
$form.Size = New-Object System.Drawing.Size(780, 540)
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
$tabs.Size = New-Object System.Drawing.Size(720, 285)
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
$lblITPrepareInfo.Text = "Nästa commit kopplar denna vy till AD-skannern."
$lblITPrepareInfo.Location = New-Object System.Drawing.Point(20, 60)
$lblITPrepareInfo.Size = New-Object System.Drawing.Size(650, 25)
$tabITPrepare.Controls.Add($lblITPrepareInfo)

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
$lblStatus.Location = New-Object System.Drawing.Point(20, 395)
$lblStatus.Size = New-Object System.Drawing.Size(720, 20)
$form.Controls.Add($lblStatus)

$txtStatus = New-Object System.Windows.Forms.TextBox
$txtStatus.Multiline = $true
$txtStatus.ReadOnly = $true
$txtStatus.ScrollBars = "Vertical"
$txtStatus.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtStatus.Location = New-Object System.Drawing.Point(20, 420)
$txtStatus.Size = New-Object System.Drawing.Size(720, 65)
$form.Controls.Add($txtStatus)

Write-GuiStatus "Onboardify GUI startat."
Write-GuiStatus "Börja med fliken IT - Förbered."

# Startar själva Windows-fönstret.
[void]$form.ShowDialog()