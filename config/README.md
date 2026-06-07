# Config

Den här mappen innehåller exempel på konfigurationsfiler som används av Onboardify AB onboardingverktyg.

Filerna beskriver kundens miljö och regler, till exempel domän, organisationsstruktur, OU:er, grupper och licenser. Tanken är att varje kund ska kunna ha sin egen konfiguration utan att själva scriptet behöver skrivas om.

## Filer

### `customer.sample.json`

Innehåller kundens grundinställningar, till exempel kundnamn, domän och standardvärden som scriptet behöver.

### `org-structure.sample.json`

Innehåller exempel på kundens organisationsstruktur. Här kan man beskriva förvaltningar, avdelningar eller företag och koppla dem till rätt OU i Active Directory.

### `licenses.sample.json`

Innehåller exempel på licenser som kan väljas i onboarding-processen, till exempel Microsoft 365 F3 eller E3. Licenser kan senare kopplas till grupper eller behörigheter.

## Viktigt

När systemet används på riktigt bör kunden skapa egna konfigurationsfiler baserade på dessa exempel.
