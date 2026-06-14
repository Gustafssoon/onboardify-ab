# Start-OnboardifyGUI.ps1
# Enkel WinForms-prototyp för Onboardify AB.
# GUI:t hjälper IT och HR utan att lägga AD-logik direkt i formuläret.

$ErrorActionPreference = "Stop"

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Läser in WinForms och Drawing så att vi kan bygga ett Windows-fönster.
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

# Räknar ut projektets rotmapp.
# Eftersom den här filen ligger i src går vi ett steg upp.
$script:RepoRoot = Resolve-Path (Join-Path $PSScriptRoot "..")

# Sökvägar som GUI:t använder.
$script:StructurePath = Join-Path $script:RepoRoot "config\ad-structure.generated.json"
$script:LicensesPath = Join-Path $script:RepoRoot "config\licenses.sample.json"
$script:OrgStructurePath = Join-Path $script:RepoRoot "config\org-structure.sample.json"
$script:TitlesPath = Join-Path $script:RepoRoot "config\titles.sample.json"
$script:HrRequestFolder = Join-Path $script:RepoRoot "data\hr-requests\pending"
$script:ProcessedHrRequestFolder = Join-Path $script:RepoRoot "data\hr-requests\processed"
$script:StartOnboardingPath = Join-Path $PSScriptRoot "Start-Onboarding.ps1"

# Globala värden som används i GUI:t.
$script:HrRequestFiles = @()
$script:DepartmentMap = @{}
$script:OrgStructure = $null
$script:AdStructure = $null
$script:AvailableAdGroups = @()
$script:AvailableFolderGroups = @()
$script:ExtraFolderAccessGroups = @()
$script:AvailableLicenses = @()
$script:SelectedLicenses = @()

# ------------------------------------------------------------
# HJÄLPFUNKTIONER
# ------------------------------------------------------------

function Write-GuiStatus {
    param(
        [AllowEmptyString()]
        [string]$Message = ""
    )

    $txtStatus.AppendText("$Message`r`n")
}

function Clear-GuiStatus {
    $txtStatus.Clear()
}

function Get-JsonConfig {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "Configfil saknas: $Path"
    }

    return Get-Content -Path $Path -Raw -Encoding UTF8 | ConvertFrom-Json
}

function Start-OnboardifyAdScan {
    # Kör Onboardifys befintliga AD-skanner.
    # GUI:t ska inte själv innehålla AD-logik.

    $discoveryModule = Join-Path $PSScriptRoot "modules\Onboardify.Discovery.psm1"

    if (-not (Test-Path $discoveryModule)) {
        throw "Discovery-modulen hittades inte: $discoveryModule"
    }

    Import-Module $discoveryModule -Force -ErrorAction Stop

    $structure = Export-OnboardifyADStructure -OutputPath $script:StructurePath

    return $structure
}

function Get-OnboardifyAdStructure {
    # Läser strukturfilen som IT har skapat med AD-skannern.
    # Filen innehåller bland annat OU:er och grupper.

    if (-not (Test-Path $script:StructurePath)) {
        throw "Strukturfilen finns inte. IT måste köra AD-skannern först."
    }

    $structure = Get-Content -Path $script:StructurePath -Raw -Encoding UTF8 |
        ConvertFrom-Json

    return $structure
}

function Update-HrCustomerOptionLists {
    # Fyller dropdowns/listor för titel, avdelning, enhet och licenser.
    # Grupper hämtas separat från AD-strukturen.

    $cmbTitle.Items.Clear()
    $cmbDepartment.Items.Clear()
    $cmbUnit.Items.Clear()

    $script:DepartmentMap = @{}

    $titleConfig = Get-JsonConfig -Path $script:TitlesPath
    $licenseConfig = Get-JsonConfig -Path $script:LicensesPath
    $script:OrgStructure = Get-JsonConfig -Path $script:OrgStructurePath

    foreach ($title in @($titleConfig.Titlar)) {
        [void]$cmbTitle.Items.Add($title)
    }

    foreach ($department in $script:OrgStructure.PSObject.Properties) {
        $displayName = $department.Value.DisplayName

        if ([string]::IsNullOrWhiteSpace($displayName)) {
            $displayName = $department.Name
        }

        $script:DepartmentMap[$displayName] = $department.Value
        [void]$cmbDepartment.Items.Add($displayName)
    }

    $script:AvailableLicenses = @($licenseConfig.Licenser)

    # Tar bort eventuella valda licenser som inte längre finns i configfilen.
    $script:SelectedLicenses = @(
        $script:SelectedLicenses |
            Where-Object { $script:AvailableLicenses -contains $_ }
    )

    if ($cmbTitle.Items.Count -gt 0) {
        $cmbTitle.SelectedIndex = 0
    }

    if ($cmbDepartment.Items.Count -gt 0) {
        $cmbDepartment.SelectedIndex = 0
        Update-HrUnitList
    }

    Update-SelectedLicensesText
    Update-ResolvedOuPreview
}

function Update-SelectedLicensesText {
    # Visar valda licenser i HR-formuläret.

    if (-not $txtSelectedLicenses) {
        return
    }

    if ($script:SelectedLicenses.Count -eq 0) {
        $txtSelectedLicenses.Text = "Inga licenser valda"
        return
    }

    $txtSelectedLicenses.Text = $script:SelectedLicenses -join ", "
}

