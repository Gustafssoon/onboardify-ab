# Loggar - Onboardify

Snabbguide för hur loggar används vid felsökning.

---

## Vart loggarna placeras

Loggarna placeras:

* i den rootmapp där scriptet körs
* där skapas mappen "Logs"
* loggarna placeras i mappen "Logs"

---

## Vad loggarna visar

Loggarna visar:

* vilken användare som hanteras
* vilka steg som körs
* om scriptet körs i DemoMode
* om användaren skapades
* om grupper hanterades
* om hemkatalog skapades
* vilket fel som uppstod

---

## Loggnivåer

| Nivå       | Betydelse              |
| ---------- | ---------------------- |
| `INFO`     | Vanlig information     |
| `FRAMGÅNG` | Något lyckades         |
| `VARNING`  | Något bör kontrolleras |
| `FEL`      | Något gick fel         |

---

## Exempel på lyckad körning

```text
[INFO] Startar onboarding för Anna Svärdh
[INFO] Genererat användarnamn: asvardh
[INFO] Skapar AD-användare: asvardh
[FRAMGÅNG] Användare skapad
[INFO] Skapar hemkatalog: \\fileserver\users\asvardh
[FRAMGÅNG] Onboarding klar för Anna Svärdh
```

---

## Exempel på fel

```text
[FEL] Gruppen Pedagogerr finns inte i AD-strukturen
[FEL] Anna Svärdh skapades inte
```

---

## Kontrollera i loggen

Vid fel, kontrollera:

* vilken användare felet gäller
* om körningen var DemoMode
* vilket steg som misslyckades
* vilket felmeddelande som visas
* om felet gäller JSON, AD, grupp eller hemkatalog

---

## Vid eskalering

Skicka med:

* tidpunkt
* användare
* felmeddelande
* relevant loggutdrag
* om körningen var DemoMode eller skarp