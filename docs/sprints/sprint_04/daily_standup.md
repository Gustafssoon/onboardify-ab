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

---

# Daily Standup – 2026-06-15

## Vad har vi gjort sedan förra mötet?

### Ali

* Dokumenterat Daily Standup och retrospektiv från 2026-06-14.
* Skickat Pull Request för dokumentationen till Gabriel för granskning.
* Fått Pull Request godkänd.
* Förberett Sprint Review för Sprint 4.

### Gabriel

* Arbetat vidare med GUI-prototypen.
* Förbättrat GUI:ts visuella utseende och användarvänlighet.
* Gjort GUI:t mer responsivt och anpassat för mindre skärmar.
* Tagit bort kravet på fullscreen-läge för att göra verktyget mer flexibelt.
* Implementerat en lösning som döljer CMD-fönstret som tidigare öppnades i bakgrunden vid start av verktyget.
* Granskat gruppmedlemmarnas Pull Requests.
* Testat onboarding-flödet i VM-testmiljön.
* Verifierat att användare, grupper och övriga AD-objekt skapas korrekt.
* Identifierat att hemkatalogsfunktionen fortfarande inte fungerar korrekt vid skarp körning.
* Diskuterat och skapat nya förbättringsissues för GUI och loggning.

### Zahra

* Arbetat med Issue #124 – Lägg till fler licensval i HR-formuläret.
* Uppdaterat licenseExample.json med fler exempellicenser.
* Testat lösningen tillsammans med Gabriel.
* Fått ändringarna godkända och mergade.

### Micael

* Fortsatt arbetet med Issue #121 – Spara Title och Department på AD-användaren.
* Försökt verifiera lösningen i Active Directory-miljö.
* Stött på problem med en äldre VM-miljö som inte fungerade som planerat.
* Planerar att använda den VM-miljö som Gabriel delat med gruppen för fortsatt testning.
* Diskuterat möjligheten att arbeta vidare med Issue #145 – Spike: Förbättring av loggningsfunktioner.

### Martin

* Fortsatt arbetet med Issue #126 – Gör hemkatalogskapande fungerande i VM-testmiljön.
* Samarbetat med Gabriel kring felsökning av hemkatalogsfunktionen.

---

## Vad ska vi göra tills nästa möte?

### Ali

* Dokumentera dagens Daily Standup.
* Dokumentera dagens retrospektiv.
* Förbereda Sprint Review för Sprint 4.
* Uppdatera sprintdokumentationen vid behov.

### Gabriel

* Fortsätta förbättra GUI:t.
* Hjälpa till med felsökning av hemkatalogsfunktionen.
* Granska inkommande Pull Requests.
* Fortsätta testa onboarding-flödet.

### Zahra

* Följa upp att licenshanteringen fungerar som förväntat.
* Hjälpa till med testning vid behov.

### Micael

* Fortsätta arbetet med Issue #121.
* Testa lösningen i den nya VM-miljön.
* Eventuellt påbörja arbete med Issue #145.

### Martin

* Fortsätta felsöka och verifiera hemkatalogsfunktionen.
* Testa lösningen i VM-testmiljön.

---

## Finns det några hinder eller problem?

### Ali

* Inga hinder rapporterade.

### Gabriel

* Hemkatalogsfunktionen fungerar fortfarande inte fullt ut vid skarp körning och behöver fortsatt felsökning.

### Zahra

* Inga hinder rapporterade.

### Micael

* Problem med äldre VM-miljö har försvårat testningen.

### Martin

* Hemkatalogsfunktionen kräver fortsatt felsökning.

---

# Retrospektiv – 2026-06-15

## Vad fungerade bra idag?

* GUI:t har förbättrats avsevärt och blivit mer användarvänligt.
* Responsiviteten för mindre skärmar fungerar betydligt bättre.
* Licenshanteringen färdigställdes och godkändes.
* Gruppen har fokuserat på de sista förbättringarna inför slutredovisningen.
* Flera issues har slutförts under sprinten.
* Samarbetet kring testning, kodgranskning och GUI-utveckling har fungerat bra.
* Gruppen fick en tydligare bild av hur den färdiga produkten kommer att användas av HR och IT.
* Demonstrationen av onboarding-flödet visade att huvuddelarna av lösningen fungerar enligt plan.
* Produkten börjar kännas mer färdig och redo för slutredovisningen.

## Vad fungerade mindre bra idag?

* Hemkatalogsfunktionen är fortfarande inte helt löst.
* Vissa tester har försvårats av problem i VM-miljöerna.
* Felsökning har tagit längre tid än planerat.
* Vissa funktioner har varit beroende av att testmiljön fungerar korrekt.
* Vissa tester försvårades eftersom alla inte arbetade i samma VM-miljö från början.

## Vad ska vi förbättra till imorgon?

