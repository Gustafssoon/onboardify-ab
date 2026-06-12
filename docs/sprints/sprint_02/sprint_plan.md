# Sprint 2 - Active Directory och onboarding-konfiguration

## Sprintperiod

Start: 2026-06-10
Slut: 2026-06-11
Sprintlängd: 2 dagar

---

## Sprintmål

Bygga kärnfunktionaliteten i onboarding-flödet genom att skapa Active Directory-användare, placera användare i rätt organisatoriska enheter (OU), lägga till användare i grupper samt konfigurera användarnas miljö automatiskt.

---

## Varför är sprinten värdefull?

Denna sprint bygger vidare på grunden som skapades under Sprint 1. Nu när JSON-struktur, importfunktion, validering och loggning finns på plats kan gruppen börja utveckla den centrala funktionaliteten i onboarding-processen.

Genom att automatisera skapandet av användare i Active Directory kan organisationen minska manuellt arbete, minska risken för fel och skapa en mer effektiv onboardingprocess. Sprinten för projektet närmare ett komplett system som kan användas för att hantera nya medarbetare på ett standardiserat sätt.

---

## Valda Issues för sprinten

| Issue | Titel                                                   | Ansvarig     | Status |
| ----- | ------------------------------------------------------- | ------------ | ------ |
| #14   | Skapa kundkonfiguration för OU, grupper och licenser    | Ali          | Done   |
| #16   | Skapa AD-användare från onboarding-data                 | Martin       | To Do  |
| #17   | Placera användare i rätt OU                             | Martin       | To Do  |
| #18   | Lägga användare i en eller flera grupper                | Martin       | To Do  |
| #19   | Skapa hemkatalog för ny användare                       | Zahra        | To Do  |
| #38   | Skapa felaktig testdata för validering och felhantering | Gabriel      | To Do  |
| #39   | Lägga till demo-läge i scriptet                         | Micael       | To Do  |
| #46   | Dokumentera daily standups – Sprint 2                   | Ali          | To Do  |
| #49   | Dokumentera sprint review – Sprint 2                    | Ali          | To Do  |
| #73   | Dokumentera sprintplan – Sprint 2                       | Ali          | To Do  |
| #36   | Skapa huvudscript som kör onboarding-flödet (Spike)     | Gabriel      | To Do  |
| #37   | Koppla ihop PowerShell-moduler med huvudscript (Spike)  | Gabriel      | To Do  |

---

## Plan för sprinten

* Skapa kundkonfiguration för OU-struktur, grupper och licenser.
* Implementera funktion för att skapa användare i Active Directory.
* Placera användare i rätt OU baserat på onboarding-data.
* Lägga till användare i en eller flera AD-grupper.
* Skapa hemkatalog för nya användare.
* Ta fram testdata för validering och felhantering.
* Implementera demo-läge för säkrare testning.
* Dokumentera sprintens aktiviteter och möten.
* Fortsätta undersöka hur huvudscriptet ska integreras med projektets moduler.
* Verifiera att onboarding-flödet fungerar stegvis när nya funktioner läggs till.

---

## Risker

* Flera gruppmedlemmar arbetar i samma repository vilket kan skapa merge-konflikter.
* Active Directory-funktioner kräver noggrann testning för att undvika felaktiga användarkonton.
* Flera delar av sprinten bygger på att Sprint 1-komponenterna fungerar korrekt.
* Om integrationen mellan modulerna inte fungerar kan utvecklingen försenas.

---

## Definition of Done

En issue räknas som klar när:

* Arbetet i issuen är färdigt.
* Funktionen eller dokumentationen är testad.
* Resultatet är dokumenterat.
* Kod eller dokumentation är pushad till GitHub.
* Pull Request är skapad.
* Eventuell kodgranskning är genomförd.
* Kortet är flyttat till Done i GitHub Projects.

---

## Förändringsledning

Finns det något i denna sprint som påverkar HR:s Awareness eller Desire kring onboarding-processen?

### Svar

Ja. När onboarding-processen börjar automatiseras i Active Directory blir det tydligare för HR hur den framtida lösningen kommer att minska manuellt arbete och skapa en mer standardiserad process för nya medarbetare. Detta bidrar till ökad förståelse för förändringen och visar det praktiska värdet av systemet.

---

## Sammanfattning av sprinten

### Kort sammanfattning

Sprint 2 fokuserar på att utveckla kärnfunktionaliteten i Onboardify. Gruppen arbetar med att skapa användare i Active Directory, placera dem i rätt OU, lägga till gruppmedlemskap samt konfigurera användarnas miljö. Samtidigt fortsätter dokumentation och testarbete för att säkerställa att lösningen fungerar korrekt.

### Nästa sprint bör fokusera på

* Förbättrad validering och felhantering.
* Fler tester av onboarding-flödet.
* Stabilisering och förbättring av befintlig funktionalitet.
* Ytterligare integration mellan projektets moduler.
* Förberedelser inför en mer komplett demonstration av systemet.
