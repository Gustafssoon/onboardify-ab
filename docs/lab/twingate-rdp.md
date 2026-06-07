# Twingate och RDP-åtkomst

## Syfte

Vi använder Twingate för att alla på Onboardify ska kunna ansluta till vår Windows Server på ett säkrare sätt.

Windows Server används som testmiljö. Där testar vi bland annat Active Directory, användare, grupper, OU-struktur och onboarding-script.

I stället för att öppna RDP direkt mot internet använder vi Twingate. Det gör att bara godkända användare kan komma åt servern.

---

## Kort förklaring

Twingate fungerar som en säker väg in till vår VM-miljö.

I vår miljö finns en Ubuntu Server som kör Twingate Connector. Den gör att Twingate kan nå vår Windows Server i det lokala nätverket.

Förenklat:

```text
Din dator
↓
Twingate Client
↓
Ubuntu Server med Twingate Connector
↓
Windows Server
```

Som gruppmedlem behöver du inte konfigurera Ubuntu Servern. Du behöver bara installera Twingate Client och logga in.

---

## Det du behöver

För att kunna ansluta behöver du:

* Twingate Client installerad på din dator
* Ett konto som har fått åtkomst i Twingate
* Remote Desktop Connection på din dator
* Inloggningsuppgifter till Windows Server

---

## Steg för att ansluta

### 1. Installera Twingate Client

Installera Twingate Client på din dator.

Efter installationen loggar du in med det konto som har fått åtkomst till vår Twingate-miljö.

---

### 2. Kontrollera att Twingate är anslutet

När du är inloggad ska Twingate visa att du är ansluten.

Om Twingate inte är anslutet kommer du inte kunna nå Windows Server.

---

### 3. Öppna Remote Desktop

Öppna **Remote Desktop Connection** på din dator.

På Windows kan du söka efter:

```text
Remote Desktop Connection
```

eller:

```text
mstsc
```

---

### 4. Anslut till Windows Server

Skriv in serverns IP-adress:

```text
192.168.50.210
```

Klicka sedan på **Connect**.

---

### 5. Logga in på servern

Logga in med det konto du har fått för Windows Server.

Fråga Product Owner om användarnamn och lösenord.

---

### Om Twingate inte fungerar

Säg till i Discord så kontrollerar vi:

* att Ubuntu Server är igång
* att Twingate Connector är online

---

## Sammanfattning

För att ansluta till Windows Server gör du så här:

1. Starta Twingate Client
2. Logga in
3. Kontrollera att Twingate är anslutet
4. Öppna Remote Desktop
5. Anslut till `192.168.50.210`
6. Logga in på Windows Server