function Show-LicenseSelectionDialog {
    # Öppnar ett separat fönster där HR kan välja flera licenser.

    if ($script:AvailableLicenses.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show(
            "Inga licenser finns inlästa. Kontrollera config/licenses.sample.json.",
            "Inga licenser",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        ) | Out-Null

        return
    }

    $dialog = New-Object System.Windows.Forms.Form
    $dialog.Text = "Välj licenser"
    $dialog.Size = New-Object System.Drawing.Size(430, 430)
    $dialog.StartPosition = "CenterParent"
    $dialog.FormBorderStyle = "FixedDialog"
    $dialog.MaximizeBox = $false
    $dialog.MinimizeBox = $false

    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.Text = "Välj en eller flera licenser för användaren."
    $lblInfo.Location = New-Object System.Drawing.Point(20, 20)
    $lblInfo.Size = New-Object System.Drawing.Size(370, 25)
    $dialog.Controls.Add($lblInfo)

    $licenseList = New-Object System.Windows.Forms.CheckedListBox
    $licenseList.Location = New-Object System.Drawing.Point(20, 55)
    $licenseList.Size = New-Object System.Drawing.Size(370, 250)
    $licenseList.CheckOnClick = $true
    $dialog.Controls.Add($licenseList)

    foreach ($license in $script:AvailableLicenses) {
        $index = $licenseList.Items.Add($license)

        if ($script:SelectedLicenses -contains $license) {
            $licenseList.SetItemChecked($index, $true)
        }
    }

    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Text = "OK"
    $btnOk.Location = New-Object System.Drawing.Point(210, 325)
    $btnOk.Size = New-Object System.Drawing.Size(80, 35)
    $btnOk.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $dialog.Controls.Add($btnOk)

    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Avbryt"
    $btnCancel.Location = New-Object System.Drawing.Point(310, 325)
    $btnCancel.Size = New-Object System.Drawing.Size(80, 35)
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $dialog.Controls.Add($btnCancel)

    $dialog.AcceptButton = $btnOk
    $dialog.CancelButton = $btnCancel

    $result = $dialog.ShowDialog($form)

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:SelectedLicenses = @(
            $licenseList.CheckedItems |
                ForEach-Object { $_.ToString() }
        )

        Update-SelectedLicensesText
    }

    $dialog.Dispose()
}

function Update-HrUnitList {
    # Fyller enhetslistan baserat på vald avdelning.

    $cmbUnit.Items.Clear()

    $selectedDepartment = $cmbDepartment.Text

    if ([string]::IsNullOrWhiteSpace($selectedDepartment)) {
        return
    }

    $departmentConfig = $script:DepartmentMap[$selectedDepartment]

    if (-not $departmentConfig -or -not $departmentConfig.Enheter) {
        return
    }

    foreach ($unit in $departmentConfig.Enheter.PSObject.Properties) {
        [void]$cmbUnit.Items.Add($unit.Name)
    }

    if ($cmbUnit.Items.Count -gt 0) {
        $cmbUnit.SelectedIndex = 0
    }
}

function Resolve-OnboardifyOuPath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$ConfiguredOu
    )

    # org-structure.sample.json kan innehålla OU utan DC-del.
    # Här matchar vi mot AD-strukturen från Discovery och hämtar full OU.

    if ($ConfiguredOu -match ",DC=") {
        return $ConfiguredOu
    }

    if (-not $script:AdStructure) {
        $script:AdStructure = Get-OnboardifyAdStructure
    }

    $matches = @(
        $script:AdStructure.organizationalUnits |
            Where-Object {
                $_.distinguishedName -eq $ConfiguredOu -or
                $_.distinguishedName -like "$ConfiguredOu,*"
            }
    )

    if ($matches.Count -eq 1) {
        return $matches[0].distinguishedName
    }

    if ($matches.Count -gt 1) {
        throw "Flera OU:er matchade: $ConfiguredOu"
    }

    throw "Kunde inte matcha OU mot AD-strukturen: $ConfiguredOu"
}

function Get-SelectedUnitOu {
    # Hämtar rätt OU från vald avdelning och enhet.

    $selectedDepartment = $cmbDepartment.Text
    $selectedUnit = $cmbUnit.Text

    if ([string]::IsNullOrWhiteSpace($selectedDepartment)) {
        throw "Välj avdelning."
    }

    if ([string]::IsNullOrWhiteSpace($selectedUnit)) {
        throw "Välj enhet."
    }

    $departmentConfig = $script:DepartmentMap[$selectedDepartment]

    if (-not $departmentConfig -or -not $departmentConfig.Enheter) {
        throw "Ingen enhetsstruktur finns för vald avdelning."
    }

    $unitProperty = $departmentConfig.Enheter.PSObject.Properties[$selectedUnit]

    if (-not $unitProperty) {
        throw "Vald enhet hittades inte i org-strukturen."
    }

    $unitConfig = $unitProperty.Value

    if (-not $unitConfig -or [string]::IsNullOrWhiteSpace($unitConfig.OU)) {
        throw "Ingen OU är kopplad till vald enhet."
    }

    return Resolve-OnboardifyOuPath -ConfiguredOu $unitConfig.OU
}

function Update-ResolvedOuPreview {
    # Visar vilken OU som räknas fram från vald avdelning och enhet.

    if (-not $txtResolvedOu) {
        return
    }

    try {
        $resolvedOu = Get-SelectedUnitOu
        $txtResolvedOu.Text = $resolvedOu
    }
    catch {
        $txtResolvedOu.Text = ""
    }
}

function Update-HrGroupList {
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$Structure
    )

    # Sparar alla AD-grupper från Discovery.
    # GR-grupper används automatiskt för roll/licens.
    # DL-grupper visas som mappbehörigheter.
    $script:AvailableAdGroups = @(
        $Structure.groups |
            ForEach-Object { $_.samAccountName }
    )

    $script:AvailableFolderGroups = @(
        $script:AvailableAdGroups |
            Where-Object { $_ -like "DL *" } |
            Sort-Object
    )

    if ($script:AvailableFolderGroups.Count -eq 0) {
        throw "Inga DL-grupper hittades i AD-strukturen."
    }

    Update-SuggestedFolderAccessGroups
}

function Get-FolderAccessGroupPrefix {
    # Avgör vilka DL-grupper som ska föreslås baserat på vald avdelning.

    switch ($cmbDepartment.Text) {
        "Kommunledningsförvaltningen" {
            return "DL Kommunledning"
        }
        "Kultur- och fritidsförvaltningen" {
            return "DL Kultur"
        }
        "Samhällsbyggnadsförvaltningen" {
            return "DL Samhällsbyggnad"
        }
        "Socialförvaltningen" {
            return "DL Social"
        }
        "Utbildningsförvaltningen" {
            return "DL Utbildning"
        }
        "Bostäder AB" {
            return "DL Bostäder"
        }
        "Energi AB" {
            return "DL Energi"
        }
        default {
            return ""
        }
    }
}

