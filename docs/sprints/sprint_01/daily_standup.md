# Daily Standup – Sprint 1

**Datum:** 2025-06-09

## Ali

### Vad har du gjort sedan förra mötet?
- Färdigställt issue #23 Dokumentera förändringsledning för HR.
- Lagt till dokumentationen i projektet.
- Länkat dokumentationen från README.
- Dokumenterat Sprint 1-planeringen i docs-mappen.

### Vad ska du göra till nästa möte?
- Dokumentera dagens Daily Standup.
- Fortsätta uppdatera sprintdokumentationen.

### Hinder eller problem?
- Inga hinder.

---

## Gabriel

### Vad har du gjort sedan förra mötet?
- Uppdaterat Scrum-rollerna i dokumentationen.
- Slutfört issue #58.
- Stängt issuen efter att dokumentationen uppdaterats.
- Aktiverat branch protection för main.
- Från och med nu krävs Pull Request innan kod kan mergas till main.
- Påbörjat arbete med issue #36 (huvudskriptet).

### Vad ska du göra till nästa möte?
- Fortsätta utveckla huvudskriptet för onboarding-flödet.

### Hinder eller problem?
- Problem med svenska tecken (å, ä, ö) i PowerShell.
- Löste problemet genom UTF-8-konfiguration.

---

## Micael

### Vad har du gjort sedan förra mötet?
- Arbetat vidare med loggningsfunktionen.
- Påbörjat integration mellan loggning och onboarding-flödet.
- Dokumenterat hur licenser och olika delar av processen ska loggas.

### Vad ska du göra till nästa möte?
- Anpassa loggningen till JSON-strukturen.
- Pusha sin kod till GitHub.

### Hinder eller problem?
- Behöver anpassa loggningen efter JSON-formatet.

---

## Zahra

### Vad har du gjort sedan förra mötet?
- Arbetat med issue #35 (importfunktion för onboarding-data).
- Skapat egen branch.
- Implementerat och testat kod för import av JSON-data.

### Vad ska du göra till nästa möte?
- Fortsätta testa mot JSON-strukturen.
- Skapa Pull Request när arbetet är färdigt.

### Hinder eller problem?
- Kommentarer i JSON-filen orsakade fel.
- Problemet löstes genom att använda korrekt JSON-format.

---

## Martin

### Vad har du gjort sedan förra mötet?
- Satt upp utvecklingsmiljö på hemmadatorn.
- Skapat första branchen.
- Påbörjat arbete med JSON-strukturen och exempeldata.

### Vad ska du göra till nästa möte?
- Färdigställa sample-filerna.
- Säkerställa att JSON-formatet fungerar med övriga moduler.

### Hinder eller problem?
- Behöver samordna arbetet med Zahra för att undvika merge-konflikter.

---

# Vad fungerade bra idag?

- Dokumentationen blev färdig.
- Pull Request-processen fungerar.
- Flera utvecklare arbetar parallellt i egna brancher.
- Testning av JSON-import fungerar.

# Vad fungerade mindre bra idag?

- Risk för merge-konflikter när flera ändrar samma filer.
- Problem med svenska tecken i PowerShell.
- JSON-filer innehöll kommentarer som gav fel.

# Vad ska vi förbättra till imorgon?

- Använda branch + Pull Request för alla ändringar.
- Kommunicera tidigare om flera arbetar i samma fil.
- Fortsätta samordna JSON-strukturen mellan utvecklarna.
