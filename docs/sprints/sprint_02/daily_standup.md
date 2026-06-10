# Daily Standup – 2026-06-10

## Vad har vi gjort sedan förra mötet?

### Ali

* Slutfört Issue #14 – kundkonfiguration för OU-grupper och licenser.
* Skapat och uppdaterat:

  * `org-structure.sample.json`
  * `licenses.sample.json`
* Testat lösningen lokalt med testdata.
* Verifierat att JSON-filerna kan läsas in och valideras.
* Kört onboarding-flödet via `Start-Onboarding.ps1`.
* Skapat Pull Request #78 för granskning.

### Gabriel

* Dokumenterat Sprint 0 och markerat den som klar.
* Påbörjat Issue #38 – Skapa felaktig testdata för validering och felhantering.
* Skapat mappen `test/invalid-data`.
* Tagit fram fyra felaktiga JSON-filer:

  * Saknar username-fält.
  * Tomt username-fält.
  * Pekar på OU som inte existerar.
  * Pekar på grupp som inte existerar.

### Martin

* Slutfört Issue #16 – Skapa AD-användare från onboarding-data.
* Planerar att fortsätta med:

  * Issue #17 – Placera användare i rätt OU.
  * Issue #18 – Lägga användare i grupper.

### Zahra

* Planerar att påbörja Issue #19 – Skapa hemkatalog för ny användare.

### Micael

* Planerar att påbörja Issue #39 – Lägga till demo-läge i scriptet.

---

## Vad ska vi göra tills nästa möte?

### Ali

* Dokumentera Daily Standup.
* Dokumentera Sprint Plan 2.
* Förbereda nästa Daily Scrum.
* Förbereda Sprint Review.

### Gabriel

* Fortsätta med felaktig testdata och valideringstestning.

### Martin

* Färdigställa Issue #17 och #18.

### Zahra

* Påbörja och utveckla hemkatalogsfunktionen.

### Micael

* Arbeta vidare med demo-läget.

---

## Finns det några hinder eller problem?

### Gruppens status

* Inga direkta hinder rapporterades.

### Identifierade risker

* Flera utvecklare arbetar i samma repository vilket kan leda till merge-konflikter.
* Funktionerna har ännu inte testats mot en riktig Active Directory-miljö.
* Gruppen förväntar sig att ytterligare fel kan upptäckas när integrationstestning mot AD genomförs.

---

# Retrospektiv

## Vad fungerade bra idag?

* Sprintplaneringen gav en tydlig ansvarsfördelning.
* Issue #14 färdigställdes och verifierades lokalt.
* Issue #16 färdigställdes.
* Arbetet med testdata för validering påbörjades.
* Inga merge-konflikter uppstod under dagen.

## Vad fungerade mindre bra idag?

* Gruppen har ännu inte kunnat testa funktionerna mot Active Directory.
* Viss osäkerhet kvarstår kring hur integrationen kommer fungera i en riktig AD-miljö.

## Vad ska vi förbättra till imorgon?

* Fortsätta integrera funktionerna stegvis.
* Testa fler scenarier med felaktig data.
* Förbereda kommande integrationstestning mot Active Directory.
* Fortsätta hålla GitHub-tavlan uppdaterad.
