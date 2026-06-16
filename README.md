# Onboardify AB

Onboardify AB är ett fiktivt projekt som bygger en PowerShell-baserad onboarding-automation för Active Directory.

Målet är att göra processen från nyanställning till aktivt användarkonto mer kontrollerad, repeterbar och felsäker.

Projektet är byggt som en prototyp i labbmiljö där HR ansvarar för korrekt användardata och IT ansvarar för den tekniska automatiseringen.

---

## Översikt

Onboardify hjälper organisationer att automatisera delar av onboarding-processen.

I stället för att IT manuellt skapar användare, grupper och hemkataloger utifrån ostrukturerad information skapar HR ett onboardingunderlag via GUI:t. Underlaget sparas som JSON och används sedan av IT för att köra onboarding i DemoMode eller skarpt läge.

Prototypen är byggd för en labbmiljö och är inte avsedd för produktion.

---

## Funktioner

Projektet har stöd för:

* GUI för HR och IT
* AD-skanning av OU-struktur och grupper
* HR-formulär för nyanställda
* generering av onboardingunderlag som JSON
* inläsning av HR-underlag från JSON
* validering av obligatoriska fält
* generering av `SamAccountName`
* generering av e-postadress och UPN
* kontroll om användare redan finns
* skapande av AD-användare
* tilldelning av gruppmedlemskap
* hantering av rollgrupper, licensgrupper och mappbehörigheter
* skapande av hemkatalog
* loggning
* felhantering med Try/Catch
* DemoMode för säker testkörning
* skarp körning i labbmiljö

---

## Onboarding-flöde

```text
IT startar Onboardify GUI
     ↓
IT kör AD-skanning
     ↓
Aktuell AD-struktur sparas i config/ad-structure.generated.json
     ↓
HR fyller i nyanställd i GUI:t
     ↓
GUI:t skapar ett HR-underlag i data/hr-requests/pending
     ↓
IT granskar HR-underlaget
     ↓
IT kör DemoMode
     ↓
IT kör skarp onboarding i labbmiljön
     ↓
Användare skapas i AD
     ↓
Grupper och hemkatalog hanteras
     ↓
Allt loggas
```

---

## Starta programmet

Starta Onboardify genom att dubbelklicka på:

```text
Start-OnboardifyGUI.vbs
```

Den filen startar PowerShell-GUI:t utan ett synligt CMD-fönster.

GUI:t begär administratörsbehörighet vid uppstart eftersom onboardingflödet behöver kunna läsa Active Directory och vid skarp körning skapa objekt i labbmiljön.

---

## Rekommenderat demo-flöde

### 1. Starta GUI:t

Dubbelklicka på:

```text
Start-OnboardifyGUI.vbs
```

Godkänn UAC-rutan om den visas.

### 2. Skanna AD

Klicka på **Scan AD**.

Det skapar eller uppdaterar:

```text
config/ad-structure.generated.json
```

Den filen innehåller aktuell OU-struktur och AD-grupper från labbmiljön.

### 3. Skapa HR-underlag

I HR-delen fyller man i till exempel:

* förnamn
* efternamn
* titel
* avdelning
* enhet
* licenser
* eventuella extra mappbehörigheter

När HR-underlaget sparas hamnar det i:

```text
data/hr-requests/pending/
```

### 4. Granska HR-underlag

I IT-delen väljer man ett väntande HR-underlag och granskar informationen innan körning.

### 5. Kör DemoMode

DemoMode visar vad som skulle göras utan att skapa användare eller mappar.

### 6. Kör skarpt i labbmiljö

Skarp körning skapar användaren i Active Directory och hanterar grupper och hemkatalog.

---

## CLI-körning

GUI:t är det rekommenderade sättet att använda Onboardify.

Huvudscriptet kan även köras direkt om man anger ett HR-underlag som redan finns i `data/hr-requests/pending`.

DemoMode:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\data\hr-requests\pending\filnamn.json -DemoMode
```

Skarp körning i labbmiljö:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\data\hr-requests\pending\filnamn.json
```

Byt ut `filnamn.json` mot den fil som GUI:t har skapat.

---

## Krav för körning

För att köra projektet behövs:

* Windows
* PowerShell
* Active Directory-modulen
* åtkomst till labbdomänen
* rättigheter att läsa AD-struktur
* rättigheter att skapa AD-användare vid skarp körning
* rättigheter att skapa hemkataloger vid skarp körning

---

## Projektstruktur

```text
onboardify-ab/
├── assets/
│   └── branding/
├── archive/
│   └── tests/
├── config/
│   ├── homefolder.sample.json
│   ├── licenses.sample.json
│   ├── org-structure.sample.json
│   └── titles.sample.json
├── data/
│   └── hr-requests/
│       ├── pending/
│       └── processed/
├── docs/
│   ├── change_management.md
│   ├── GET_STARTED.md
│   ├── GIT_WORKFLOW.md
│   ├── lab/
│   ├── service-desk/
│   └── sprints/
├── src/
│   ├── Start-Onboarding.ps1
│   ├── Start-OnboardifyGUI.ps1
│   └── modules/
├── Start-OnboardifyGUI.vbs
└── README.md
```

---

## Viktiga mappar