* Slutföra kvarvarande tester i Active Directory-miljö.
* Säkerställa att hemkatalogsfunktionen fungerar korrekt.
* Förbereda Sprint Review och slutredovisning.
* Fortsätta verifiera att hela onboarding-flödet fungerar som en helhet.
* Fokusera på de sista förbättringarna och eventuella buggrättningar inför projektets avslutning.
* Fortsätta dokumentera upptäckta problem och förbättringsförslag löpande.

---

  # Daily Standup – 2026-06-16

## Vad har vi gjort sedan förra mötet?

### Ali

* Dokumenterat Daily Standup och Retrospektiv från 2026-06-15.
* Uppdaterat projektets dokumentation.
* Arbetat med Issue #137 – Dokumentera hur GUI:t används.
* Lagt till GUI-guide i GET_STARTED.md.
* Skapat Pull Request för Issue #137 och skickat den för granskning.
* Fått Pull Request godkänd.
* Förberett underlag inför Sprint Review.

### Gabriel

* Granskat gruppens Pull Requests.
* Testat onboarding-flödet med den senaste koden.
* Identifierat och åtgärdat ett problem där Scope-parametern i den krypterade lösenordskonfigurationen orsakade fel vid onboarding.
* Verifierat att onboarding-flödet fungerar efter korrigeringen.
* Felsökt och färdigställt hemkatalogsfunktionen.
* Integrerat lösningen i huvudscriptet.
* Fortsatt verifiering och testning av onboarding-flödet.

### Martin

* Arbetat med Issue #138 – Hantera genererat lösenord säkrare i output.
* Implementerat logik för att lagra genererade lösenord på ett säkrare sätt genom kryptering och filhantering.
* Påbörjat verifiering av lösningen.
* Identifierat att ytterligare testning krävs för att säkerställa att lösenord hanteras korrekt genom hela onboarding-flödet.

### Zahra

* Har tidigare färdigställt Issue #124 – Lägg till fler licensval i HR-formuläret.
* Deltog inte på dagens möte.

### Micael

* Arbetat med Issue #145 – Spike: Förbättring av loggningsfunktioner.
* Undersökt hur loggmeddelanden kan förenklas i GUI samtidigt som JSON-loggning bibehålls.
* Påbörjat verifiering av att loggfunktionen fungerar korrekt i både Demo Mode och testmiljö.
* Fortsatt arbetet med Issue #121 – Spara Title och Department på AD-användaren.

---

## Vad ska vi göra tills nästa möte?

### Ali

* Dokumentera dagens Daily Standup.
* Dokumentera dagens Retrospektiv.
* Dokumentera Sprint Review för Sprint 4.
* Uppdatera Sprintplanering 4 med eventuella ändringar från Sprint Review.

### Gabriel

* Fortsätta verifiera onboarding-flödet.
* Testa den senaste koden i huvudscriptet.
* Följa upp eventuella återstående buggar.

### Martin

* Fortsätta verifiera lösningen för säker hantering av lösenord.
* Testa att lösenord genereras, krypteras och sparas korrekt genom hela onboarding-flödet.

### Micael

* Fortsätta arbetet med loggningsfunktionen.
* Verifiera att ändringarna fungerar utan att påverka befintlig funktionalitet.

### Gruppen

* Förbereda slutredovisningen.
* Säkerställa att alla sprintuppgifter är dokumenterade och avslutade.

---

## Finns det några hinder eller problem?

### Ali

* Inga hinder eller problem rapporterade.

### Gabriel

* Inga blockerande problem rapporterade.

### Martin

* Ytterligare testning krävs för att verifiera den nya lösningen för lösenordshantering.

### Micael

* Inga blockerande problem rapporterade.

### Zahra

* Ej närvarande.

---

  # Retrospektiv – 2026-06-16

## Vad fungerade bra idag?

* Gruppen har färdigställt majoriteten av Sprint 4:s uppgifter.
* GUI:t har utvecklats till en mer användarvänlig och professionell lösning.
* Onboarding-flödet fungerar i stort sett enligt plan.
* Gruppen har arbetat seriöst enligt Scrum och ITIL under projektet.
* Trots frånvaro under delar av projektet har gruppen lyckats färdigställa lösningen.
* Samarbetet kring testning, kodgranskning och dokumentation har fungerat bra.

## Vad fungerade mindre bra idag?

* Flera gruppmedlemmar har varit frånvarande under delar av Sprint 3 och Sprint 4.
* Vissa funktioner har krävt mer felsökning än förväntat.
* Testning i VM-miljö har ibland fördröjt arbetet.

## Vad ska vi förbättra till imorgon?

* Förbereda och genomföra slutredovisningen.
* Säkerställa att all dokumentation är uppdaterad.
* Slutföra eventuella sista förbättringar och buggrättningar.
* Säkerställa att alla issues är korrekt hanterade inför projektets avslut.
