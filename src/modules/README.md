# PowerShell-moduler

Den här mappen innehåller PowerShell-moduler (`.psm1`) för Onboardify AB:s onboarding-automation.

Modulerna innehåller separata funktioner som används av huvudscriptet `Start-Onboarding.ps1`. Syftet är att hålla koden uppdelad, lättare att testa och enklare att vidareutveckla.

---

## Struktur

| Modul                        | Ansvar                                                        |
| ---------------------------- | ------------------------------------------------------------- |
| `Onboardify.Discovery.psm1`  | Läser av Active Directory och skapar en genererad AD-struktur |
| `Onboardify.Import.psm1`     | Läser in onboarding-data från JSON                            |
| `Onboardify.Validation.psm1` | Validerar att obligatoriska fält finns och är korrekta        |
| `Onboardify.AD.psm1`         | Skapar tekniska AD-värden, användare och gruppmedlemskap      |
| `Onboardify.Folders.psm1`    | Skapar hemkataloger/mappar                                    |
| `Onboardify.Logging.psm1`    | Loggar vad som händer och eventuella fel                      |

---

## Användning

Modulerna importeras av huvudscriptet:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```

Huvudscriptet ansvarar för att köra onboarding-flödet i rätt ordning.

Modulerna ska normalt inte köras direkt var för sig, utan användas via `Start-Onboarding.ps1`.

---

## DemoMode

Flera funktioner använder `DemoMode` för att kunna testa flödet utan att göra skarpa ändringar.

När `-DemoMode` används ska scriptet visa och logga vad som skulle ha gjorts, men inte skapa användare, grupper eller mappar.

---

## Felhantering

Modulerna ska använda tydlig felhantering med `Try/Catch` där det behövs.

Fel ska loggas så att det går att felsöka vad som gick fel utan att hela processen blir otydlig.

---

## Viktigt vid utveckling

När nya funktioner läggs till i modulerna bör man tänka på att:

* hålla varje modul ansvarig för en tydlig del av flödet
* inte blanda AD-logik, importlogik och loggning i samma funktion
* använda tydliga funktionsnamn
* testa ändringar med `-DemoMode`
* uppdatera dokumentationen om modulens ansvar ändras

---

## Exempel på flöde

```text
Import
  ↓
Validation
  ↓
Discovery / AD-struktur
  ↓
AD-användare
  ↓
Grupper
  ↓
Hemkatalog
  ↓
Loggning
```