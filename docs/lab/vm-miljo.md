# VM-miljö för Onboardify AB

## Syfte

Den här VM-miljön används för att testa Onboardify AB:s onboarding-automatisering i en kontrollerad labbmiljö.

Målet med miljön är att kunna testa hela flödet från nyanställd till aktivt konto, utan att påverka en riktig produktionsmiljö. I labbet ska vi kunna testa skapande av användare, OU-struktur, grupper, mappar, behörigheter och inläsning av data från JSON/CSV.

---

## Översikt

VM-miljön består av två delar:

1. **Windows Server**  
   Används som testserver för Active Directory, användarskapande, grupper, mappar och behörigheter.

2. **Ubuntu Server**  
   Används som **Twingate Connector** för att ge säker åtkomst till Windows Server via Twingate.

| Del | Beskrivning |
|---|---|
| Windows Server | Testserver för AD och onboarding-script |
| Ubuntu Server | Twingate Connector |
| Åtkomst till Windows Server | RDP via Twingate |
| Projekt | Onboardify AB |

---

## Servrar i miljön

| Server | Roll | Funktion |
|---|---|---|
| Windows Server | AD / testserver | Test av onboarding-script, användare, grupper, mappar och behörigheter |
| Ubuntu Server | Twingate Connector | Kopplar ihop Twingate med det lokala nätverket så att Windows Server kan nås säkert |

---

## Nätverk

VM-miljön körs i ett lokalt nätverk. Windows Server exponeras inte direkt mot internet.

| Enhet | Roll | IP-adress |
|---|---|---|
| Windows Server | AD / testserver | 192.168.50.210 |
| Ubuntu Server | Twingate Connector |
| Host-dator | Kör VM-miljön |

Ubuntu Server behöver åtkomst till samma nätverk som Windows Server för att Twingate ska kunna vidarebefordra trafik till rätt resurs.

---

## Twingate och säker fjärråtkomst

Vi använder Twingate för att kunna ansluta till Windows Server utan att öppna Remote Desktop direkt mot internet.

I vår lösning används en **Ubuntu Server som Twingate Connector**. Connectorn fungerar som länken mellan Twingates tjänst och vårt lokala labbnätverk där Windows Server finns.

Flödet ser ut så här:

```text
Användare med Twingate Client
        ↓
Twingate
        ↓
Ubuntu Server (Connector)
        ↓
Windows Server (RDP)
```

För hjälp med hur man installerar Twingate Client och ansluter via RDP, se [Twingate och RDP-åtkomst](twingate-rdp.md).