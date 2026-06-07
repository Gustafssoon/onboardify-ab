# Sprintarbete

Den här sidan beskriver hur vi arbetar med sprintar i Onboardify AB.

Vi använder korta sprintar på 2 dagar. Varje sprint ska ha ett tydligt sprintmål, valda issues från GitHub Projects och kort dokumentation av planering, daily standups, review och retrospective.

---

## Preliminärt sprintschema

Detta är vårt första förslag på sprintschema. Schemat är inte helt fastställt ännu, utan ska spikas på första sprintplaneringen den 8 juni kl. 12:00.

Vi kör korta sprintar på 2 dagar.

**Daily Scrum:** varje dag kl. 18:00
**Sprintplanering:** i början av varje sprint
**Sprint review:** efter Daily Scrum i slutet av varje sprint
**Sprint retrospective:** dokumenteras tillsammans med sprint review

---

### Sprint 1

**8 juni kl. 12:00**
Sprintplanering – Sprint 1

**8 juni kl. 18:00**
Daily Scrum

**9 juni kl. 18:00**
Daily Scrum + Sprint review – Sprint 1

---

### Sprint 2

**10 juni kl. 12:00**
Sprintplanering – Sprint 2

**10 juni kl. 18:00**
Daily Scrum

**11 juni kl. 18:00**
Daily Scrum + Sprint review – Sprint 2

---

### Sprint 3

**12 juni kl. 12:00**
Sprintplanering – Sprint 3

**12 juni kl. 18:00**
Daily Scrum

**13 juni kl. 18:00**
Daily Scrum + Sprint review – Sprint 3

---

### Sprint 4

**14 juni kl. 12:00**
Sprintplanering – Sprint 4

**14 juni kl. 18:00**
Daily Scrum

**15 juni kl. 18:00**
Daily Scrum + Sprint review – Sprint 4


---

## Sprintstruktur

Varje sprint dokumenteras i en egen mapp:

```txt
docs/sprints/
  sprint_01/
    sprint_plan.md
    daily_standup.md
    review_retrospective.md

  sprint_02/
    sprint_plan.md
    daily_standup.md
    review_retrospective.md

  sprint_03/
    sprint_plan.md
    daily_standup.md
    review_retrospective.md

  sprint_04/
    sprint_plan.md
    daily_standup.md
    review_retrospective.md
```

---

## Inför varje sprint-planering

Inför varje sprint går vi igenom:

* vilka issues som ska ingå i sprinten
* att varje issue har en tydlig beskrivning
* att varje issue har tydliga "Klart när"-punkter
* om någon issue behöver delas upp i mindre delar
* vem som ansvarar för varje issue
* vad sprintmålet är
* vad som ska kunna visas upp i slutet av sprinten

---

## Under sprinten

Under sprinten ska vi:

* arbeta utifrån GitHub Projects
* inte jobba med något som saknar issue
* assigna den person som tar en issue
* flytta kort i realtid när status ändras
* skriva korta daily standup-anteckningar
* lyfta hinder direkt
* testa funktioner i rätt miljö
* dokumentera resultatet löpande

---

## GitHub Projects-regler

Vi använder GitHub Projects som vår Scrum-tavla.

Regler:

- Ingen jobbar utan en Issue.
- Den som tar en uppgift assignar sig själv direkt.
- Kort flyttas i realtid:
  - Project Backlog
  - Todo
  - In Progress
  - In Review
  - Done
- Varje issue ska vara lagom liten.
- Varje issue ska ha tydliga kriterier för när den är klar.

---

## GitHub Projects-statusar

Vi använder följande statusar i GitHub Projects:

| Status          | Betydelse                                                             |
| --------------- | --------------------------------------------------------------------- |
| Project Backlog | Uppgifter som finns i projektet men inte är valda till aktuell sprint |
| Todo            | Uppgifter som ingår i sprinten men inte är påbörjade                  |
| In Progress     | Uppgifter som någon arbetar med just nu                               |
| In Review       | Uppgifter som är klara men behöver granskas                           |
| Done            | Uppgifter som är färdiga, testade och godkända                        |

---

## Definition of Done

En issue räknas som klar när:

- Funktionen eller dokumentationen är färdig
- Det är testat
- Eventuella fel hanteras på ett rimligt sätt
- Resultatet är dokumenterat kort
- Koden är pushad till GitHub
- Pull request är granskad och godkänd av Product Owner
- Kortet är flyttat till Done i GitHub Projects

---

## Daily standup

Daily standup används för att snabbt stämma av hur arbetet går.

Varje person svarar kort på:

1. Vad gjorde jag senast?
2. Vad ska jag göra idag?
3. Finns det något hinder?

Daily standup dokumenteras i sprintens [daily_standup)](docs/sprints/) som ligger placerad i vardera sprint mapp.

---

## Sprint review

I sprint review går vi igenom vad som blev klart och vad vi kan visa upp.

Vi dokumenterar:

* vad som visades
* vilka issues som blev klara
* vilka issues som inte blev klara
* eventuell feedback
* vad som behöver justeras inför nästa sprint

Sprint review dokumenteras i sprintens [review_retrospective.md)](docs/sprints/) som ligger placerad i vardera sprint mapp.

---

## Sprint retrospective

I sprint retrospective går vi igenom hur arbetet fungerade.

Vi dokumenterar:

* vad som gick bra
* vad som gick mindre bra
* vad vi lärde oss
* vad vi förbättrar till nästa sprint

Sprint retrospective dokumenteras i sprintens [review_retrospective.md)](docs/sprints/) som ligger placerad i vardera sprint mapp.

---

## Förändringsledning i sprintar

Förändringsledning dokumenteras främst i:

[change_management.md)](docs/change_management.md)
``

I varje sprint behöver vi bara skriva kort om sprinten påverkar HR:s Awareness eller Desire.

Fråga att besvara i sprintplaneringen:

**Finns det något i denna sprint som påverkar HR:s Awareness eller Desire kring onboarding-processen?**

---

## Efter varje sprint

Efter varje sprint ska vi:

* uppdatera sprintens sammanfattning
* kontrollera att GitHub Projects stämmer
* flytta färdiga issues till Done
* skriva vad som bör fokuseras på i nästa sprint
* lägga tillbaka ofärdiga issues i backloggen eller flytta dem till nästa sprint

---
