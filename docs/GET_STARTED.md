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