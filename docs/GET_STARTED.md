# Kom igång med projektet

Den här guiden visar hur du klonar ner projektet och kommer igång första gången.

---

## Första gången du börjar jobba med projektet

### 1. Kontrollera att Git är installerat

Öppna terminalen och kör:

```bash
git --version
```

Om du får upp en version, till exempel `git version 2.x.x`, är Git installerat.

---

### 2. Ställ in ditt namn och din e-post i Git

Hoppa över detta steg om du redan har gjort det tidigare.

Detta behöver oftast bara göras en gång på datorn.

```bash
git config --global user.name "Ditt Namn"
git config --global user.email "din-mail@example.com"
```

Exempel:

```bash
git config --global user.name "Gabriel Gustafsson"
git config --global user.email "din-github-mail@example.com"
```

---

### 3. Gå till mappen där du vill spara projektet

Exempel:

```bash
cd Documents
```

På Windows kan det till exempel vara:

```bash
cd C:\Users\dittnamn\Documents
```

---

### 4. Klona projektet från GitHub

Kör:

```bash
git clone https://github.com/Gustafssoon/onboardify-ab.git
```

Detta laddar ner projektet till din dator.

---

### 5. Gå in i projektmappen

```bash
cd onboardify-ab
```

---

### 6. Öppna projektet i VS Code

Öppna VS Code och välj:

```text
File -> Open Folder -> onboardify-ab
```

---

## Nästa steg

När projektet är öppnat ska du läsa vår Git-guide innan du börjar jobba med en Issue.

Läs här:

```text
docs/GIT_WORKFLOW.md
```
---

# Använda Onboardify GUI

Denna guide beskriver det normala arbetsflödet där IT först skannar Active Directory, HR skapar onboardingunderlag och IT därefter genomför onboarding av användaren.

## 1. Starta GUI:t

1. Starta Onboardify GUI.
2. Verktyget begär administratörsbehörighet vid uppstart.
3. Klicka på **Ja** för att fortsätta.

## 2. Skanna Active Directory

1. Klicka på **Scan AD**.
2. Verktyget läser in Active Directory-strukturen.
3. En JSON-fil skapas som innehåller:

   * OU-struktur
   * Grupper
   * Avdelningar
   * Licenser

Denna fil används som underlag för onboarding-processen.

## 3. Skapa HR-underlag

1. Ladda in den skapade JSON-filen.

2. Fyll i:

   * Förnamn
   * Efternamn
   * Titel
   * Avdelning
   * Organisation eller skola
   * Licenser

3. Spara onboardingförfrågan.

Förfrågan sparas och kan senare hanteras av IT.

## 4. Granska onboardingförfrågan

IT laddar in väntande onboardingförfrågningar och granskar:

* Användarnamn
* Organisation
* OU
* Grupper
* Licenser
* Behörigheter

## 5. Kör onboarding

### Demo Mode

Används för testning och verifiering.

Ingen användare skapas i Active Directory.

### Skarpt läge

Skapar användaren i Active Directory.

Följande kan skapas:

* AD-användare
* Gruppmedlemskap
* Licenstilldelningar
* Hemkatalog
* Behörigheter

## 6. Kontrollera resultat

Efter körningen kan IT verifiera att:

* användaren har skapats
* rätt OU används
* rätt grupper har tilldelats
* licenser har lagts till
* loggar har skapats

## 7. Loggning

Alla körningar loggas och kan granskas i efterhand för felsökning och uppföljning.
