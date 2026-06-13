# Sprint 3 - Testning, kvalitetssäkring och förbättring av onboarding-flödet

## Sprintperiod

Start: 2026-06-12
Slut: 2026-06-13
Sprintlängd: 2 dagar

---

## Sprintmål

Testa, kvalitetssäkra och förbättra onboarding-flödet så att lösningen fungerar stabilt inför slutredovisningen.

---

## Varför är sprinten värdefull?

Sprint 3 fokuserar på att verifiera att de funktioner som utvecklats under tidigare sprintar fungerar tillsammans som ett komplett onboarding-flöde. Gruppen kommer att genomföra tester i Active Directory-miljö, identifiera fel och förbättra lösningens kvalitet och stabilitet.

Genom att testa hela flödet får gruppen en bättre förståelse för hur systemet fungerar i praktiken och kan åtgärda eventuella problem innan slutredovisningen. Sprinten är också viktig eftersom den säkerställer att lösningen uppfyller projektets vision om en automatiserad, stabil och flexibel onboarding-process.

---

## Valda Issues för sprinten

| Issue | Titel | Ansvarig | Status |
|---------|---------|---------|---------|
| #21 | Lägga till demo-läge i scriptet | Micael | In Review |
| #39 | Testa hela onboarding-flödet i AD-labbet | Gabriel | To Do |
| #85 | Vidareutveckla befintlig valideringsmodul (Spike) | Micael, Gabriel | To Do |
| #86 | Vidareutveckla automatisk generering av användarnamn och e-post/UPN (Spike) | Ali | To Do |
| #88 | Uppdatera README-dokumentationen | Gabriel | To Do |
| #91 | Förbättra hemkatalogmodulen med homeFolder från användardata | Zahra | To Do |
| #92 | Skapa en AD-skanner | Gabriel | To Do |
| #101 | Utreda säker generering av SamAccountName och dublettkontroll (Spike) | Gabriel | To Do |
| #106 | Rensa dubbletter i AD-modulen | Gabriel | To Do |
| #108 | Justera onboarding-flöde för genererat användarnamn och hemkatalog | Gabriel | To Do |
| #110 | Dokumentera Knowledge Management för Service Desk | Gabriel | To Do |
| #47 | Dokumentera daily standups – Sprint 3 | Ali | To Do |
| #50 | Dokumentera sprint review – Sprint 3 | Ali | To Do |
| #74 | Dokumentera sprintplan – Sprint 3 | Ali | To Do |


---

## Plan för sprinten

* Testa hela onboarding-flödet i Active Directory-miljö.
* Verifiera att användare skapas korrekt.
* Verifiera att användare placeras i rätt OU.
* Verifiera att gruppmedlemskap fungerar korrekt.
* Verifiera att hemkataloger skapas korrekt.
* Verifiera att demo-läget fungerar korrekt.
* Färdigställa och godkänna demo-läget.
* Undersöka förbättringar av valideringsmodulen.
* Undersöka förbättringar för automatisk generering av användarnamn och e-postadresser.
* Förbättra hemkatalogslösningen genom att använda homeFolder från användardata.
* Ta fram en AD-skanner för kontroll av skapade objekt.
* Uppdatera projektets README-dokumentation.
* Dokumentera sprintens aktiviteter och möten.
* Identifiera och åtgärda fel som upptäcks under testning.

---

## Risker

* Problem i AD-labbet kan försvåra eller försena testningen.
* Funktionerna kan fungera var för sig men inte tillsammans när hela onboarding-flödet testas.
* Nya fel kan upptäckas först under integrationstestning.
* Merge-konflikter kan uppstå när flera utvecklare arbetar i samma filer.
* Vissa issues är beroende av att andra delar fungerar korrekt.
* Testning och felsökning kan ta längre tid än planerat.
* Hantering av lösenord och säkerhetsrelaterade frågor behöver fortsatt utredning.
* Om många fel upptäcks kan sprinten behöva fokusera mer på stabilisering än på nya förbättringar.

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

Ja. Under Sprint 3 testas onboarding-flödet som en helhet, vilket ger en tydligare bild av hur den framtida onboarding-processen kommer att fungera i praktiken.

Genom att verifiera att användare, grupper, OU-struktur och hemkataloger skapas automatiskt får HR ökad förståelse för hur manuellt arbete kan minska och hur onboarding-processen kan standardiseras.

Gruppen identifierade även att hantering av lösenord är en viktig fråga inför framtida användning av systemet. Detta behöver fortsatt utredas för att säkerställa en säker och användarvänlig onboarding-process.

Sprinten bidrar därför både till ökad förståelse för den framtida lösningen och till att säkerställa att systemet fungerar på ett sätt som stödjer verksamhetens behov.

---

## Sammanfattning av sprinten

### Kort sammanfattning

Sprint 3 fokuserar på testning, kvalitetssäkring och förbättring av onboarding-flödet. Gruppen kommer att verifiera att lösningen fungerar som en helhet i Active Directory-miljö, identifiera eventuella fel och genomföra förbättringar för att säkerställa att systemet är stabilt inför slutredovisningen.

Sprinten förväntas ge gruppen den första helhetsbilden av hur lösningen fungerar i en Active Directory-miljö och skapa underlag för de sista förbättringarna inför slutredovisningen.

### Nästa sprint bör fokusera på

* Förbereda demo och slutredovisning av projektet.
* Genomföra slutlig verifiering av onboarding-flödet.
* Skapa återställning och cleanup efter genomförda AD-tester.
* Säkerställa att dokumentationen är komplett och uppdaterad.
* Planera och genomföra demonstrationsflödet.
* Fördela ansvar inför slutredovisningen.
* Eventuellt utveckla en enkel GUI-prototyp om tid finns efter testning och felsökning.
* Genomföra eventuella sista förbättringar baserat på resultat från Sprint 3.
