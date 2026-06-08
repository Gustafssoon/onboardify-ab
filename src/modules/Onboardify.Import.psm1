# Funktion som läser in onboarding-data från en JSON-fil
function Import-OnboardifyUserData {

    param (
        # Sökvägen till JSON-filen som ska läsas in
        [Parameter(Mandatory)]
        [string]$Path
    )

    try {

        # Kontrollera att filen finns
        if (-not (Test-Path $Path)) {

            # Om filen saknas kastas ett fel
            throw "Filen hittades inte: $Path"
        }

        # Läs in hela JSON-filen som en textsträng
        $jsonContent = Get-Content -Path $Path -Raw -ErrorAction Stop

        # Konvertera JSON-data till PowerShell-objekt
        $userData = $jsonContent | ConvertFrom-Json -ErrorAction Stop

        # Returnera användardatan till huvudscriptet
        return $userData
    }

    catch {

        # Visa ett tydligt felmeddelande om något går fel
        Write-Host "Fel vid import av onboarding-data." -ForegroundColor Red

        # Visa den faktiska felorsaken
        Write-Host $_.Exception.Message -ForegroundColor Red

        # Returnera null om importen misslyckas
        return $null
    }
}