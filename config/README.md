# Config

Den här mappen innehåller exempel på konfigurations- och datafiler som används av Onboardify AB:s onboardingverktyg.

Filerna beskriver antingen kundens miljö eller exempeldata som används vid testkörning. Tanken är att varje kund ska kunna ha sin egen struktur, sina egna OU:er, grupper och licenser utan att själva scriptet behöver skrivas om.

---

## Filer

### `customer.sample.json`

Innehåller exempel på HR-data för nyanställda personer som ska onboardas.

Filen används för att testa onboarding-flödet och visar vilka fält som HR behöver fylla i, till exempel namn, titel, avdelning, OU, grupper och licensval.

Exempel på information i filen:

* förnamn
* efternamn
* titel
* avdelning
* organisationsenhet
* grupper
* licens

Tekniska värden som användarnamn, UPN/e-post och hemkatalog ska inte fyllas i av HR. De skapas av scriptet.

---

### `org-structure.sample.json`

Innehåller exempel på kundens organisationsstruktur.

Här kan man beskriva förvaltningar, avdelningar eller företag och koppla dem till rätt OU i Active Directory.

Syftet är att Onboardify ska kunna anpassas efter olika typer av organisationer, till exempel kommuner, skolor eller privata företag.

---

### `licenses.sample.json`

Innehåller exempel på licenser som kan väljas i onboarding-processen, till exempel Microsoft 365 F3 eller E3.

Licenser kan senare kopplas till grupper, behörigheter eller andra regler i onboarding-flödet.

---

### `ad-structure.generated.json`

Den här filen skapas automatiskt av AD-skannern.

Filen innehåller den OU-struktur som har lästs från Active Directory och används för att kunna jämföra HR-data mot den faktiska miljön.

Den här filen ska inte redigeras manuellt.

---

## Viktigt

Filer som slutar på `.sample.json` är exempel och mallar.

När systemet används i en riktig miljö bör kunden skapa egna konfigurationsfiler baserade på dessa exempel.

Kundspecifika filer bör inte innehålla känslig information och ska inte commitas till GitHub om de innehåller riktiga personuppgifter eller interna domänuppgifter.