function Update-SuggestedFolderAccessGroups {
    # Visar bara föreslagna mappbehörigheter för vald avdelning.

    $clbGroups.Items.Clear()

    $prefix = Get-FolderAccessGroupPrefix

    if ([string]::IsNullOrWhiteSpace($prefix)) {
        return
    }

    $suggestedGroups = @(
        $script:AvailableFolderGroups |
            Where-Object { $_ -like "$prefix *" }
    )

    foreach ($group in $suggestedGroups) {
        [void]$clbGroups.Items.Add($group)
    }
}

function Get-SelectedFolderAccessGroups {
    # Hämtar valda mappbehörigheter från huvudlistan och extra-dialogen.

    $mainSelected = @(
        $clbGroups.CheckedItems |
            ForEach-Object { $_.ToString() }
    )

    $allSelected = @(
        $mainSelected + $script:ExtraFolderAccessGroups |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Sort-Object -Unique
    )

    return $allSelected
}

function Get-AutomaticRoleGroup {
    # Skapar rollgrupp automatiskt baserat på vald titel.
    # Exempel: Rektor -> GR Roll Rektor

    $groupName = "GR Roll $($cmbTitle.Text)"

    if ($script:AvailableAdGroups -contains $groupName) {
        return $groupName
    }

    return ""
}

function Get-AutomaticLicenseGroups {
    # Skapar licensgrupper automatiskt baserat på valda licenser.
    # Exempel: Microsoft 365 F3 -> GR Licens Microsoft 365 F3

    $licenseGroups = @()

    foreach ($license in @($script:SelectedLicenses)) {
        $groupName = "GR Licens $license"

        if ($script:AvailableAdGroups -contains $groupName) {
            $licenseGroups += $groupName
        }
    }

    return $licenseGroups
}

function Show-ExtraFolderAccessDialog {
    # Visar alla DL-grupper om användaren behöver extra mappbehörigheter.

    if ($script:AvailableFolderGroups.Count -eq 0) {
        [System.Windows.Forms.MessageBox]::Show(
            "Läs in AD-strukturen först så att mappbehörigheter kan hämtas.",
            "Mappbehörigheter saknas",
            [System.Windows.Forms.MessageBoxButtons]::OK,
            [System.Windows.Forms.MessageBoxIcon]::Information
        ) | Out-Null

        return
    }

    $dialog = New-Object System.Windows.Forms.Form
    $dialog.Text = "Välj extra mappbehörigheter"
    $dialog.Size = New-Object System.Drawing.Size(440, 460)
    $dialog.StartPosition = "CenterParent"
    $dialog.FormBorderStyle = "FixedDialog"
    $dialog.MaximizeBox = $false
    $dialog.MinimizeBox = $false

    $lblInfo = New-Object System.Windows.Forms.Label
    $lblInfo.Text = "Välj extra mappbehörigheter utöver de föreslagna."
    $lblInfo.Location = New-Object System.Drawing.Point(20, 20)
    $lblInfo.Size = New-Object System.Drawing.Size(380, 25)
    $dialog.Controls.Add($lblInfo)

    $folderList = New-Object System.Windows.Forms.CheckedListBox
    $folderList.Location = New-Object System.Drawing.Point(20, 55)
    $folderList.Size = New-Object System.Drawing.Size(380, 280)
    $folderList.CheckOnClick = $true
    $dialog.Controls.Add($folderList)

    foreach ($group in $script:AvailableFolderGroups) {
        $index = $folderList.Items.Add($group)

        if ($script:ExtraFolderAccessGroups -contains $group) {
            $folderList.SetItemChecked($index, $true)
        }
    }

    $btnOk = New-Object System.Windows.Forms.Button
    $btnOk.Text = "OK"
    $btnOk.Location = New-Object System.Drawing.Point(220, 360)
    $btnOk.Size = New-Object System.Drawing.Size(80, 35)
    $btnOk.DialogResult = [System.Windows.Forms.DialogResult]::OK
    $dialog.Controls.Add($btnOk)

    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Avbryt"
    $btnCancel.Location = New-Object System.Drawing.Point(320, 360)
    $btnCancel.Size = New-Object System.Drawing.Size(80, 35)
    $btnCancel.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
    $dialog.Controls.Add($btnCancel)

    $dialog.AcceptButton = $btnOk
    $dialog.CancelButton = $btnCancel

    $result = $dialog.ShowDialog($form)

    if ($result -eq [System.Windows.Forms.DialogResult]::OK) {
        $script:ExtraFolderAccessGroups = @(
            $folderList.CheckedItems |
                ForEach-Object { $_.ToString() }
        )
    }

    $dialog.Dispose()
}

function Update-HrAdStructureLists {
    # Läser in AD-strukturen och fyller de fält som kommer från AD.
    # Just nu används den för grupper och för att kunna validera OU.

    $script:AdStructure = Get-OnboardifyAdStructure

    Update-HrGroupList -Structure $script:AdStructure
    Update-ResolvedOuPreview

    return $script:AdStructure
}

function New-HrUserPreviewObject {
    # Bygger ett PowerShell-objekt av det HR har fyllt i.
    # Objektet sparas sedan som JSON.

    $roleGroup = Get-AutomaticRoleGroup
    $licenseGroups = @(Get-AutomaticLicenseGroups)
    $folderAccessGroups = @(Get-SelectedFolderAccessGroups)

    $groups = @(
        @($roleGroup) +
        $licenseGroups +
        $folderAccessGroups |
            Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
            Sort-Object -Unique
    )

    $licenses = @($script:SelectedLicenses)

    $user = [PSCustomObject]@{
        firstName          = $txtFirstName.Text.Trim()
        lastName           = $txtLastName.Text.Trim()
        title              = $cmbTitle.Text.Trim()
        department         = $cmbDepartment.Text.Trim()
        unit               = $cmbUnit.Text.Trim()
        organizationUnit   = Get-SelectedUnitOu
        roleGroup          = $roleGroup
        licenseGroups      = $licenseGroups
        folderAccessGroups = $folderAccessGroups
        groups             = $groups
        licenses           = $licenses

        # Bakåtkompatibelt fält om någon modul fortfarande använder "license".
        license            = ($licenses -join ", ")
    }

    return $user
}

