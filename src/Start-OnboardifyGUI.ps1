# Start-OnboardifyGUI.ps1
# Enkel WinForms-prototyp för Onboardify AB.
# GUI:t ska hjälpa både IT och HR utan att lägga AD-logik direkt i formuläret.

$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
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

function Get-OnboardifyAdStructure {
    <#
        Läser strukturfilen som IT skapat med AD-skannern.

        HR-fliken använder den här filen för att veta vilka OU:er
        som är godkända att välja mellan.
    #>

    if (-not (Test-Path $script:StructurePath)) {
        throw "Strukturfilen finns inte. IT måste köra AD-skannern först."
    }

    $structure = Get-Content -Path $script:StructurePath -Raw -Encoding UTF8 |
        ConvertFrom-Json

    return $structure
}

function Update-HrOuList {
    <#
        Läser OU:er från config/ad-structure.generated.json
        och fyller dropdown-listan i HR-fliken.
    #>

    $cmbOrganizationUnit.Items.Clear()

    $structure = Get-OnboardifyAdStructure
    $organizationalUnits = @($structure.organizationalUnits)

    if ($organizationalUnits.Count -eq 0) {
        throw "Strukturfilen innehåller inga OU:er."
    }

    foreach ($ou in $organizationalUnits) {
        [void]$cmbOrganizationUnit.Items.Add($ou.distinguishedName)
    }

    $cmbOrganizationUnit.SelectedIndex = 0

    return $structure
}

function New-HrUserPreviewObject {
    <#
        Bygger ett PowerShell-objekt av det HR har fyllt i.

        Objektet följer samma grundstruktur som vår JSON/CSV-data
        och kan senare sparas som JSON.
    #>

    $groups = @(
        $txtGroups.Text.Split(",") |
            ForEach-Object { $_.Trim() } |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) }
    )

    $user = [PSCustomObject]@{
        firstName        = $txtFirstName.Text.Trim()
        lastName         = $txtLastName.Text.Trim()
        title            = $txtTitle.Text.Trim()
        organizationUnit = $cmbOrganizationUnit.Text.Trim()
        department       = $txtDepartment.Text.Trim()
        groups           = $groups
        license          = $cmbLicense.Text.Trim()
    }

    return $user
}

function Save-HrRequestAsJson {
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$User
    )

    # Skapar mappen om den inte finns.
    # HR-underlag ska hamna här tills IT har behandlat filen.
    if (-not (Test-Path $script:HrRequestFolder)) {
        New-Item -Path $script:HrRequestFolder -ItemType Directory -Force | Out-Null
    }

    # Skapar ett enkelt filnamn baserat på datum och namn.
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $safeFirstName = $User.firstName -replace '[^a-zA-ZåäöÅÄÖ0-9]', ''
    $safeLastName = $User.lastName -replace '[^a-zA-ZåäöÅÄÖ0-9]', ''

    $fileName = "onboarding_${timestamp}_${safeFirstName}_${safeLastName}.json"
    $filePath = Join-Path $script:HrRequestFolder $fileName

    # Sparar som en array eftersom import/validering jobbar med en lista av användare.
    @($User) |
        ConvertTo-Json -Depth 5 |
        Set-Content -Path $filePath -Encoding UTF8

    return $filePath
}

function Test-HrFormInput {
    <#
        Enkel kontroll i GUI:t innan HR-underlaget visas.
        Den riktiga valideringen finns i Onboardify.Validation.psm1,
        men GUI:t kan fånga upp enkla fel direkt.
    #>

    $missingFields = @()

    if ([string]::IsNullOrWhiteSpace($txtFirstName.Text)) {
        $missingFields += "Förnamn"
    }

    if ([string]::IsNullOrWhiteSpace($txtLastName.Text)) {
        $missingFields += "Efternamn"
    }

    if ([string]::IsNullOrWhiteSpace($txtTitle.Text)) {
        $missingFields += "Titel"
    }

    if ([string]::IsNullOrWhiteSpace($txtDepartment.Text)) {
        $missingFields += "Avdelning"
    }

    if ([string]::IsNullOrWhiteSpace($cmbOrganizationUnit.Text)) {
        $missingFields += "OU"
    }

    if ([string]::IsNullOrWhiteSpace($txtGroups.Text)) {
        $missingFields += "Grupper"
    }

    if ([string]::IsNullOrWhiteSpace($cmbLicense.Text)) {
        $missingFields += "Licens"
    }

    if ($missingFields.Count -gt 0) {
        $message = "Följande fält saknas: $($missingFields -join ', ')"
        [System.Windows.Forms.MessageBox]::Show(
            $message,
            "Saknade fält",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        ) | Out-Null

        return $false
    }

    return $true
}

