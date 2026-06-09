# Onboardify.Logging.psm1
# ==========================================
# Den här modulen används för loggning.
# Den sparar loggar i en fil och visar dem i konsolen.
# ==========================================

# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# VARIABLER.

# Här sparas mappen där loggar ska ligga.
$script:LogFolder = "C:\Logs"

# Här sparas sökvägen till loggfilen.
$script:LogFile = $null


# STARTA LOGGNING.
function Initialize-OnboardifyLog {

    param(
        # Här kan man välja egen mapp för loggar.
        [string]$Path = "C:\Logs"
    )

    # Försöker utföra hela logginitieringen
    # Om något går fel hamnar vi i Catch-blocket.
    try {

        # Sätter loggmappen.
        $script:LogFolder = $Path

        # Kollar om mappen finns
        # Om inte → skapa den.
        if (!(Test-Path $script:LogFolder)) {

            # -ErrorAction Stop gör att PowerShell kastar
            # ett fel som kan fångas av Try/Catch.
            New-Item `
                -Path $script:LogFolder `
                -ItemType Directory `
                -Force `
                -ErrorAction Stop | Out-Null
        }

        # Skapar en loggfil med dagens datum.
        $script:LogFile = Join-Path `
            $script:LogFolder `
            "onboardify_$(Get-Date -Format 'yyyyMMdd').log"
    }

    # Körs om något fel uppstår i Try-blocket.
    catch {

        # $_ innehåller information om felet.
        # Exception.Message innehåller själva feltexten.
        Write-Error `
            "Kunde inte initiera loggningen: $($_.Exception.Message)"

        # throw skickar vidare felet till den funktion
        # eller det script som anropade funktionen.
        throw
    }
}


# SKRIVER LOGG.
function Write-OnboardifyLog {

    param(

        # Meddelandet som ska loggas.
        [string]$Message,

        # Typ av logg (INFO, OK, VARNING, FEL).
        [ValidateSet("INFO","OK","VARNING","FEL")]
        [string]$Level = "INFO"
    )

    # Om loggning inte är startad ännu
    # så försäkrar detta att den startas automatiskt. 
    # Kollar både Logfile och LogFolder.
    if ($null -eq $script:LogFile -or $null -eq $script:LogFolder) {
    Initialize-OnboardifyLog
    }

    # Skapar en loggrad med tid, nivå och meddelande.
    $LogEntry = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Level     = $Level
        Message   = $Message
    }

    # Gör om loggen till text (JSON).
    $JsonLog = $LogEntry | ConvertTo-Json -Compress

    # Försöker skriva loggen till fil.
    try {

        # Sparar loggen i filen.
        # -ErrorAction Stop gör att eventuella fel
        # kan fångas av Catch-blocket.
        Add-Content `
            -Path $script:LogFile `
            -Value $JsonLog `
            -ErrorAction Stop
    }

    # Körs om filen inte kan skrivas till.
    catch {

        # Visar detaljerad information om felet.
        Write-Error `
            "Kunde inte skriva till loggfilen: $($_.Exception.Message)"

        # Avslutar funktionen direkt.
        return
    }

    # Visar loggen i konsolen med färger.
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

        # Om något annat används.
        default {
            Write-Host $JsonLog
        }
    }
}


# HÄMTA LOGGFIL.
function Get-OnboardifyLogFile {

    # Visar vilken loggfil som används just nu.
    return $script:LogFile
}


# EXPORT
# Gör funktionerna möjliga att använda i andra script.
Export-ModuleMember `
    -Function `
        Initialize-OnboardifyLog,
        Write-OnboardifyLog,
        Get-OnboardifyLogFile
