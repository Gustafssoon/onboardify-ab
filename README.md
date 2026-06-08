# Onboardify AB

Onboardify AB är ett fiktivt företag som bygger en flexibel onboarding-automatisering.
Produkten ska hjälpa organisationer att gå från nyanställning till aktivt användarkonto
på ett smidigt och kontrollerat sätt.

Systemet ska kunna läsa in data från JSON/CSV och sedan skapa användare, mappar,
behörigheter och grupper i en testmiljö med Active Directory.

---

## Product Vision

Vi vill bygga en enkel och trygg onboarding-process där HR kan fylla i rätt information
från början och IT kan automatisera skapandet av konto, mappar och behörigheter.

Produkten ska inte vara hårdkodad för ett enda företag, utan kunna anpassas till flera
typer av organisationer, till exempel kommuner, skolor och privata företag.

---

## Produktmål

Målet är att bygga en fungerande prototyp där en nyanställd kan läsas in via JSON/CSV
och sedan skapas i Active Directory med rätt OU, grupper, licenser och mappar.

---

## Teknik

Projektet använder:

- PowerShell
- JSON/CSV
- Active Directory
- GitHub Projects
- GitHub Issues
- VM-labbmiljö

---

## Roller i gruppen

| Roll | Namn | Ansvar |
|---|---|---|
| Product Owner | [Gabriel Gustafsson](https://github.com/Gustafssoon) | Ansvarar för GitHub Projects, backloggen och prioriteringen av issues. Ser till att arbetet kopplas till produktidén för Onboardify AB och att gruppen jobbar med rätt saker i rätt ordning. Skapar och strukturerar issues, följer upp status på tavlan och ser till att varje issue har tydliga krav för när den är klar. |
| Scrum Master | [Ali Sulaiman](https://github.com/alisulaiman-debug) | Håller ihop gruppens Scrum-arbete. Ansvarar för att daily standups, sprint review och retrospective genomförs. Hjälper gruppen att hålla fokus på sprintmålet och lyfter hinder som påverkar arbetet. |
| Utvecklare | [Micael Engdahl](https://github.com/icemanic) | Bygger och testar delar av lösningen. Arbetar med script, dokumentation, testmiljö och andra issues som behövs för att få onboarding-flödet att fungera. |
| Utvecklare | [Martin Hansson Palm](https://github.com/DrWeremoth) | Bygger och testar delar av lösningen. Arbetar med script, dokumentation, testmiljö och andra issues som behövs för att få onboarding-flödet att fungera. |
| Utvecklare | [Zahra Hadadi](https://github.com/zahra-hadadi) | Bygger och testar delar av lösningen. Arbetar med script, dokumentation, testmiljö och andra issues som behövs för att få onboarding-flödet att fungera. |

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

---