function Add-FormLabel {
    param(
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Control]$Parent,

        [Parameter(Mandatory = $true)]
        [string]$Text,

        [Parameter(Mandatory = $true)]
        [int]$X,

        [Parameter(Mandatory = $true)]
        [int]$Y
    )

    $label = New-Object System.Windows.Forms.Label
    $label.Text = $Text
    $label.Location = New-Object System.Drawing.Point($X, $Y)
    $label.Size = New-Object System.Drawing.Size(130, 22)
    $Parent.Controls.Add($label)

    return $label
}

function Add-TextBox {
    param(
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Control]$Parent,

        [Parameter(Mandatory = $true)]
        [int]$X,

        [Parameter(Mandatory = $true)]
        [int]$Y,

        [int]$Width = 260
    )

    $textBox = New-Object System.Windows.Forms.TextBox
    $textBox.Location = New-Object System.Drawing.Point($X, $Y)
    $textBox.Size = New-Object System.Drawing.Size($Width, 22)
    $Parent.Controls.Add($textBox)

    return $textBox
}

function Add-ComboBox {
    param(
        [Parameter(Mandatory = $true)]
        [System.Windows.Forms.Control]$Parent,

        [Parameter(Mandatory = $true)]
        [int]$X,

        [Parameter(Mandatory = $true)]
        [int]$Y,

        [int]$Width = 260
    )

    $comboBox = New-Object System.Windows.Forms.ComboBox
    $comboBox.Location = New-Object System.Drawing.Point($X, $Y)
    $comboBox.Size = New-Object System.Drawing.Size($Width, 22)
    $comboBox.DropDownStyle = "DropDownList"
    $Parent.Controls.Add($comboBox)

    return $comboBox
}

# ------------------------------------------------------------
# HUVUDFÖNSTER
# ------------------------------------------------------------

$form = New-Object System.Windows.Forms.Form
$form.Text = "Onboardify AB"
$form.Size = New-Object System.Drawing.Size(900, 660)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false

# Rubrik högst upp.
$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Onboardify AB - Onboardingverktyg"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(840, 35)
$form.Controls.Add($lblTitle)

# Kort beskrivning under rubriken.
$lblDescription = New-Object System.Windows.Forms.Label
$lblDescription.Text = "IT förbereder AD-struktur, HR skapar underlag och IT kör onboarding."
$lblDescription.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblDescription.Location = New-Object System.Drawing.Point(22, 55)
$lblDescription.Size = New-Object System.Drawing.Size(840, 25)
$form.Controls.Add($lblDescription)

# Flikar för de tre huvudstegen.
$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(20, 95)
$tabs.Size = New-Object System.Drawing.Size(840, 390)
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
$lblITPrepare.Size = New-Object System.Drawing.Size(760, 25)
$tabITPrepare.Controls.Add($lblITPrepare)

$lblITPrepareInfo = New-Object System.Windows.Forms.Label
$lblITPrepareInfo.Text = "Skanningen sparar AD-strukturen till config/ad-structure.generated.json."
$lblITPrepareInfo.Location = New-Object System.Drawing.Point(20, 55)
$lblITPrepareInfo.Size = New-Object System.Drawing.Size(760, 25)
$tabITPrepare.Controls.Add($lblITPrepareInfo)

$btnScanAD = New-Object System.Windows.Forms.Button
$btnScanAD.Text = "Skanna AD"
$btnScanAD.Location = New-Object System.Drawing.Point(20, 95)
$btnScanAD.Size = New-Object System.Drawing.Size(160, 40)
$tabITPrepare.Controls.Add($btnScanAD)

$lblScanResult = New-Object System.Windows.Forms.Label
$lblScanResult.Text = "Status: AD är inte skannat ännu."
$lblScanResult.Location = New-Object System.Drawing.Point(20, 150)
$lblScanResult.Size = New-Object System.Drawing.Size(760, 25)
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
$lblHR.Text = "Steg 2: HR fyller i uppgifter om nyanställda och bygger ett onboarding-underlag."
$lblHR.Location = New-Object System.Drawing.Point(20, 20)
$lblHR.Size = New-Object System.Drawing.Size(780, 25)
$tabHR.Controls.Add($lblHR)

