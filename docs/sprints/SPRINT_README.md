# Sprintarbete

Den här sidan beskriver hur vi arbetar med sprintar i Onboardify AB.

Vi använder korta sprintar på 2 dagar. Varje sprint ska ha ett tydligt sprintmål, valda issues från GitHub Projects och kort dokumentation av planering, daily standups, review och retrospective.

---

## Sprintstruktur

Varje sprint dokumenteras i en egen mapp:

```txt
docs/sprints/
  sprint_01/
    sprint_plan.md
    daily-standups.md
    review-retrospective.md

  sprint_02/
    sprint_plan.md
    daily-standups.md
    review-retrospective.md

  sprint_01/
    sprint_plan.md
    daily-standups.md
    review-retrospective.md

  sprint_02/
    sprint_plan.md
    daily-standups.md
    review-retrospective.md
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

## Daily standup

Daily standup används för att snabbt stämma av hur arbetet går.

Varje person svarar kort på:

1. Vad gjorde jag senast?
2. Vad ska jag göra idag?
3. Finns det något hinder?

Daily standup dokumenteras i sprintens `daily-standups.md`.

---

## Sprint review

I sprint review går vi igenom vad som blev klart och vad vi kan visa upp.

Vi dokumenterar:

* vad som visades
* vilka issues som blev klara
* vilka issues som inte blev klara
* eventuell feedback
* vad som behöver justeras inför nästa sprint

Sprint review dokumenteras i sprintens `review-retrospective.md` inför respektive sprint.

---

## Sprint retrospective

I sprint retrospective går vi igenom hur arbetet fungerade.

Vi dokumenterar:

* vad som gick bra
* vad som gick mindre bra
* vad vi lärde oss
* vad vi förbättrar till nästa sprint

Sprint retrospective dokumenteras i sprintens `review-retrospective.md` inför respektive sprint.

---

## Förändringsledning i sprintar

Förändringsledning dokumenteras främst i:

```txt
docs/change-management.md
```

I varje sprint behöver vi bara skriva kort om sprinten påverkar HR:s Awareness eller Desire.

Fråga att besvara i sprintplaneringen:

**Finns det något i denna sprint som påverkar HR:s Awareness eller Desire kring onboarding-processen?**

Om svaret är nej skriver vi:

```txt
Ingen särskild påverkan i denna sprint.
```

---

## Efter varje sprint

Efter varje sprint ska vi:

* uppdatera sprintens sammanfattning
* kontrollera att GitHub Projects stämmer
* flytta färdiga issues till Done
* skriva vad som bör fokuseras på i nästa sprint
* lägga tillbaka ofärdiga issues i backloggen eller flytta dem till nästa sprint

---