function Save-HrRequestAsJson {
    param(
        [Parameter(Mandatory = $true)]
        [PSCustomObject]$User
    )

    if (-not (Test-Path $script:HrRequestFolder)) {
        New-Item -Path $script:HrRequestFolder -ItemType Directory -Force | Out-Null
    }

    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $safeFirstName = $User.firstName -replace '[^a-zA-ZåäöÅÄÖ0-9]', ''
    $safeLastName = $User.lastName -replace '[^a-zA-ZåäöÅÄÖ0-9]', ''

    $fileName = "onboarding_${timestamp}_${safeFirstName}_${safeLastName}.json"
    $filePath = Join-Path $script:HrRequestFolder $fileName

    @($User) |
        ConvertTo-Json -Depth 5 |
        Set-Content -Path $filePath -Encoding UTF8

    return $filePath
}

function Get-HrRequestFiles {
    if (-not (Test-Path $script:HrRequestFolder)) {
        return @()
    }

    $files = @(
        Get-ChildItem -Path $script:HrRequestFolder -Filter "*.json" -File |
            Sort-Object LastWriteTime -Descending
    )

    return $files
}

function Update-ItHrRequestList {
    $cmbHrRequestFile.Items.Clear()
    $script:HrRequestFiles = @(Get-HrRequestFiles)

    if ($script:HrRequestFiles.Count -eq 0) {
        $lblItRequestStatus.Text = "Status: Inga HR-underlag hittades."
        return
    }

    foreach ($file in $script:HrRequestFiles) {
        [void]$cmbHrRequestFile.Items.Add($file.Name)
    }

    $cmbHrRequestFile.SelectedIndex = 0
    $lblItRequestStatus.Text = "Status: $($script:HrRequestFiles.Count) HR-underlag hittades."
}

function Get-SelectedHrRequestPath {
    if ($cmbHrRequestFile.SelectedIndex -lt 0) {
        throw "Välj ett HR-underlag först."
    }

    $selectedFile = $script:HrRequestFiles[$cmbHrRequestFile.SelectedIndex]

    if (-not $selectedFile) {
        throw "Det valda HR-underlaget kunde inte hittas."
    }

    return $selectedFile.FullName
}

function Read-HrRequestFile {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "HR-underlaget finns inte: $Path"
    }

    $users = Get-Content -Path $Path -Raw -Encoding UTF8 |
        ConvertFrom-Json

    return @($users)
}

function Move-HrRequestToProcessed {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    if (-not (Test-Path $Path)) {
        throw "HR-underlaget finns inte: $Path"
    }

    if (-not (Test-Path $script:ProcessedHrRequestFolder)) {
        New-Item -Path $script:ProcessedHrRequestFolder -ItemType Directory -Force | Out-Null
    }

    $fileName = Split-Path -Path $Path -Leaf
    $destinationPath = Join-Path $script:ProcessedHrRequestFolder $fileName

    Move-Item -Path $Path -Destination $destinationPath -Force

    return $destinationPath
}

function Write-HrRequestPreview {
    param(
        [Parameter(Mandatory = $true)]
        [array]$Users
    )

    if ($Users.Count -eq 0) {
        Write-GuiStatus "HR-underlaget innehåller inga användare."
        return
    }

    Write-GuiStatus "Förhandsgranskning av HR-underlag:"
    Write-GuiStatus "Antal användare i filen: $($Users.Count)"
    Write-GuiStatus ""

    $counter = 1

    foreach ($user in $Users) {
        $groups = @($user.groups) -join ", "

        # Stöd både gamla filer med "license" och nya filer med "licenses".
        $licenseText = ""

        if ($user.PSObject.Properties.Name -contains "licenses") {
            $licenseText = @($user.licenses) -join ", "
        }
        elseif ($user.PSObject.Properties.Name -contains "license") {
            $licenseText = $user.license
        }

        Write-GuiStatus "Användare $counter"
        Write-GuiStatus "Förnamn: $($user.firstName)"
        Write-GuiStatus "Efternamn: $($user.lastName)"
        Write-GuiStatus "Titel: $($user.title)"
        Write-GuiStatus "Avdelning: $($user.department)"
        Write-GuiStatus "Enhet: $($user.unit)"
        Write-GuiStatus "OU: $($user.organizationUnit)"

        if ($user.PSObject.Properties.Name -contains "roleGroup") {
            Write-GuiStatus "Rollgrupp: $($user.roleGroup)"
            Write-GuiStatus "Licensgrupper: $(@($user.licenseGroups) -join ', ')"
            Write-GuiStatus "Mappbehörigheter: $(@($user.folderAccessGroups) -join ', ')"
            Write-GuiStatus "Alla AD-grupper: $groups"
        }
        else {
            Write-GuiStatus "Grupper: $groups"
        }

        Write-GuiStatus "Licenser: $licenseText"
        Write-GuiStatus "------------------------------"

        $counter++
    }

    Write-GuiStatus ""
    Write-GuiStatus "Nästa steg blir att köra detta i DemoMode."
}

