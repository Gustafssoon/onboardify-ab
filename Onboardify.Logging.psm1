# Onboardify.Logging.psm1
# ==========================================
# Den här modulen används för loggning.
# Den sparar loggar i en fil och visar dem i konsolen.
# ==========================================

# VARIABLER

# Här sparas mappen där loggar ska ligga
$script:LogFolder = "C:\Logs"

# Här sparas sökvägen till loggfilen
$script:LogFile = $null


# STARTA LOGGNING
function Initialize-OnboardifyLog {

    param(
        # Här kan man välja egen mapp för loggar
        [string]$Path = "C:\Logs"
    )

    # Sätter loggmappen
    $script:LogFolder = $Path

    # Kollar om mappen finns
    # Om inte → skapa den
    if (!(Test-Path $script:LogFolder)) {
        New-Item -Path $script:LogFolder -ItemType Directory -Force -ErrorAction Stop | Out-Null
    }

    # Skapar en loggfil med dagens datum
    $script:LogFile = Join-Path `
        $script:LogFolder `
        "onboardify_$(Get-Date -Format 'yyyyMMdd').log"
}


# SKRIVER LOGG
function Write-OnboardifyLog {

    param(
        # Meddelandet som ska loggas
        [string]$Message,

        # Typ av logg (INFO, OK, VARNING, FEL)
        [string]$Level = "INFO"
    )

    # Om loggning inte är startad ännu
    # så startas den automatiskt
    if ($null -eq $script:LogFile) {
        Initialize-OnboardifyLog
    }

    # Skapar en loggrad med tid, nivå och meddelande
    $LogEntry = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Level     = $Level
        Message   = $Message
    }

    # Gör om loggen till text (JSON)
    $JsonLog = $LogEntry | ConvertTo-Json -Compress

    # Sparar loggen i filen
    Add-Content -Path $script:LogFile -Value $JsonLog

    # Visar loggen i konsolen med färger
    switch ($Level) {

        "INFO" {
            Write-Host $JsonLog -ForegroundColor White
        }

        "OK" {
            Write-Host $JsonLog -ForegroundColor Green
        }

        "VARNING" {
            Write-Host $JsonLog -ForegroundColor Yellow
        }

        "FEL" {
            Write-Host $JsonLog -ForegroundColor Red
        }

        # Om något annat används
        default {
            Write-Host $JsonLog
        }
    }
}


# HÄMTA LOGGFIL
function Get-OnboardifyLogFile {

    # Visar vilken loggfil som används just nu
    return $script:LogFile
}


# EXPORT
# Gör funktionerna möjliga att använda i andra script
Export-ModuleMember `
    -Function `
        Initialize-OnboardifyLog,
        Write-OnboardifyLog,
        Get-OnboardifyLogFile