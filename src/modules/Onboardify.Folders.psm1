# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Funktion som skapar en hemkatalog för en användare

function New-OnboardifyHomeFolder {

    param(

        # Användarnamn som används för att skapa mappsökvägen
        [Parameter(Mandatory)]
        [string]$UserName
    )

    try {

        # Grundsökväg för hemkataloger
        $BasePath = "C:\Onboardify\HomeFolders"

        # Bygg fullständig sökväg
        $HomeFolder = Join-Path $BasePath $UserName

        # Kontrollera om hemkatalogen redan finns
        if (Test-Path $HomeFolder) {

            Write-Host "Hemkatalogen finns redan: $HomeFolder" -ForegroundColor Yellow

            return
        }

        # Skapa hemkatalogen
        New-Item `
            -Path $HomeFolder `
            -ItemType Directory `
            -ErrorAction Stop

        Write-Host "Hemkatalog skapad: $HomeFolder" -ForegroundColor Green

        # Simulera behörigheter
        Write-Host "Behörigheter tilldelade till $UserName" -ForegroundColor Cyan

        # Logga resultatet
        Write-Host "Resultat loggat"

    }

    catch {

        Write-Host "Fel vid skapande av hemkatalog." -ForegroundColor Red

        Write-Host $_.Exception.Message -ForegroundColor Red

    }
}