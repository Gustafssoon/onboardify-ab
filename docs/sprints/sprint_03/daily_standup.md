# Daily Standup – 2026-06-12

## Vad har vi gjort sedan förra mötet?

### Ali

* Arbetat med Issue #86 – automatisk generering av användarnamn i Active Directory.
* Implementerat hantering av svenska tecken och logik för att skapa unika användarnamn.
* Testat lösningen lokalt.
* Skapat Pull Request för review.
* Dokumenterat Sprintplanering 3.

### Gabriel

* Arbetat vidare med AD-skannern.
* Implementerat funktionalitet som hämtar AD-strukturen och genererar en JSON-fil med aktuell AD-konfiguration.
* Integrerat AD-skannern med onboarding-flödet så att scriptet kan läsa in AD-strukturen automatiskt innan onboarding startar.
* Uppdaterat README med information om AD-skannern.
* Testat demo-läget tillsammans med AD-skannern.
* Hanterat och löst flera merge-konflikter som uppstod under utvecklingen.
* Skapat ny Spike (#101) för att utreda säker generering av SamAccountName och dubblettkontroll.
* Diskuterat möjligheten att påbörja en GUI-prototyp tidigare än planerat om Sprint 3 fortsätter enligt plan.

### Zahra

* Påbörjat arbete med Issue #91 – Förbättra hemkatalogmodulen.
* Gått igenom befintlig implementation.
* Beslutat att ersätta nuvarande kod med en ny implementation för att förenkla vidareutvecklingen.
* Planerar att testa lösningen i AD-miljö när implementationen är klar.

### Micael

* Skapat Pull Request för demo-läget.
* Planerar att påbörja arbete med Spike – Vidareutveckla befintlig valideringsmodul.

---

## Vad ska vi göra tills nästa möte?

### Ali

* Dokumentera dagens Daily Scrum.
* Förbereda Daily Scrum, Retrospektiv och Sprint Review inför morgondagens möte.
* Följa upp Pull Request och eventuella kommentarer från kodgranskningen.

### Gabriel

* Fortsätta testa onboarding-flödet i AD-miljö.
* Spela in test av onboarding-flödet och dela med gruppen.
* Fortsätta arbetet med AD-relaterade förbättringar.

### Zahra

* Fortsätta utveckla hemkatalogmodulen.
* Förbereda testning i AD-miljö.

### Micael

* Följa upp Pull Request för demo-läget.
* Påbörja arbete med Spike – Vidareutveckla befintlig valideringsmodul.
* Fortsätta verifiera att demo-läget fungerar tillsammans med onboarding-flödet.

---

## Finns det några hinder eller problem?

### Gruppens status

* Inga direkta hinder rapporterades.

### Identifierade risker

* Flera funktioner behöver fortfarande verifieras i en riktig Active Directory-miljö.
* Merge-konflikter har förekommit men har kunnat lösas utan större problem.

---

# Retrospektiv

## Vad fungerade bra idag?

* Arbetet har fortsatt enligt sprintplanen trots att alla gruppmedlemmar inte kunnat delta på mötena.
* Issue #86 färdigställdes och Pull Request skapades.
* Sprintplanering 3 dokumenterades.
* Demo-läget och AD-skannern testades framgångsrikt tillsammans.
* Gruppen upplever att Sprint 3 ligger bra till jämfört med planeringen.

## Vad fungerade mindre bra idag?

* Felsökning och testning av PowerShell-koden tog längre tid än planerat.
* Merge-konflikter uppstod under utvecklingen och behövde hanteras.

## Vad ska vi förbättra till imorgon?

* Fortsätta verifiera funktionerna i Active Directory-miljö.
* Genomföra tester av onboarding-flödet och dokumentera resultatet.
* Förbereda Sprint Review och sammanställa vad som färdigställts under Sprint 3.
* Fortsätta hålla GitHub-tavlan uppdaterad.
* Fortsätta verifiera att de olika modulerna fungerar tillsammans som ett komplett onboarding-flöde.
