# Sprint Review – Sprint 2

## Vad blev klart?

Följande issues färdigställdes under Sprint 2:

* #14 Skapa kundkonfiguration för OU, grupper och licenser
* #16 Skapa AD-användare från onboarding-data
* #17 Placera användare i rätt OU
* #18 Lägga användare i grupper
* #19 Skapa hemkatalog för ny användare
* #38 Skapa felaktig testdata för validering och felhantering
* #46 Dokumentera Daily Standups – Sprint 2
* #73 Dokumentera Sprintplan – Sprint 2
* #79 Dokumentera Sprint 0
* #36 Spike: Skapa huvudscript som kör onboarding-flödet
* #37 Spike: Koppla ihop PowerShell-moduler med huvudscriptet

---

## Vad kan vi visa upp?

* Kundkonfiguration för OU, grupper och licenser.
* Skapande av AD-användare från onboarding-data.
* Automatisk placering i rätt OU.
* Automatisk grupptilldelning.
* Hemkatalogsfunktion för nya användare.
* Felaktig testdata för validering och felhantering.
* Dokumentation från Sprint 2.
* Integration mellan huvudscript och moduler.

---

## Vad blev inte klart?

* #21 Lägga till demo-läge i scriptet behöver ytterligare verifiering och testning innan den kan anses helt färdig.
* Funktionerna har ännu inte testats fullt ut i en riktig Active Directory-miljö.

---

## Har vi fått någon feedback eller upptäckt något vi behöver ändra?

Gruppen diskuterade att flera funktioner fungerar var för sig, men att ytterligare integrationstestning kommer att behövas när hela onboarding-flödet testas tillsammans.

Gruppen förväntar sig att fler fel kan upptäckas när systemet testas i en riktig Active Directory-miljö.

Det identifierades även att huvudscriptet riskerar att växa och bli omfattande. Om scriptet fortsätter att växa kan ytterligare refaktorering eller nya spikes behövas för att hålla koden lätt att underhålla.

---

## Vad behöver prioriteras i nästa sprint?

Gruppen föreslog att Sprint 3 ska fokusera på:

* Testning av hela onboarding-flödet.
* Verifiering i Active Directory-miljö.
* Förbättring och stabilisering av befintlig kod.
* Felsökning av upptäckta problem.
* Fortsatt dokumentation.
* Eventuella förbättringar av användarupplevelsen.
* Förberedelser inför demonstration och slutredovisning.

---

# Förändringsledning

## Påverkan på HR

Gruppen diskuterade hur automatiseringen av onboarding-processen kan minska manuellt arbete för HR.

Genom att validera onboarding-data innan användare skapas minskar risken för felaktiga användarkonton och felaktiga behörigheter. Detta bidrar till en mer standardiserad och kvalitetssäkrad onboarding-process.

Gruppen bedömde att ett framtida HR-gränssnitt (GUI) kan hjälpa HR att skapa korrekta onboarding-underlag och minska risken för mänskliga fel.

---

## Hantering av lösenord

Gruppen identifierade hanteringen av lösenord som en viktig fråga för framtida utveckling.

I den nuvarande lösningen genereras ett slumpmässigt lösenord när användaren skapas i Active Directory. Gruppen diskuterade flera möjliga lösningar för hur lösenord ska distribueras på ett säkert sätt till användaren eller HR.

Frågan bedöms behöva vidare utredning i kommande sprintar.

---

## Demo-läge och utbildning

Gruppen diskuterade även att användare behöver informeras om att demo-läget finns och hur det ska användas.

Demo-läget kan användas för utbildning och testning utan att påverka riktiga användarkonton.

---

## Sammanfattning

Gruppen bedömer att automatisering av onboarding-processen kan minska manuellt arbete, förbättra datakvaliteten och minska risken för fel. Samtidigt identifierades behov av fortsatt arbete kring lösenordshantering, testning och användarstöd inför framtida implementation.