function Invoke-OnboardifyMode {
    param(
        [Parameter(Mandatory = $true)]
        [string]$DataPath,

        [switch]$DemoMode
    )

    if (-not (Test-Path $script:StartOnboardingPath)) {
        throw "Huvudscriptet hittades inte: $script:StartOnboardingPath"
    }

    if (-not (Test-Path $DataPath)) {
        throw "HR-filen hittades inte: $DataPath"
    }

    $arguments = @(
        "-NoProfile"
        "-ExecutionPolicy"
        "Bypass"
        "-File"
        "`"$script:StartOnboardingPath`""
        "-DataPath"
        "`"$DataPath`""
        "-StructurePath"
        "`"$script:StructurePath`""
    )

    if ($DemoMode) {
        $arguments += "-DemoMode"
    }

    $processInfo = New-Object System.Diagnostics.ProcessStartInfo
    $processInfo.FileName = "powershell.exe"
    $processInfo.Arguments = $arguments -join " "
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $processInfo

    [void]$process.Start()

    $standardOutput = $process.StandardOutput.ReadToEnd()
    $standardError = $process.StandardError.ReadToEnd()

    $process.WaitForExit()

    return [PSCustomObject]@{
        ExitCode = $process.ExitCode
        Output   = $standardOutput
        Error    = $standardError
    }
}

function Write-OnboardifyProcessOutput {
    param(
        [AllowEmptyString()]
        [string]$Text = ""
    )

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return
    }

    $lines = $Text -split "`r?`n"

    foreach ($line in $lines) {
        $cleanLine = $line.Trim()

        if ([string]::IsNullOrWhiteSpace($cleanLine)) {
            continue
        }

        try {
            $logEntry = $cleanLine | ConvertFrom-Json -ErrorAction Stop

            if ($logEntry.Message) {
                if ($logEntry.Level) {
                    Write-GuiStatus "[$($logEntry.Level)] $($logEntry.Message)"
                }
                else {
                    Write-GuiStatus $logEntry.Message
                }

                continue
            }
        }
        catch {
            # Om raden inte är JSON skriver vi ut den som vanlig text.
        }

        Write-GuiStatus $cleanLine
    }
}

function Test-HrFormInput {
    $missingFields = @()

    if ([string]::IsNullOrWhiteSpace($txtFirstName.Text)) {
        $missingFields += "Förnamn"
    }

    if ([string]::IsNullOrWhiteSpace($txtLastName.Text)) {
        $missingFields += "Efternamn"
    }

    if ([string]::IsNullOrWhiteSpace($cmbTitle.Text)) {
        $missingFields += "Titel"
    }

    if ([string]::IsNullOrWhiteSpace($cmbDepartment.Text)) {
        $missingFields += "Avdelning"
    }

    if ([string]::IsNullOrWhiteSpace($cmbUnit.Text)) {
        $missingFields += "Enhet"
    }

    if ((Get-SelectedFolderAccessGroups).Count -eq 0) {
        $missingFields += "Mappbehörigheter"
    }

    if ($script:SelectedLicenses.Count -eq 0) {
        $missingFields += "Licenser"
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
$form.StartPosition = "CenterScreen"

# Gör fönstret användbart på mindre skärmar och gör det möjligt att maximera.
$form.FormBorderStyle = "Sizable"
$form.MaximizeBox = $true
$form.MinimizeBox = $true
$form.AutoScroll = $true
$form.MinimumSize = New-Object System.Drawing.Size(760, 650)

# Anpassar startstorleken efter skärmens arbetsyta.
# Det gör att statusloggen inte hamnar utanför synlig yta på laptop/skärmar med lägre höjd.
$workingArea = [System.Windows.Forms.Screen]::PrimaryScreen.WorkingArea
$startWidth = [Math]::Min(900, [Math]::Max(760, $workingArea.Width - 80))
$startHeight = [Math]::Min(880, [Math]::Max(650, $workingArea.Height - 80))

$form.Size = New-Object System.Drawing.Size($startWidth, $startHeight)

$lblTitle = New-Object System.Windows.Forms.Label
$lblTitle.Text = "Onboardify AB - Onboardingverktyg"
$lblTitle.Font = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$lblTitle.Location = New-Object System.Drawing.Point(20, 20)
$lblTitle.Size = New-Object System.Drawing.Size(840, 35)
$form.Controls.Add($lblTitle)

$lblDescription = New-Object System.Windows.Forms.Label
$lblDescription.Text = "IT förbereder AD-struktur, HR skapar underlag och IT kör onboarding."
$lblDescription.Font = New-Object System.Drawing.Font("Segoe UI", 10)
$lblDescription.Location = New-Object System.Drawing.Point(22, 55)
$lblDescription.Size = New-Object System.Drawing.Size(840, 25)
$form.Controls.Add($lblDescription)

$tabs = New-Object System.Windows.Forms.TabControl
$tabs.Location = New-Object System.Drawing.Point(20, 95)
$tabs.Size = New-Object System.Drawing.Size(840, 470)
$form.Controls.Add($tabs)

$tabITPrepare = New-Object System.Windows.Forms.TabPage
$tabITPrepare.Text = "IT - Förbered"

$tabHR = New-Object System.Windows.Forms.TabPage
$tabHR.Text = "HR - Underlag"

$tabITRun = New-Object System.Windows.Forms.TabPage
$tabITRun.Text = "IT - Kör onboarding"

$tabs.TabPages.Add($tabITPrepare)
$tabs.TabPages.Add($tabHR)
$tabs.TabPages.Add($tabITRun)

# Gör att varje flik kan scrolla om innehållet inte får plats.
foreach ($tabPage in @($tabITPrepare, $tabHR, $tabITRun)) {
    $tabPage.AutoScroll = $true
}

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

$btnScanAD.Add_Click({
    try {
        Clear-GuiStatus
        Write-GuiStatus "Startar AD-skanning..."

        $structure = Start-OnboardifyAdScan
        $script:AdStructure = $structure

        Write-GuiStatus "AD-skanning klar."
        Write-GuiStatus "Strukturfil sparad:"
        Write-GuiStatus $script:StructurePath

        if ($structure.organizationalUnits) {
            Write-GuiStatus "Antal OU:er hittade: $($structure.organizationalUnits.Count)"
        }

        if ($structure.groups) {
            Write-GuiStatus "Antal grupper hittade: $($structure.groups.Count)"
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
$lblHRInfo.Text = "Läs in AD-strukturen och välj sedan avdelning, enhet, titel, grupper och licenser."
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
$cmbTitle = Add-ComboBox -Parent $tabHR -X 150 -Y 188 -Width 240

Add-FormLabel -Parent $tabHR -Text "Avdelning" -X 20 -Y 220 | Out-Null
$cmbDepartment = Add-ComboBox -Parent $tabHR -X 150 -Y 218 -Width 240

Add-FormLabel -Parent $tabHR -Text "Enhet" -X 20 -Y 250 | Out-Null
$cmbUnit = Add-ComboBox -Parent $tabHR -X 150 -Y 248 -Width 240

$cmbDepartment.Add_SelectedIndexChanged({
    Update-HrUnitList
    Update-ResolvedOuPreview
    Update-SuggestedFolderAccessGroups
})

$cmbUnit.Add_SelectedIndexChanged({
    Update-ResolvedOuPreview
})

# Höger kolumn.
Add-FormLabel -Parent $tabHR -Text "Beräknad OU" -X 430 -Y 130 | Out-Null

$txtResolvedOu = New-Object System.Windows.Forms.TextBox
$txtResolvedOu.Location = New-Object System.Drawing.Point(560, 128)
$txtResolvedOu.Size = New-Object System.Drawing.Size(250, 55)
$txtResolvedOu.Multiline = $true
$txtResolvedOu.ReadOnly = $true
$txtResolvedOu.ScrollBars = "Vertical"
$tabHR.Controls.Add($txtResolvedOu)

Add-FormLabel -Parent $tabHR -Text "Mappbehörigheter" -X 430 -Y 195 | Out-Null

$clbGroups = New-Object System.Windows.Forms.CheckedListBox
$clbGroups.Location = New-Object System.Drawing.Point(560, 193)
$clbGroups.Size = New-Object System.Drawing.Size(250, 85)
$clbGroups.CheckOnClick = $true
$tabHR.Controls.Add($clbGroups)

$lblGroupsHelp = New-Object System.Windows.Forms.Label
$lblGroupsHelp.Text = "Välj R eller RW för användarens mappåtkomst."
$lblGroupsHelp.Location = New-Object System.Drawing.Point(560, 280)
$lblGroupsHelp.Size = New-Object System.Drawing.Size(260, 25)
$tabHR.Controls.Add($lblGroupsHelp)

$btnExtraFolderAccess = New-Object System.Windows.Forms.Button
$btnExtraFolderAccess.Text = "Visa fler mappbehörigheter..."
$btnExtraFolderAccess.Location = New-Object System.Drawing.Point(560, 305)
$btnExtraFolderAccess.Size = New-Object System.Drawing.Size(250, 28)
$tabHR.Controls.Add($btnExtraFolderAccess)

$btnExtraFolderAccess.Add_Click({
    Show-ExtraFolderAccessDialog
})

Add-FormLabel -Parent $tabHR -Text "Licenser" -X 430 -Y 340 | Out-Null

$txtSelectedLicenses = New-Object System.Windows.Forms.TextBox
$txtSelectedLicenses.Location = New-Object System.Drawing.Point(560, 338)
$txtSelectedLicenses.Size = New-Object System.Drawing.Size(250, 22)
$txtSelectedLicenses.ReadOnly = $true
$tabHR.Controls.Add($txtSelectedLicenses)

$btnSelectLicenses = New-Object System.Windows.Forms.Button
$btnSelectLicenses.Text = "Välj licenser..."
$btnSelectLicenses.Location = New-Object System.Drawing.Point(560, 367)
$btnSelectLicenses.Size = New-Object System.Drawing.Size(250, 28)
$tabHR.Controls.Add($btnSelectLicenses)

$btnSelectLicenses.Add_Click({
    Show-LicenseSelectionDialog
})

$btnPreviewHrData = New-Object System.Windows.Forms.Button
$btnPreviewHrData.Text = "Förhandsgranska underlag"
$btnPreviewHrData.Location = New-Object System.Drawing.Point(20, 395)
$btnPreviewHrData.Size = New-Object System.Drawing.Size(190, 40)
$tabHR.Controls.Add($btnPreviewHrData)

$btnSaveHrData = New-Object System.Windows.Forms.Button
$btnSaveHrData.Text = "Spara JSON-underlag"
$btnSaveHrData.Location = New-Object System.Drawing.Point(225, 395)
$btnSaveHrData.Size = New-Object System.Drawing.Size(170, 40)
$tabHR.Controls.Add($btnSaveHrData)

$btnClearHrForm = New-Object System.Windows.Forms.Button
$btnClearHrForm.Text = "Rensa HR-formulär"
$btnClearHrForm.Location = New-Object System.Drawing.Point(410, 395)
$btnClearHrForm.Size = New-Object System.Drawing.Size(150, 40)
$tabHR.Controls.Add($btnClearHrForm)

$btnLoadStructure.Add_Click({
    try {
        Clear-GuiStatus
        Write-GuiStatus "Läser in AD-struktur för HR..."

        $structure = Update-HrAdStructureLists
        Update-HrCustomerOptionLists

        Write-GuiStatus "AD-struktur inläst."
        Write-GuiStatus "Kundval inlästa."
        Write-GuiStatus "Strukturfil:"
        Write-GuiStatus $script:StructurePath
        Write-GuiStatus "Skapad: $($structure.generatedAt)"
        Write-GuiStatus "Antal OU:er: $($structure.organizationalUnits.Count)"
        Write-GuiStatus "Antal grupper: $($structure.groups.Count)"

        $lblHrStructureStatus.Text = "Status: AD-struktur inläst. HR kan välja avdelning, enhet och grupper."
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

    try {
        $user = New-HrUserPreviewObject

        Write-GuiStatus "Förhandsgranskning av HR-underlag:"
        Write-GuiStatus ""
        Write-GuiStatus "Förnamn: $($user.firstName)"
        Write-GuiStatus "Efternamn: $($user.lastName)"
        Write-GuiStatus "Titel: $($user.title)"
        Write-GuiStatus "Avdelning: $($user.department)"
        Write-GuiStatus "Enhet: $($user.unit)"
        Write-GuiStatus "OU: $($user.organizationUnit)"
        Write-GuiStatus "Rollgrupp: $($user.roleGroup)"
        Write-GuiStatus "Licensgrupper: $($user.licenseGroups -join ', ')"
        Write-GuiStatus "Mappbehörigheter: $($user.folderAccessGroups -join ', ')"
        Write-GuiStatus "Alla AD-grupper: $($user.groups -join ', ')"
        Write-GuiStatus "Licenser: $($user.licenses -join ', ')"
        Write-GuiStatus ""
        Write-GuiStatus "Nästa steg är att spara detta som JSON-underlag till IT."
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
    }
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

    if ($cmbTitle.Items.Count -gt 0) {
        $cmbTitle.SelectedIndex = 0
    }

    if ($cmbDepartment.Items.Count -gt 0) {
        $cmbDepartment.SelectedIndex = 0
        Update-HrUnitList
        Update-ResolvedOuPreview
    }

    for ($i = 0; $i -lt $clbGroups.Items.Count; $i++) {
        $clbGroups.SetItemChecked($i, $false)
    }

    $script:ExtraFolderAccessGroups = @()
    Update-SuggestedFolderAccessGroups

    $script:SelectedLicenses = @()
    Update-SelectedLicensesText

    Clear-GuiStatus
    Write-GuiStatus "HR-formuläret har rensats."
})

# ------------------------------------------------------------
# IT - KÖR ONBOARDING
# ------------------------------------------------------------

$lblITRun = New-Object System.Windows.Forms.Label
$lblITRun.Text = "Steg 3: IT läser HR-underlaget och förbereder onboarding."
$lblITRun.Location = New-Object System.Drawing.Point(20, 25)
$lblITRun.Size = New-Object System.Drawing.Size(760, 25)
$tabITRun.Controls.Add($lblITRun)

$lblITRunInfo = New-Object System.Windows.Forms.Label
$lblITRunInfo.Text = "Börja med att ladda in HR-underlag som ligger i data/hr-requests/pending."
$lblITRunInfo.Location = New-Object System.Drawing.Point(20, 55)
$lblITRunInfo.Size = New-Object System.Drawing.Size(760, 25)
$tabITRun.Controls.Add($lblITRunInfo)

$btnLoadHrRequests = New-Object System.Windows.Forms.Button
$btnLoadHrRequests.Text = "Ladda HR-underlag"
$btnLoadHrRequests.Location = New-Object System.Drawing.Point(20, 95)
$btnLoadHrRequests.Size = New-Object System.Drawing.Size(160, 35)
$tabITRun.Controls.Add($btnLoadHrRequests)

$lblItRequestStatus = New-Object System.Windows.Forms.Label
$lblItRequestStatus.Text = "Status: HR-underlag är inte inlästa."
$lblItRequestStatus.Location = New-Object System.Drawing.Point(200, 102)
$lblItRequestStatus.Size = New-Object System.Drawing.Size(580, 25)
$tabITRun.Controls.Add($lblItRequestStatus)

$lblHrRequestFile = New-Object System.Windows.Forms.Label
$lblHrRequestFile.Text = "HR-fil"
$lblHrRequestFile.Location = New-Object System.Drawing.Point(20, 155)
$lblHrRequestFile.Size = New-Object System.Drawing.Size(100, 22)
$tabITRun.Controls.Add($lblHrRequestFile)

$cmbHrRequestFile = New-Object System.Windows.Forms.ComboBox
$cmbHrRequestFile.Location = New-Object System.Drawing.Point(120, 152)
$cmbHrRequestFile.Size = New-Object System.Drawing.Size(520, 22)
$cmbHrRequestFile.DropDownStyle = "DropDownList"
$tabITRun.Controls.Add($cmbHrRequestFile)

$btnPreviewHrRequest = New-Object System.Windows.Forms.Button
$btnPreviewHrRequest.Text = "Förhandsgranska HR-fil"
$btnPreviewHrRequest.Location = New-Object System.Drawing.Point(20, 205)
$btnPreviewHrRequest.Size = New-Object System.Drawing.Size(190, 40)
$tabITRun.Controls.Add($btnPreviewHrRequest)

$btnRunDemoMode = New-Object System.Windows.Forms.Button
$btnRunDemoMode.Text = "Kör DemoMode"
$btnRunDemoMode.Location = New-Object System.Drawing.Point(225, 205)
$btnRunDemoMode.Size = New-Object System.Drawing.Size(160, 40)
$tabITRun.Controls.Add($btnRunDemoMode)

$btnMarkAsProcessed = New-Object System.Windows.Forms.Button
$btnMarkAsProcessed.Text = "Markera som behandlad"
$btnMarkAsProcessed.Location = New-Object System.Drawing.Point(400, 205)
$btnMarkAsProcessed.Size = New-Object System.Drawing.Size(190, 40)
$tabITRun.Controls.Add($btnMarkAsProcessed)

$btnRunSharpMode = New-Object System.Windows.Forms.Button
$btnRunSharpMode.Text = "Kör skarpt i AD"
$btnRunSharpMode.Location = New-Object System.Drawing.Point(605, 205)
$btnRunSharpMode.Size = New-Object System.Drawing.Size(170, 40)
$tabITRun.Controls.Add($btnRunSharpMode)

$btnLoadHrRequests.Add_Click({
    try {
        Clear-GuiStatus
        Write-GuiStatus "Letar efter HR-underlag..."

        Update-ItHrRequestList

        if ($script:HrRequestFiles.Count -eq 0) {
            Write-GuiStatus "Inga HR-underlag hittades."
            Write-GuiStatus "HR behöver först skapa och spara ett JSON-underlag."
            return
        }

        Write-GuiStatus "HR-underlag inlästa."
        Write-GuiStatus "Antal filer: $($script:HrRequestFiles.Count)"
        Write-GuiStatus ""
        Write-GuiStatus "Välj en fil och klicka på Förhandsgranska HR-fil eller Kör DemoMode."
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
        $lblItRequestStatus.Text = "Status: Kunde inte läsa HR-underlag."
    }
})

$btnPreviewHrRequest.Add_Click({
    try {
        Clear-GuiStatus

        $selectedPath = Get-SelectedHrRequestPath
        $users = Read-HrRequestFile -Path $selectedPath

        Write-GuiStatus "Vald HR-fil:"
        Write-GuiStatus $selectedPath
        Write-GuiStatus ""

        Write-HrRequestPreview -Users $users
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
    }
})

$btnRunDemoMode.Add_Click({
    try {
        Clear-GuiStatus

        $selectedPath = Get-SelectedHrRequestPath

        Write-GuiStatus "Startar Onboardify i DemoMode..."
        Write-GuiStatus "HR-fil:"
        Write-GuiStatus $selectedPath
        Write-GuiStatus ""

        $result = Invoke-OnboardifyMode -DataPath $selectedPath -DemoMode

        if (-not [string]::IsNullOrWhiteSpace($result.Output)) {
            Write-GuiStatus "Resultat från DemoMode:"
            Write-GuiStatus ""
            Write-OnboardifyProcessOutput -Text $result.Output
        }

        if (-not [string]::IsNullOrWhiteSpace($result.Error)) {
            Write-GuiStatus ""
            Write-GuiStatus "Feloutput:"
            Write-OnboardifyProcessOutput -Text $result.Error
        }

        if ($result.ExitCode -eq 0) {
            Write-GuiStatus ""
            Write-GuiStatus "DemoMode klart."
            Write-GuiStatus "Inga användare eller mappar har skapats."
            Write-GuiStatus ""
            Write-GuiStatus "Nästa steg är att IT granskar resultatet innan eventuell skarp körning."
        }
        else {
            Write-GuiStatus ""
            Write-GuiStatus "DemoMode avslutades med felkod: $($result.ExitCode)"
        }
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
    }
})

$btnRunSharpMode.Add_Click({
    try {
        Clear-GuiStatus

        $selectedPath = Get-SelectedHrRequestPath

        $confirmResult = [System.Windows.Forms.MessageBox]::Show(
            "VARNING!`n`nDetta kör onboarding skarpt och kan skapa användare, grupper och hemkataloger i AD.`n`nVill du fortsätta?",
            "Skarp AD-körning",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Warning
        )

        if ($confirmResult -ne [System.Windows.Forms.DialogResult]::Yes) {
            Write-GuiStatus "Skarp AD-körning avbröts."
            return
        }

        Write-GuiStatus "Startar Onboardify skarpt..."
        Write-GuiStatus "HR-fil:"
        Write-GuiStatus $selectedPath
        Write-GuiStatus ""
        Write-GuiStatus "VARNING: Detta är inte DemoMode."
        Write-GuiStatus ""

        $result = Invoke-OnboardifyMode -DataPath $selectedPath

        if (-not [string]::IsNullOrWhiteSpace($result.Output)) {
            Write-GuiStatus "Resultat från skarp körning:"
            Write-GuiStatus ""
            Write-OnboardifyProcessOutput -Text $result.Output
        }

        if (-not [string]::IsNullOrWhiteSpace($result.Error)) {
            Write-GuiStatus ""
            Write-GuiStatus "Feloutput:"
            Write-OnboardifyProcessOutput -Text $result.Error
        }

        if ($result.ExitCode -eq 0) {
            Write-GuiStatus ""
            Write-GuiStatus "Skarp onboarding klar."
            Write-GuiStatus "Kontrollera användaren i AD innan HR-underlaget markeras som behandlat."
        }
        else {
            Write-GuiStatus ""
            Write-GuiStatus "Skarp onboarding avslutades med felkod: $($result.ExitCode)"
        }
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
    }
})

$btnMarkAsProcessed.Add_Click({
    try {
        Clear-GuiStatus

        $selectedPath = Get-SelectedHrRequestPath

        $confirmResult = [System.Windows.Forms.MessageBox]::Show(
            "Vill du markera HR-underlaget som behandlat?`n`nFilen flyttas från pending till processed.",
            "Markera som behandlad",
            [System.Windows.Forms.MessageBoxButtons]::YesNo,
            [System.Windows.Forms.MessageBoxIcon]::Question
        )

        if ($confirmResult -ne [System.Windows.Forms.DialogResult]::Yes) {
            Write-GuiStatus "Åtgärden avbröts."
            return
        }

        $processedPath = Move-HrRequestToProcessed -Path $selectedPath

        Write-GuiStatus "HR-underlaget har markerats som behandlat."
        Write-GuiStatus ""
        Write-GuiStatus "Flyttad till:"
        Write-GuiStatus $processedPath
        Write-GuiStatus ""
        Write-GuiStatus "Pending-listan uppdateras."

        Update-ItHrRequestList
    }
    catch {
        Write-GuiStatus "FEL: $($_.Exception.Message)"
    }
})

# ------------------------------------------------------------
# STATUSLOGG
# ------------------------------------------------------------

$lblStatus = New-Object System.Windows.Forms.Label
$lblStatus.Text = "Statuslogg:"
$lblStatus.Location = New-Object System.Drawing.Point(20, 580)
$lblStatus.Size = New-Object System.Drawing.Size(840, 20)
$form.Controls.Add($lblStatus)

$txtStatus = New-Object System.Windows.Forms.TextBox
$txtStatus.Multiline = $true
$txtStatus.ReadOnly = $true
$txtStatus.ScrollBars = "Vertical"
$txtStatus.Font = New-Object System.Drawing.Font("Consolas", 9)
$txtStatus.Location = New-Object System.Drawing.Point(20, 605)
$txtStatus.Size = New-Object System.Drawing.Size(840, 220)
$form.Controls.Add($txtStatus)

# Anpassar bredd och höjd när fönstret ändrar storlek.
# Statusloggen flyttas upp/ned efter flikområdet och får resterande synlig höjd.
function Update-OnboardifyGuiLayout {
    $contentWidth = [Math]::Max(700, $form.ClientSize.Width - 60)

    foreach ($control in @($lblTitle, $lblDescription, $tabs, $lblStatus, $txtStatus)) {
        if ($control) {
            $control.Width = $contentWidth
        }
    }

    if ($tabs -and $lblStatus -and $txtStatus) {
        $tabs.Height = [Math]::Min(470, [Math]::Max(410, $form.ClientSize.Height - 260))

        $statusTop = $tabs.Top + $tabs.Height + 15
        $lblStatus.Location = New-Object System.Drawing.Point(20, $statusTop)

        $txtStatusTop = $statusTop + 25
        $txtStatus.Location = New-Object System.Drawing.Point(20, $txtStatusTop)

        $txtStatus.Height = [Math]::Max(120, $form.ClientSize.Height - $txtStatusTop - 25)
    }
}

Update-OnboardifyGuiLayout

$form.Add_Resize({
    Update-OnboardifyGuiLayout
})

try {
    Update-HrCustomerOptionLists
    Write-GuiStatus "Kundval inlästa från configfiler."
}
catch {
    Write-GuiStatus "VARNING: Kunde inte läsa kundval."
    Write-GuiStatus $_.Exception.Message
}

Write-GuiStatus "Onboardify GUI startat."
Write-GuiStatus "Börja med IT - Förbered om AD-strukturen inte redan är skannad."
Write-GuiStatus "Gå sedan till HR - Underlag och läs in AD-strukturen."

[void]$form.ShowDialog()