# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Funktion som skapar en hemkatalog från användardata
function New-OnboardifyHomeFolder {
    param(
        # Sökvägen till hemkatalogen hämtas från homeFolder i JSON-filen
        [Parameter(Mandatory)]
        [string]$HomeFolder
    )

    try {
        # Kontrollerar om hemkatalogen redan finns
        if (Test-Path $HomeFolder) {
            Write-Host "Hemkatalogen finns redan: $HomeFolder" -ForegroundColor Yellow
            return
        }

        # Skapa hemkatalogen om den saknas
        New-Item `
            -Path $HomeFolder `
            -ItemType Directory `
            -ErrorAction Stop | Out-Null

        Write-Host "Hemkatalog skapad: $HomeFolder" -ForegroundColor Green
    }
    catch {
        # Felhantering om mappen inte kan skapas
        Write-Host "Fel vid skapande av hemkatalog: $HomeFolder" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        throw
    }
}

Export-ModuleMember -Function New-OnboardifyHomeFolder