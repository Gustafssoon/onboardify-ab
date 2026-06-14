# Daily Standup – 2026-06-14

## Vad har vi gjort sedan förra mötet?

### Ali

* Dokumenterat Sprintplanering 4 efter sprintplaneringsmötet.
* Uppdaterat sprintmål, överförda issues, ansvarsfördelning och sprintaktiviteter.
* Skapat Pull Request för Sprintplanering 4.
* Fått Pull Request granskad och godkänd.
* Gått igenom Sprint 4-issues och ansvarsfördelning.

### Gabriel

* Arbetat vidare med GUI-prototypen.
* Förbättrat GUI:ts visuella utseende och användarvänlighet.
* Anpassat GUI:t för mindre skärmar och förbättrat responsiviteten.
* Implementerat möjlighet att visa och dölja loggfönstret för att frigöra plats i gränssnittet.
* Verifierat att verktyget nu automatiskt begär administratörsbehörighet vid start, vilket förenklar användningen.
* Skapat nya förbättringsissues för GUI-utvecklingen.
* Testat hela onboarding-flödet i VM-testmiljön.
* Visat Discovery-processen där AD-strukturen skannas och exporteras till JSON.
* Demonstrerat HR-flödet där HR fyller i användaruppgifter, väljer organisation, titel och licenser.
* Demonstrerat IT-flödet där onboardingförfrågningar granskas och körs i demo- eller skarpt läge.
* Verifierat att användare skapas korrekt i Active Directory.
* Identifierat att hemkatalogsskapandet fortfarande inte fungerar korrekt vid skarp körning.
* Skapat ny issue för att åtgärda hemkatalogsfunktionen i VM-testmiljön.

### Martin

* Tilldelats Issue #126 – Gör hemkatalogskapande fungerande i VM-testmiljön.
* Har ännu inte påbörjat arbetet med issuen.

### Zahra

* Tilldelats Issue #124 – Lägg till fler licensval i HR-formuläret.
* Har ännu inte påbörjat implementationen.
* Diskuterat möjliga ytterligare licensalternativ som kan läggas till i formuläret.

### Micael

* Tilldelats Issue #121 – Spara Title och Department på AD-användaren.
* Har ännu inte påbörjat implementationen.

---

## Vad ska vi göra tills nästa möte?

### Ali

* Dokumentera dagens Daily Standup och Retrospektiv.
* Förbereda nästa Daily Scrum.

### Gabriel

* Fortsätta utveckla GUI-funktionaliteten.
* Fortsätta felsöka hemkatalogsfunktionen.
* Fortsätta verifiera onboarding-flödet i VM-testmiljön.

### Martin

* Påbörja arbetet med Issue #126.
* Felsöka och åtgärda hemkatalogsfunktionen.

### Zahra

* Påbörja arbetet med Issue #124.
* Lägga till fler licensalternativ i HR-formuläret.

### Micael

* Påbörja arbetet med Issue #121.
* Implementera lagring av Title och Department på AD-användare.

### Gruppen

* Testa verktyget i testmiljö.
* Fortsätta identifiera förbättringsområden inför slutredovisningen.

---

## Finns det några hinder eller problem?

### Gruppens status

* Inga blockerande problem rapporterades.

### Identifierade risker

* Hemkatalogsskapandet fungerar fortfarande inte korrekt vid skarp körning i VM-testmiljön.
* Ytterligare problem kan upptäckas när hela onboarding-flödet testas.
* Flera Sprint 4-issues har precis påbörjats och behöver färdigställas inför slutredovisningen.

---

# Retrospektiv

## Vad fungerade bra idag?

* Sprintplanering 4 färdigställdes och dokumenterades.
* Pull Request för Sprintplanering 4 skapades, granskades och godkändes.
* GUI-prototypen har utvecklats betydligt och fått ett mer professionellt utseende.
* GUI:t har blivit mer användarvänligt för både HR och IT.
* Gruppen fick se hela onboarding-processen demonstreras i VM-testmiljön.
* Discovery-, HR- och IT-flödet fungerade enligt förväntan.
* Produkten börjar kännas mer färdig och redo för slutredovisning.

## Vad fungerade mindre bra idag?

* Hemkatalogsfunktionen fungerar fortfarande inte fullt ut vid skarp körning.
* GUI-utvecklingen har varit mer tidskrävande än förväntat på grund av begränsningar i PowerShell/WPF.
* Flera nya issues upptäcktes under testningen.

## Vad ska vi förbättra till imorgon?

* Färdigställa hemkatalogsfunktionen.
* Fortsätta verifiera hela onboarding-flödet.
* Påbörja och färdigställa Sprint 4-issues enligt plan.
* Fortsätta förbättra GUI:t inför slutredovisningen.
* Dokumentera upptäckta problem och förbättringsförslag löpande.
* Säkerställa att hela lösningen fungerar stabilt inför demonstration och slutredovisning.
