# Test-VM-miljö för Onboardify AB

Den här testmiljön används för att kunna testa Onboardify AB:s onboarding-automatisering mot en riktig Active Directory-miljö.

Miljön är skapad för utveckling och test.

## Syfte

Testmiljön används för att testa att onboarding-scriptet kan:

* skapa användare i Active Directory
* placera användare i rätt OU
* lägga till användare i rätt grupper
* testa licensgrupper och rollgrupper
* testa resursgrupper och behörigheter
* läsa in data från JSON/CSV

## AD-struktur

I Active Directory finns en demo-struktur för `Demokommun`.

```text
Onboardify
└── Demokommun
    ├── Förvaltningar
    │   ├── Kommunledningsförvaltningen
    │   │   ├── Användare
    │   │   └── Datorer
    │   │
    │   ├── Kultur- och fritidsförvaltningen
    │   │   ├── Användare
    │   │   └── Datorer
    │   │
    │   ├── Samhällsbyggnadsförvaltningen
    │   │   ├── Användare
    │   │   └── Datorer
    │   │
    │   ├── Socialförvaltningen
    │   │   ├── Användare
    │   │   └── Datorer
    │   │
    │   └── Utbildningsförvaltningen
    │       ├── Användare
    │       └── Datorer
    │
    ├── Grupper
    │   ├── Avdelningsgrupper
    │   ├── Licensgrupper
    │   ├── Resursgrupper
    │   └── Rollgrupper
    │
    └── Kommunala bolag
        ├── Bostäder AB
        │   ├── Användare
        │   └── Datorer
        │
        └── Energi AB
            ├── Användare
            └── Datorer
```

## Gruppstandard

Vi använder en enkel namnstandard för grupper i labbmiljön.

| Prefix | Betydelse                   |
| ------ | --------------------------- |
| `GR`   | Global säkerhetsgrupp       |
| `DL`   | Domain Local säkerhetsgrupp |
| `RW`   | Read/Write                  |
| `R`    | Read Only                   |

Exempel:

```text
GR Kommunledning IT
GR Utbildning Lärare
GR Socialförvaltning Handläggare
GR Licens Microsoft 365 E3
GR Licens Microsoft 365 Copilot
GR Licens Adobe Acrobat Pro
GR Roll Lärare
GR Roll IT Administratör
DL Utbildning Gemensam RW
DL Utbildning Gemensam RO
```

## Hur strukturen används

När onboarding-scriptet skapar en ny användare ska det kunna:

1. skapa användaren i rätt OU
2. lägga användaren i rätt avdelningsgrupp
3. lägga användaren i rätt rollgrupp
4. lägga användaren i rätt licensgrupp
5. lägga användaren i rätt resursgrupp vid behov

Exempel:

```text
Förvaltning: Utbildningsförvaltningen
Roll: Lärare
Licens: Microsoft 365 E3
Resurs: Utbildning Gemensam RW
```

Resultat:

```text
OU:
Onboardify > Demokommun > Förvaltningar > Utbildningsförvaltningen > Användare

Grupper:
GR Utbildning Lärare
GR Roll Lärare
GR Licens Microsoft 365 E3
DL Utbildning Gemensam RW
```

## Ladda ner testmiljön

Testmiljön kan laddas ner här:

https://www.swisstransfer.com/d/54720da1-739c-4f28-aafa-42b781ac78cf

I zip-filen finns en README med:

* användarnamn
* lösenord

## Viktigt

* VM:n ska köras lokalt i VMware.
* Välj `I copied it` om VMware frågar om VM:n har flyttats eller kopierats.
* Miljön är endast till för test och utveckling.
