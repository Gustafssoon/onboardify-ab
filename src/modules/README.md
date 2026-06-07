# PowerShell-moduler

Den här mappen innehåller PowerShell-moduler (`.psm1`) för Onboardify AB onboarding-automation.

Modulerna innehåller funktioner som används av huvudscriptet i `src/`.

## Struktur

| Modul | Ansvar |
|---|---|
| `Onboardify.Import.psm1` | Läser in onboarding-data från JSON/CSV |
| `Onboardify.Validation.psm1` | Validerar att obligatoriska fält finns och är korrekta |
| `Onboardify.AD.psm1` | Skapar användare i Active Directory och lägger till grupper |
| `Onboardify.Folders.psm1` | Skapar hemkataloger/mappar och sätter behörigheter |
| `Onboardify.Logging.psm1` | Loggar vad som händer och eventuella fel |

## Användning

Modulerna importeras av huvudscriptet. `Start-Onboarding.ps1`