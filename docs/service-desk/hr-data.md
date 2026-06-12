# HR-data - Onboardify

Snabbguide för hur HR-data ska se ut.

---

## Exempel

```json
[
  {
    "firstName": "Anna",
    "lastName": "Svärdh",
    "title": "Lärare",
    "department": "Barn och utbildning",
    "organizationUnit": "OU=Skolan,DC=onboardify,DC=local",
    "groups": ["Lärare", "Pedagoger"],
    "license": "Microsoft 365 E3"
  }
]
```

---

## HR ska fylla i

| Fält               | Exempel                          |
| ------------------ | -------------------------------- |
| `firstName`        | Anna                             |
| `lastName`         | Svärdh                           |
| `title`            | Lärare                           |
| `department`       | Barn och utbildning              |
| `organizationUnit` | OU=Skolan,DC=onboardify,DC=local |
| `groups`           | Lärare, Pedagoger                |
| `license`          | Microsoft 365 E3                 |

---

## HR ska inte fylla i

Dessa värden skapas eller hanteras av Onboardify:

```text
SamAccountName
UserPrincipalName
homeFolder
distinguishedName
memberOf
```

---

## Viktigt om grupper

`groups` ska alltid vara en lista.

Rätt:

```json
"groups": ["Lärare", "Pedagoger"]
```

Fel:

```json
"groups": "Lärare"
```

---

## Vanliga fel

| Fel                   | Lösning                    |
| --------------------- | -------------------------- |
| Saknat fält           | Lägg till fältet           |
| Felstavad grupp       | Kontrollera gruppnamn i AD |
| Fel OU                | Kontrollera AD-strukturen  |
| Fel JSON-format       | Validera JSON-filen        |
| Grupper är inte lista | Använd `["Gruppnamn"]`     |

---

## Rekommendation

Testa alltid ändrad HR-data med DemoMode innan skarp körning:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```