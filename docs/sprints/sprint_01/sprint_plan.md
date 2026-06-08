# Sprint 1 - Grundläggande onboarding-flöde

## Sprintperiod

**Start:** 2026-06-08
**Slut:** 2026-06-09
**Sprintlängd:** 2 dagar

---

## Sprintmål

Skapa grunden för Onboardify genom att ta fram JSON-struktur, importfunktion, validering och loggning samt påbörja arbetet med att koppla ihop onboarding-flödet i PowerShell.

---

## Varför är sprinten värdefull?

Denna sprint lägger grunden för hela onboarding-systemet. Genom att definiera dataformat, läsa in användardata, validera information och skapa loggning skapas förutsättningar för att automatisera onboarding-processen i kommande sprintar.

---

## Valda Issues för sprinten

| Issue | Titel                                           | Ansvarig     | Status |
| ----- | ----------------------------------------------- | ------------ | ------ |
| #13   | Skapa JSON-struktur för onboarding-data         | Martin       | To Do  |
| #15   | Validera onboarding-data innan användare skapas | Martin       | To Do  |
| #20   | Skapa loggning för onboarding-processen         | Micael       | To Do  |
| #23   | Dokumentera förändringsledning för HR           | Ali          | To Do  |
| #35   | Skapa importfunktion för onboarding-data        | Zahra        | To Do  |
| #36   | Skapa huvudscript som kör onboarding-flödet     | Ej tilldelad | To Do  |
| #37   | Koppla ihop PowerShell-moduler med huvudscript  | Ej tilldelad | To Do  |
| #40   | Dokumentera daily standups – Sprint 1           | Ali          | To Do  |
| #41   | Dokumentera sprint review – Sprint 1            | Ali          | To Do  |
| #58   | Uppdatera dokumentation med Scrum-roller        | Gabriel      | To Do  |

---

## Plan för sprinten

* Skapa JSON-struktur för onboarding-data.
* Implementera funktion för import av JSON-data.
* Implementera validering av användardata innan användare skapas.
* Skapa loggning för onboarding-processen.
* Uppdatera dokumentationen med Scrum-roller.
* Dokumentera sprintens möten och aktiviteter.
* Påbörja arbetet med huvudscript och integration mellan moduler.
* Testa att de framtagna komponenterna fungerar var för sig.

---

## Risker

* Flera gruppmedlemmar har begränsad erfarenhet av programmering.
* Endast en gruppmedlem har god kunskap om JSON-formatet.
* Gruppen är beroende av att JSON-strukturen blir korrekt eftersom flera uppgifter bygger vidare på den.

---

## Definition of Done

En issue räknas som klar när:

* Arbetet i issuen är färdigt.
* Funktionen eller dokumentationen är testad.
* Resultatet är dokumenterat.
* Kod eller dokumentation är pushad till GitHub.
* Kortet är flyttat till Done i GitHub Projects.

---

## Förändringsledning

**Finns det något i denna sprint som påverkar HR:s Awareness eller Desire kring onboarding-processen?**

**Svar:**

Ja. Arbetet med förändringsledning för HR hjälper till att beskriva varför onboarding-processen behöver förbättras och hur HR kommer att involveras i den framtida lösningen. Detta bidrar till ökad förståelse för förändringen och varför den är viktig för verksamheten.

---

# Sammanfattning av sprinten

## Kort sammanfattning

Sprint 1 fokuserar på att skapa de grundläggande komponenterna som behövs för att bygga Onboardify. Gruppen arbetar med JSON-struktur, import, validering, loggning och dokumentation. Sprinten förväntas skapa en stabil grund för integration mot Active Directory och vidare utveckling av onboarding-flödet.

---

## Nästa sprint bör fokusera på

* Skapa AD-användare från onboarding-data.
* Placera användare i rätt OU och grupper.
* Skapa hemkatalog för nya användare.
* Integrera Sprint 1-komponenterna med Active Directory.
* Fortsätta testning och verifiering av onboarding-flödet.
