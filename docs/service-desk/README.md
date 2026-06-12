# Service Desk - Kunskapsstöd för Onboardify

Det här dokumentet är framtaget som kunskapsstöd för kundens IT-avdelning och Service Desk.

Syftet är att ge en tydlig överblick över hur Onboardify fungerar, hur onboarding-flödet är uppbyggt och vilka kontroller som kan göras om något går fel.

---

## Syfte

Onboardify används för att automatisera delar av onboarding-processen från nyanställd till aktivt användarkonto i Active Directory.

Dokumentationen ska hjälpa Service Desk och IT att:

* förstå hur produkten fungerar
* se vilken data HR ansvarar för
* förstå vad Onboardify automatiserar
* veta hur DemoMode används
* veta var loggar finns
* felsöka vanliga problem
* veta när ett ärende ska eskaleras

Målet är att viktig produktkunskap ska finnas samlad och vara lätt att följa vid drift, support och felsökning.

---

## Produktöversikt

Onboardify är en PowerShell-baserad onboarding-automation för Active Directory.

Produkten läser in HR-data från en JSON-fil och använder informationen för att skapa eller förbereda:

* AD-användare
* placering i rätt OU
* gruppmedlemskap
* e-post/UPN
* hemkatalog
* loggning av utförda steg

Onboardify är byggt för att minska manuellt arbete, minska risken för fel och skapa ett mer standardiserat onboarding-flöde.

---

## Onboarding-flöde

```text
1. AD-skannern körs
   ↓
2. Aktuell AD-struktur sparas
   ↓
3. HR fyller i nya personer
   ↓
4. Onboardify läser in och validerar HR-data
   ↓
5. Tekniska värden genereras
   ↓
6. Användare skapas i AD
   ↓
7. Grupper och hemkatalog hanteras
   ↓
8. Allt loggas
```

Onboardify använder HR-data som underlag, men tekniska värden skapas av scriptet.

Det innebär att HR inte behöver skriva saker som användarnamn, e-postadress, hemkatalog eller AD-attribut manuellt.

---

## HR-data

HR ansvarar för persondata och val kopplade till roll och placering.

Exempel på HR-data:

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

HR ska fylla i:

* förnamn
* efternamn
* titel
* avdelning
* OU
* grupper
* licensval

HR ska inte fylla i:

* `SamAccountName`
* `UserPrincipalName`
* `homeFolder`
* `distinguishedName`
* `memberOf`

Dessa värden skapas eller hanteras av Onboardify.

---

## DemoMode

DemoMode används för att testa onboarding-flödet utan att skapa användare eller mappar.

Exempel:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```

I DemoMode loggar Onboardify vad som skulle ha gjorts, men gör inga skarpa ändringar i AD eller filsystem.

DemoMode bör användas vid:

* test av ny HR-data
* felsökning
* demonstration
* kontroll innan skarp körning

---

## Skarp körning

Vid skarp körning används samma script utan `-DemoMode`.

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json
```

Skarp körning ska endast göras i en godkänd labb- eller driftmiljö där:

* Active Directory-modulen finns tillgänglig
* användaren som kör scriptet har rätt behörigheter
* HR-datan är kontrollerad
* DemoMode har testats vid behov

---

## Loggar

Onboardify loggar viktiga steg i onboarding-flödet.

Loggar används för att se:

* när onboarding startade
* vilken användare som hanterades
* vilka valideringar som gjordes
* om AD-användare skapades
* om grupper hanterades
* om hemkatalog skapades
* vilka fel som uppstod

Exempel på loggrad:

```text
[INFO] Startar onboarding för Anna Svärdh
[INFO] Skapar AD-användare: asvardh
[FRAMGÅNG] Användare skapad
```

Vid fel bör loggen alltid kontrolleras innan ärendet eskaleras.

---

## Vanliga fel och felsökning

| Situation                         | Kontrollpunkt                                                 |
| --------------------------------- | ------------------------------------------------------------- |
| Användare skapas inte             | Kontrollera loggar och att obligatoriska fält finns i HR-data |
| Scriptet körs men inget skapas    | Kontrollera om `-DemoMode` används                            |
| Fel OU används                    | Kontrollera `organizationUnit` i HR-data                      |
| Grupp hittas inte                 | Kontrollera stavning och att gruppen finns i AD               |
| Hemkatalog skapas inte            | Kontrollera loggar, sökväg och behörigheter                   |
| Användarnamn blir inte som väntat | Kontrollera om användarnamnet redan finns i AD                |
| JSON-filen kan inte läsas         | Kontrollera att JSON-formatet är korrekt                      |

Mer detaljerad felsökning kan dokumenteras i:

```text
docs/service-desk/felsokning.md
```

---

## När ärendet ska eskaleras

Ett ärende bör eskaleras till IT/AD-ansvarig eller produktansvarig om:

* felet återkommer efter kontroll av HR-data
* loggarna visar AD-relaterade fel
* användaren inte kan skapas trots korrekt data
* rätt OU eller grupp saknas i AD
* hemkatalog inte kan skapas på grund av behörighetsproblem
* scriptet stoppar med ett oväntat PowerShell-fel
* flera onboardingar påverkas samtidigt

Vid eskalering bör följande information skickas med:

* vilken JSON-fil som användes
* vilken användare som skulle onboardas
* om DemoMode eller skarp körning användes
* relevant loggutdrag
* felmeddelande från terminalen
* tidpunkt då felet uppstod

---

## Relaterad dokumentation

| Dokument                          | Beskrivning                                      |
| --------------------------------- | ------------------------------------------------ |
| `README.md`                       | Översikt över Onboardify AB och projektet        |
| `docs/GET_STARTED.md`             | Guide för att komma igång med repot              |
| `docs/GIT_WORKFLOW.md`            | Hur branches, commits och pull requests hanteras |
| `docs/change_management.md`       | Förändringsledning mellan HR och IT              |
| `docs/lab/`                       | Dokumentation för labbmiljö                      |
| `docs/sprints/`                   | Sprintdokumentation                              |
| `docs/service-desk/felsokning.md` | Fördjupad felsökning                             |
| `docs/service-desk/hr-data.md`    | Förklaring av HR-data och JSON-format            |
| `docs/service-desk/loggar.md`     | Förklaring av loggar och loggnivåer              |