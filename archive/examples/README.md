# Exempeldata

Den här mappen innehåller exempeldata som kan användas för att testa Onboardify AB:s onboarding-automat.

Filerna visar hur information om en nyanställd kan skickas in till systemet. Det kan till exempel vara namn, användarnamn, avdelning, licens och grupper.

## Filer

### `new-hire.sample.json`

Exempel på en nyanställd i JSON-format.

JSON är huvudformatet i projektet eftersom det är mer flexibelt när en användare behöver flera grupper, licenser och behörigheter.

### `new-hire.sample.csv`

Exempel på en nyanställd i CSV-format.

CSV finns med som ett enklare exempel på indata. Det kan vara lätt att läsa och redigera, men passar sämre om en användare behöver många grupper eller mer avancerad information.

## Viktigt

Filerna är bara exempeldata och ska inte innehålla riktiga personuppgifter.

När systemet används på riktigt ska HR eller testaren skapa egna filer baserade på dessa exempel.