| Mapp                          | Syfte                                                           |
| ----------------------------- | --------------------------------------------------------------- |
| `src/`                        | Huvudscript, GUI och PowerShell-moduler                         |
| `config/`                     | Konfiguration för organisation, titlar, licenser och hemkatalog |
| `data/hr-requests/pending/`   | Väntande HR-underlag skapade av GUI:t                           |
| `data/hr-requests/processed/` | Hanterade HR-underlag                                           |
| `docs/`                       | Projekt-, sprint-, labb- och supportdokumentation               |
| `archive/`                    | Äldre testfiler som inte längre används i huvudflödet           |
| `assets/`                     | Ikoner och branding                                             |

---

## Konfiguration

Onboardify använder flera config-filer.

| Fil                                  | Syfte                                                             |
| ------------------------------------ | ----------------------------------------------------------------- |
| `config/org-structure.sample.json`   | Beskriver organisation, avdelningar, enheter och koppling till OU |
| `config/titles.sample.json`          | Lista med titlar som HR kan välja i GUI:t                         |
| `config/licenses.sample.json`        | Lista med licenser som HR kan välja i GUI:t                       |
| `config/homefolder.sample.json`      | Anger grundsökväg för hemkataloger                                |
| `config/ad-structure.generated.json` | Skapas automatiskt av AD-skannern och ska inte redigeras manuellt |

`config/ad-structure.generated.json` är en genererad fil och ska inte ändras manuellt.

---

## Moduler

| Modul                        | Ansvar                                                        |
| ---------------------------- | ------------------------------------------------------------- |
| `Onboardify.Discovery.psm1`  | Läser av Active Directory och skapar en genererad AD-struktur |
| `Onboardify.Import.psm1`     | Läser in onboardingdata från JSON                             |
| `Onboardify.Validation.psm1` | Validerar obligatoriska fält                                  |
| `Onboardify.AD.psm1`         | Skapar tekniska AD-värden, AD-användare och gruppmedlemskap   |
| `Onboardify.Folders.psm1`    | Skapar hemkatalog                                             |
| `Onboardify.Logging.psm1`    | Skriver loggar till terminal och loggfil                      |

---

## DemoMode

DemoMode används för att testa flödet utan att skapa något i Active Directory eller på filsystemet.

I DemoMode loggar Onboardify vad som skulle ha gjorts, till exempel:

* vilket användarnamn som skulle användas
* vilken OU användaren skulle placeras i
* vilka grupper som skulle tilldelas
* vilken hemkatalog som skulle skapas

DemoMode bör alltid köras innan skarp körning.

---

## Skarp körning

Skarp körning används endast i labbmiljön.

Vid skarp körning försöker Onboardify:

* skapa AD-användaren
* sätta namn, titel, avdelning, e-post och UPN
* lägga användaren i rätt OU
* lägga till gruppmedlemskap
* skapa hemkatalog
* skriva loggar

Om något går fel stoppas körningen och felet loggas.

---

## Loggning

Onboardify skapar loggar i repo-roten under:

```text
Logs/
```

Loggarna används för felsökning och visar bland annat:

* när onboarding startade
* vilken datafil som användes
* om DemoMode var aktiverat
* vilken användare som hanterades
* vilka grupper som användes
* vilken hemkatalog som skapades
* eventuella fel

Loggfiler och genererade HR-underlag ska inte commitas till GitHub.

---

## Git och genererade filer

Följande typer av filer ska normalt inte commitas:

* loggfiler
* genererad AD-struktur
* HR-underlag i `data/hr-requests/pending`
* HR-underlag i `data/hr-requests/processed`
* lokala testfiler
* temporära filer

Detta styrs via `.gitignore`.

---

## Dokumentation

| Dokument                                        | Beskrivning                                 |
| ----------------------------------------------- | ------------------------------------------- |
| [Kom igång](docs/GET_STARTED.md)                | Guide för att klona repot och använda GUI:t |
| [Git workflow](docs/GIT_WORKFLOW.md)            | Branches, commits och pull requests         |
| [Sprintarbete](docs/sprints/README.md)          | Scrum, sprintar och Definition of Done      |
| [Förändringsledning](docs/change_management.md) | HR, IT, Awareness och Desire                |
| [Labbmiljö](docs/lab/)                          | Dokumentation för VM, AD-labb och åtkomst   |
| [Sprintdokumentation](docs/sprints/)            | Sprintplaner, review och retrospective      |
| [Service Desk](docs/service-desk/README.md)     | Support- och felsökningsinformation         |

---

## Teknik

Projektet använder:

* PowerShell
* Windows Forms
* JSON
* Active Directory
* GitHub Issues
* GitHub Projects
* GitHub Pull Requests
* VM-baserad labbmiljö

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

## Team

| Roll          | Namn                                                 |
| ------------- | ---------------------------------------------------- |
| Product Owner | [Gabriel Gustafsson](https://github.com/Gustafssoon) |
| Scrum Master  | [Ali Sulaiman](https://github.com/alisulaiman-debug) |
| Utvecklare    | [Micael Engdahl](https://github.com/icemanic)        |
| Utvecklare    | [Martin Hansson Palm](https://github.com/DrWeremoth) |
| Utvecklare    | [Zahra Hadadi](https://github.com/zahra-hadadi)      |

---