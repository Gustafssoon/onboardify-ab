# Onboardify AB

Onboardify AB är ett fiktivt företag som bygger en flexibel onboarding-automatisering.

Målet är att hjälpa organisationer att gå från nyanställning till aktivt användarkonto på ett mer kontrollerat, repeterbart och felsäkert sätt.

Projektet är byggt som en PowerShell-baserad prototyp för Active Directory där HR fyller i användardata och IT automatiserar skapandet av användare, grupper och hemkataloger.

---

## Product Vision

Vi vill bygga en enkel och trygg onboarding-process där HR kan fylla i rätt information från början och IT kan automatisera skapandet av konto, grupper och hemkataloger.

Produkten ska inte vara hårdkodad för ett enda företag, utan kunna anpassas till flera typer av organisationer, till exempel kommuner, skolor och privata företag.

---

## Produktmål

Målet är att bygga en fungerande prototyp där en nyanställd kan läsas in från JSON och sedan hanteras i Active Directory med:

- rätt OU
- rätt grupper
- rätt licensval
- automatiskt användarnamn
- automatiskt e-post/UPN
- automatisk hemkatalog
- loggning och felhantering

JSON är huvudformatet i nuläget. CSV finns med i produktidén men är inte huvudspåret just nu.

---

## Nuvarande status

Projektet har just nu stöd för:

- inläsning av användardata från JSON
- validering av obligatoriska fält
- AD-skanner som läser OU-struktur
- genererad AD-strukturfil
- DemoMode där inga användare eller mappar skapas
- automatisk generering av SamAccountName
- automatisk generering av e-post/UPN
- kontroll om användare redan finns
- skapande av AD-användare
- gruppmedlemskap efter att användaren skapats
- skapande av hemkatalog
- loggning och Try/Catch-felhantering

---

## Onboarding-flöde

```text
1. AD-skannern körs
   ↓
2. Aktuell AD-struktur sparas
   ↓
3. HR fyller i nya personer
   ↓
4. Onboardify validerar HR-data
   ↓
5. Onboardify genererar tekniska värden
   ↓
6. Användare skapas i AD
   ↓
7. Grupper och hemkatalog sätts
   ↓
8. Allt loggas
```

---

## AD-skanner

Projektet har en AD-skanner som läser av OU-strukturen i Active Directory och sparar resultatet till en JSON-fil.

Filen sparas som:

```text
config/ad-structure.generated.json
```

Syftet är att Onboardify inte ska behöva hårdkoda kundens OU-struktur direkt i scriptet. Skannern läser endast information från AD och gör inga ändringar.

Nästa steg är att använda den genererade AD-strukturen för att validera HR-data mot vilka OU:er, grupper och licenser som är tillåtna.

---

## HR-data

HR ska bara fylla i information som HR faktiskt äger.

Exempel:

```json
[
  {
    "firstName": "Anna",
    "lastName": "Svärdh",
    "title": "Lärare",
    "department": "Barn och utbildning",
    "organizationUnit": "OU=Skolan,DC=onboardify,DC=local",
    "groups": ["Lärare", "Pedagoger"],
    "license": "Microsoft 365 E3"
  }
]
```

HR ska inte behöva skriva tekniska värden som:

- `SamAccountName`
- `UserPrincipalName`
- `homeFolder`
- `distinguishedName`
- `memberOf`

Detta ska Onboardify skapa eller hantera automatiskt.

---

## Tekniska värden

När HR-datan är godkänd skapar Onboardify tekniska värden.

Exempel:

```text
Namn: Anna Svärdh
Username: asvardh
Email/UPN: asvardh@onboardify.local
HomeFolder: \\fileserver\users\asvardh
```

Hemkatalogen byggs från det användarnamn som scriptet faktiskt använder.

Det minskar risken att HR skriver fel mappnamn eller tekniska sökvägar.

---

## DemoMode

DemoMode används för att testa flödet utan att skapa något i AD eller på filservern.

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```

I DemoMode loggar scriptet vad som skulle ha gjorts, men gör inga skarpa ändringar.

---

## Skarp körning i labbmiljö

När scriptet körs utan DemoMode skapas användare och hemkataloger i labbmiljön.

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json
```

Scriptet ska köras i en miljö där Active Directory-modulen finns tillgänglig.

---

## Modulstruktur

| Modul | Ansvar |
|---|---|
| `Onboardify.Discovery.psm1` | Läser av AD-struktur och skapar `ad-structure.generated.json` |
| `Onboardify.Import.psm1` | Läser in användardata från JSON |
| `Onboardify.Validation.psm1` | Validerar att obligatoriska fält finns |
| `Onboardify.AD.psm1` | Skapar användarnamn, e-post/UPN och AD-användare |
| `Onboardify.Folders.psm1` | Skapar hemkatalog |
| `Onboardify.Logging.psm1` | Skriver loggar till terminal och loggfil |

---

## Teknik

Projektet använder:

- PowerShell
- JSON
- Active Directory
- GitHub Projects
- GitHub Issues
- VM-labbmiljö

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
│   └── sprints/
├── src/
│   ├── Start-Onboarding.ps1
│   └── modules/
├── tests/
└── README.md
```

---

## Roller i gruppen

| Roll | Namn | Ansvar |
|---|---|---|
| Product Owner | [Gabriel Gustafsson](https://github.com/Gustafssoon) | Ansvarar för backlogg, prioritering, GitHub Projects och produktmål |
| Scrum Master | [Ali Sulaiman](https://github.com/alisulaiman-debug) | Håller ihop Scrum-arbetet, möten och hinder |
| Utvecklare | [Micael Engdahl](https://github.com/icemanic) | Bygger, testar och dokumenterar delar av lösningen |
| Utvecklare | [Martin Hansson Palm](https://github.com/DrWeremoth) | Bygger, testar och dokumenterar delar av lösningen |
| Utvecklare | [Zahra Hadadi](https://github.com/zahra-hadadi) | Bygger, testar och dokumenterar delar av lösningen |

Rollerna hjälper oss att fördela ansvar, men alla i gruppen hjälps åt med kod, testning, dokumentation och att hålla arbetet uppdaterat.

---

## Arbetssätt

Vi använder GitHub Projects som Scrum-tavla.

Grundregler:

- Ingen jobbar utan en Issue.
- Den som tar en uppgift assignar sig själv.
- Kort flyttas i realtid mellan Project Backlog, Todo, In Progress, In Review och Done.
- Varje issue ska vara lagom liten.
- Varje issue ska ha tydliga kriterier för när den är klar.

Mer detaljer finns i [Sprintarbete](docs/SPRINT_README.md).

---

## Dokumentation

| Dokument | Beskrivning |
|---|---|
| [Kom igång](docs/GET_STARTED.md) | Guide för att komma igång med Git och klona repot |
| [Git workflow](docs/GIT_WORKFLOW.md) | Hur vi jobbar med branches, commits och pull requests |
| [Förändringsledning](docs/change_management.md) | HR, IT, Awareness och Desire |
| [Sprintarbete](docs/SPRINT_README.md) | Hur vi planerar och dokumenterar sprintar |
| [Labbmiljö](docs/lab/) | Dokumentation för VM, AD-labb och åtkomst |
| [Sprintdokumentation](docs/sprints/) | Daily standups, sprint review och retrospective |
| [Service Desk-dokumentationen](docs/service-desk/README.md) | Information för Service Desk |

---