$lblHRInfo = New-Object System.Windows.Forms.Label
$lblHRInfo.Text = "Börja med att läsa in AD-strukturen som IT har skannat fram."
$lblHRInfo.Location = New-Object System.Drawing.Point(20, 45)
$lblHRInfo.Size = New-Object System.Drawing.Size(780, 25)
$tabHR.Controls.Add($lblHRInfo)

$btnLoadStructure = New-Object System.Windows.Forms.Button
$btnLoadStructure.Text = "Läs in AD-struktur"
$btnLoadStructure.Location = New-Object System.Drawing.Point(20, 75)
$btnLoadStructure.Size = New-Object System.Drawing.Size(160, 35)
$tabHR.Controls.Add($btnLoadStructure)

$lblHrStructureStatus = New-Object System.Windows.Forms.Label
$lblHrStructureStatus.Text = "Status: AD-struktur är inte inläst."
$lblHrStructureStatus.Location = New-Object System.Drawing.Point(200, 82)
$lblHrStructureStatus.Size = New-Object System.Drawing.Size(580, 25)
$tabHR.Controls.Add($lblHrStructureStatus)

# Vänster kolumn.
Add-FormLabel -Parent $tabHR -Text "Förnamn" -X 20 -Y 130 | Out-Null
$txtFirstName = Add-TextBox -Parent $tabHR -X 150 -Y 128 -Width 240

Add-FormLabel -Parent $tabHR -Text "Efternamn" -X 20 -Y 160 | Out-Null
$txtLastName = Add-TextBox -Parent $tabHR -X 150 -Y 158 -Width 240

Add-FormLabel -Parent $tabHR -Text "Titel" -X 20 -Y 190 | Out-Null
$txtTitle = Add-TextBox -Parent $tabHR -X 150 -Y 188 -Width 240

Add-FormLabel -Parent $tabHR -Text "Avdelning" -X 20 -Y 220 | Out-Null
$txtDepartment = Add-TextBox -Parent $tabHR -X 150 -Y 218 -Width 240

# Höger kolumn.
Add-FormLabel -Parent $tabHR -Text "OU" -X 430 -Y 130 | Out-Null
$cmbOrganizationUnit = Add-ComboBox -Parent $tabHR -X 560 -Y 128 -Width 250

Add-FormLabel -Parent $tabHR -Text "Grupper" -X 430 -Y 160 | Out-Null
$txtGroups = Add-TextBox -Parent $tabHR -X 560 -Y 158 -Width 250
$txtGroups.Text = "ExempelGrupp"

Add-FormLabel -Parent $tabHR -Text "Licens" -X 430 -Y 190 | Out-Null
$cmbLicense = Add-ComboBox -Parent $tabHR -X 560 -Y 188 -Width 250

[void]$cmbLicense.Items.Add("Microsoft 365 F3")
[void]$cmbLicense.Items.Add("Microsoft 365 E3")
[void]$cmbLicense.Items.Add("Microsoft 365 Business Standard")
$cmbLicense.SelectedIndex = 0

$lblGroupsHelp = New-Object System.Windows.Forms.Label
$lblGroupsHelp.Text = "Flera grupper kan skrivas med kommatecken, till exempel: Lärare, Pedagoger"
$lblGroupsHelp.Location = New-Object System.Drawing.Point(560, 220)
$lblGroupsHelp.Size = New-Object System.Drawing.Size(260, 45)
$tabHR.Controls.Add($lblGroupsHelp)

$btnPreviewHrData = New-Object System.Windows.Forms.Button
$btnPreviewHrData.Text = "Förhandsgranska underlag"
$btnPreviewHrData.Location = New-Object System.Drawing.Point(20, 275)
$btnPreviewHrData.Size = New-Object System.Drawing.Size(190, 40)
$tabHR.Controls.Add($btnPreviewHrData)

$btnSaveHrData = New-Object System.Windows.Forms.Button
$btnSaveHrData.Text = "Spara JSON-underlag"
$btnSaveHrData.Location = New-Object System.Drawing.Point(225, 275)
$btnSaveHrData.Size = New-Object System.Drawing.Size(170, 40)
$tabHR.Controls.Add($btnSaveHrData)

$btnClearHrForm = New-Object System.Windows.Forms.Button
$btnClearHrForm.Text = "Rensa HR-formulär"
$btnClearHrForm.Location = New-Object System.Drawing.Point(410, 275)
$btnClearHrForm.Size = New-Object System.Drawing.Size(150, 40)
$tabHR.Controls.Add($btnClearHrForm)

