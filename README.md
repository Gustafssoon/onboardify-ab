# Onboardify AB

Onboardify AB är ett fiktivt projekt som bygger en PowerShell-baserad onboarding-automation för Active Directory.

Målet är att göra processen från nyanställning till aktivt användarkonto mer kontrollerad, repeterbar och felsäker.

Projektet är byggt som en prototyp där HR ansvarar för korrekt användardata och IT ansvarar för den tekniska automatiseringen.

---

## Översikt

Onboardify hjälper organisationer att automatisera delar av onboarding-processen.

I stället för att IT manuellt skapar användare, grupper och hemkataloger utifrån ostrukturerad information, läser systemet in HR-data från en JSON-fil och använder den för att skapa användaren i Active Directory.

Prototypen är byggd för en labbmiljö och är inte avsedd för produktion.

---

## Funktioner

Projektet har just nu stöd för:

* inläsning av användardata från JSON
* validering av obligatoriska fält
* skanning av OU-struktur i Active Directory
* generering av `SamAccountName`
* generering av e-postadress och UPN
* kontroll om användare redan finns
* skapande av AD-användare
* tilldelning av gruppmedlemskap
* skapande av hemkatalog
* loggning
* felhantering med Try/Catch
* DemoMode för säker testkörning

---

## Onboarding-flöde

```text
AD-skannern körs
     ↓
Aktuell AD-struktur sparas
     ↓
HR fyller i nya personer
    ↓
Onboardify validerar HR-data
    ↓
Onboardify genererar tekniska värden
    ↓
Användare skapas i AD
    ↓
Grupper och hemkatalog sätts
    ↓
Allt loggas
```

---

## Snabb demo

Kör onboarding-flödet utan att skapa något i Active Directory eller på filservern:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```

DemoMode visar vad som skulle ha gjorts, men gör inga skarpa ändringar.

---

## Skarp körning i labbmiljö

Körning utan `-DemoMode` skapar användare och hemkataloger i labbmiljön:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json
```

Krav:

* Windows-miljö med Active Directory-modulen
* åtkomst till labbdomänen
* korrekt JSON-fil i `config/`
* rättigheter att skapa användare och mappar

---

## Projektstruktur

```text
onboardify-ab/
├── config/
│   └── customer.sample.json
├── docs/
│   ├── change_management.md
│   ├── GET_STARTED.md
│   ├── GIT_WORKFLOW.md
│   ├── SPRINT_README.md
│   ├── lab/
│   ├── service-desk/
│   └── sprints/
├── src/
│   ├── Start-Onboarding.ps1
│   └── modules/
├── tests/
└── README.md
```

---

## Moduler

| Modul                        | Ansvar                                                        |
| ---------------------------- | ------------------------------------------------------------- |
| `Onboardify.Discovery.psm1`  | Läser av AD-struktur och skapar `ad-structure.generated.json` |
| `Onboardify.Import.psm1`     | Läser in användardata från JSON                               |
| `Onboardify.Validation.psm1` | Validerar obligatoriska fält                                  |
| `Onboardify.AD.psm1`         | Skapar användarnamn, e-post/UPN och AD-användare              |
| `Onboardify.Folders.psm1`    | Skapar hemkatalog                                             |
| `Onboardify.Logging.psm1`    | Skriver loggar till terminal och loggfil                      |

---

## Dokumentation

| Dokument                                        | Beskrivning                                     |
| ----------------------------------------------- | ----------------------------------------------- |
| [Kom igång](docs/GET_STARTED.md)                | Guide för att klona repot och komma igång       |
| [Git workflow](docs/GIT_WORKFLOW.md)            | Branches, commits och pull requests             |
| [Sprintarbete](docs/SPRINT_README.md)           | Scrum, sprintar och Definition of Done          |
| [Förändringsledning](docs/change_management.md) | HR, IT, Awareness och Desire                    |
| [Labbmiljö](docs/lab/)                          | Dokumentation för VM, AD-labb och åtkomst       |
| [Sprintdokumentation](docs/sprints/)            | Daily standups, sprint review och retrospective |
| [Service Desk](docs/service-desk/README.md)     | Support- och felsökningsinformation             |

---

## Teknik

Projektet använder:

* PowerShell
* JSON
* Active Directory
* GitHub Issues
* GitHub Projects
* VM-baserad labbmiljö

---

## Team

| Roll          | Namn                                                 |
| ------------- | ---------------------------------------------------- |
| Product Owner | [Gabriel Gustafsson](https://github.com/Gustafssoon) |
| Scrum Master  | [Ali Sulaiman](https://github.com/alisulaiman-debug) |
| Utvecklare    | [Micael Engdahl](https://github.com/icemanic)        |
| Utvecklare    | [Martin Hansson Palm](https://github.com/DrWeremoth) |
| Utvecklare    | [Zahra Hadadi](https://github.com/zahra-hadadi)      |

---

## Arbetssätt

Projektet använder ett Scrum-inspirerat arbetssätt.

Vi arbetar med:

* GitHub Issues för arbetsuppgifter
* GitHub Projects som Scrum-tavla
* Pull Requests för granskning
* små avgränsade issues
* löpande dokumentation under `docs/`

Grundregler:

* Ingen jobbar utan en Issue.
* Den som tar en uppgift assignar sig själv.
* Kort flyttas i GitHub Projects när status ändras.
* Varje issue ska ha tydliga kriterier för när den är klar.

---

## Status

Projektet är under utveckling.

Nuvarande fokus är att få ett stabilt onboarding-flöde med tydlig modulstruktur, säker DemoMode, fungerande AD-integration och bra dokumentation.

---