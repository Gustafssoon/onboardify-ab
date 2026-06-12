# Felsökning - Onboardify

Snabbguide för vanliga fel vid onboarding.

---

## Snabb kontrollista

Kontrollera alltid detta först:

* Körs scriptet med `-DemoMode`?
* Är rätt JSON-fil angiven?
* Är JSON-formatet korrekt?
* Finns obligatoriska fält?
* Finns OU:n i AD?
* Finns grupperna i AD?
* Finns användaren redan?
* Vad står i loggen?

---

## Vanliga fel

| Problem                   | Kontrollera                                     |
| ------------------------- | ----------------------------------------------- |
| Inget skapas              | Se om `-DemoMode` används                       |
| JSON-filen läses inte     | Kontrollera JSON-formatet                       |
| Användare skapas inte     | Kontrollera obligatoriska fält och loggar       |
| Fel OU                    | Kontrollera `organizationUnit`                  |
| Grupp hittas inte         | Kontrollera stavning och att gruppen finns i AD |
| Hemkatalog skapas inte    | Kontrollera sökväg, behörighet och logg         |
| Användarnamn blir oväntat | Kontrollera om användaren redan finns i AD      |

---

## Obligatoriska fält

Varje användare behöver:

```text
firstName
lastName
title
department
organizationUnit
groups
license
```

---

## DemoMode

Testkörning:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```

Om `-DemoMode` används ska inget skapas i AD eller på filservern.

---

## Eskalera om

Eskalera ärendet om:

* loggen visar AD-fel
* flera användare påverkas
* användaren inte skapas trots korrekt data
* hemkatalog inte skapas trots korrekt sökväg och behörighet
* scriptet stoppar med oväntat PowerShell-fel

Skicka med:

* JSON-fil
* användare som skulle skapas
* loggutdrag
* felmeddelande
* om körningen var DemoMode eller skarp