$btnLoadStructure.Add_Click({
    try {
        Clear-GuiStatus
        Write-GuiStatus "Läser in AD-struktur för HR..."

        $structure = Update-HrOuList

        Write-GuiStatus "AD-struktur inläst."
        Write-GuiStatus "Strukturfil:"
        Write-GuiStatus $script:StructurePath
        Write-GuiStatus "Skapad: $($structure.generatedAt)"
        Write-GuiStatus "Antal OU:er: $($structure.organizationalUnits.Count)"

        $lblHrStructureStatus.Text = "Status: AD-struktur inläst. HR kan välja OU."
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
        $lblHrStructureStatus.Text = "Status: Kunde inte läsa in AD-struktur."
    }
})

$btnPreviewHrData.Add_Click({
    Clear-GuiStatus

    if (-not (Test-HrFormInput)) {
        Write-GuiStatus "HR-underlaget är inte komplett."
        return
    }

    $user = New-HrUserPreviewObject

    Write-GuiStatus "Förhandsgranskning av HR-underlag:"
    Write-GuiStatus ""
    Write-GuiStatus "Förnamn: $($user.firstName)"
    Write-GuiStatus "Efternamn: $($user.lastName)"
    Write-GuiStatus "Titel: $($user.title)"
    Write-GuiStatus "Avdelning: $($user.department)"
    Write-GuiStatus "OU: $($user.organizationUnit)"
    Write-GuiStatus "Grupper: $($user.groups -join ', ')"
    Write-GuiStatus "Licens: $($user.license)"
    Write-GuiStatus ""
    Write-GuiStatus "Nästa commit sparar detta som JSON-underlag till IT."
})

$btnSaveHrData.Add_Click({
    Clear-GuiStatus

    if (-not (Test-HrFormInput)) {
        Write-GuiStatus "HR-underlaget är inte komplett."
        return
    }

    try {
        $user = New-HrUserPreviewObject
        $filePath = Save-HrRequestAsJson -User $user

        Write-GuiStatus "HR-underlag sparat som JSON."
        Write-GuiStatus ""
        Write-GuiStatus "Fil:"
        Write-GuiStatus $filePath
        Write-GuiStatus ""
        Write-GuiStatus "Nästa steg:"
        Write-GuiStatus "Skicka ärendet vidare till IT så att filen kan valideras och köras i Onboardify."
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
    }
})

$btnClearHrForm.Add_Click({
    $txtFirstName.Clear()
    $txtLastName.Clear()
    $txtTitle.Clear()
    $txtDepartment.Clear()
    $txtGroups.Text = "ExempelGrupp"

    if ($cmbLicense.Items.Count -gt 0) {
        $cmbLicense.SelectedIndex = 0
    }

    Clear-GuiStatus
    Write-GuiStatus "HR-formuläret har rensats."
})

# ------------------------------------------------------------
# IT - KÖR ONBOARDING
# ------------------------------------------------------------

$lblITRun = New-Object System.Windows.Forms.Label
$lblITRun.Text = "Steg 3: IT läser HR-underlaget och kör onboarding."
$lblITRun.Location = New-Object System.Drawing.Point(20, 25)
$lblITRun.Size = New-Object System.Drawing.Size(760, 25)
$tabITRun.Controls.Add($lblITRun)

$lblITRunInfo = New-Object System.Windows.Forms.Label
$lblITRunInfo.Text = "Den här vyn byggs ut senare så IT kan köra DemoMode eller skarp körning."
$lblITRunInfo.Location = New-Object System.Drawing.Point(20, 60)
$lblITRunInfo.Size = New-Object System.Drawing.Size(760, 25)
$tabITRun.Controls.Add($lblITRunInfo)

# ------------------------------------------------------------
# STATUSLOGG
# ------------------------------------------------------------

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Statuslogg:"
$lblStatus.Location = New-Object System.Drawing.Point(20, 500)
$lblStatus.Size = New-Object System.Drawing.Size(840, 20)
$form.Controls.Add($lblStatus)

$txtStatus = New-Object System.Windows.Forms.TextBox
$txtStatus.Multiline = $true
$txtStatus.ReadOnly = $true
$txtStatus.ScrollBars = "Vertical"
$txtStatus.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtStatus.Location = New-Object System.Drawing.Point(20, 525)
$txtStatus.Size = New-Object System.Drawing.Size(840, 80)
$form.Controls.Add($txtStatus)

Write-GuiStatus "Onboardify GUI startat."
Write-GuiStatus "Börja med IT - Förbered om AD-strukturen inte redan är skannad."
Write-GuiStatus "Gå sedan till HR - Underlag och läs in AD-strukturen."

# Startar själva Windows-fönstret.
[void]$form.ShowDialog()