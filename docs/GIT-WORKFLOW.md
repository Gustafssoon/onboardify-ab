# Git workflow för Onboardify AB

Den här guiden visar hur vi jobbar med Git, GitHub Issues, branches och Pull Requests i projektet Onboardify AB.

Alla ska följa samma arbetssätt så att projektet blir lätt att förstå, granska och fortsätta jobba med.


---

## Varje gång du ska börja jobba

Innan du skapar en ny branch ska du alltid se till att du har senaste versionen av `main`.

```bash
git switch main
git pull origin main
```

Efter det kan du skapa en branch för den Issue du ska jobba med.

---

## Arbetsflöde med Issues, branches och Pull Requests

För att hålla projektet tydligt jobbar vi alltid utifrån GitHub Issues.

Ingen börjar koda utan en Issue. Varje funktion, script, dokumentationsdel eller miljöändring ska ha en egen Issue i GitHub Projects.

När du börjar jobba med en Issue ska du:

1. Assigna dig själv på Issuen
2. Flytta kortet från `Todo` till `In Progress`
3. Skapa en ny branch från `main`
4. Göra ändringen i din branch
5. Testa att det fungerar
6. Pusha branchen till GitHub
7. Skapa en Pull Request
8. Vänta på granskning från Product Owner

Product Owner ansvarar för att granska, godkänna och merga Pull Requests.

Ingen annan än Product Owner får godkänna eller merga en Pull Request till `main`.

---

## Branch-namn

Varje branch ska kopplas till den Issue man jobbar med.

Branch-namnet ska visa vilken typ av arbete som görs och vad som läggs till eller ändras.

Format:

```text
typ/NamnPåDetSomGörs
```

Exempel:

```text
function/New-OnboardifyHomeFolder
```

Exempel från Issue:

```text
Skapa hemkatalog för ny användare #19
```

Branch:

```text
function/New-OnboardifyHomeFolder
```

Vi skriver branch-namn på engelska eftersom funktioner och script också oftast namnges på engelska.

---

## Branch-typer

Använd dessa branch-typer:

| Typ         | Används för                                        | Exempel                             |
| ----------- | -------------------------------------------------- | ----------------------------------- |
| `function/` | Ny PowerShell-funktion                             | `function/New-OnboardifyHomeFolder` |
| `script/`   | Nytt script eller större scriptändring             | `script/Start-OnboardifyProcess`    |
| `config/`   | Konfiguration, exempeldata eller kundinställningar | `config/Add-CustomerOuConfig`       |
| `docs/`     | README, dokumentation eller projekttext            | `docs/Update-GitWorkflow`           |
| `fix/`      | Bugfix eller mindre rättning                       | `fix/Fix-JsonValidation`            |
| `test/`     | Testdata eller testscript                          | `test/Add-OnboardingTestData`       |
| `lab/`      | VM-labb, nätverk eller testmiljö                   | `lab/Create-TwingateAccess`         |

---

## Git-lathund

### 1. Gå till main

```bash
git switch main
```

### 2. Hämta senaste versionen

```bash
git pull origin main
```

### 3. Skapa en ny branch

Byt ut branch-namnet mot det som passar din Issue.

```bash
git switch -c function/New-OnboardifyHomeFolder
```

### 4. Kontrollera vilken branch du är på

```bash
git branch
```

Den branch du är på visas med `*`.

Exempel:

```text
* function/New-OnboardifyHomeFolder
  main
```

---

## När du har gjort ändringar

### 1. Kontrollera ändrade filer

```bash
git status
```

### 2. Lägg till filerna

```bash
git add .
```

### 3. Skapa commit

Skriv gärna Issue-numret i commit-meddelandet.

```bash
git commit -m "Add New-OnboardifyHomeFolder function (#19)"
```

### 4. Pusha branchen till GitHub

```bash
git push -u origin function/New-OnboardifyHomeFolder
```

---

## Skapa Pull Request

När branchen är pushad ska du skapa en Pull Request i GitHub.

Pull Request ska gå:

```text
från din branch -> till main
```

Exempel:

```text
function/New-OnboardifyHomeFolder -> main
```

PR-titeln ska gärna innehålla Issue-numret.

Exempel:

```text
#19 Skapa hemkatalog för ny användare
```

I PR-beskrivningen ska du kort skriva:

```markdown
## Vad är gjort?

- Lagt till funktion för att skapa hemkatalog
- Kopplat funktionen till onboarding-flödet
- Lagt till enkel felhantering

## Testat

- Testat med exempelanvändare
- Kontrollerat att mappen skapas
- Kontrollerat att fel hanteras utan att scriptet kraschar

## Kopplad Issue

Closes #19
```

Använd `Closes #nummer` om PR:en är tänkt att stänga Issuen när den mergas.

---

## Regler för Pull Requests

* Man får inte merga sin egen kod
* Man får inte godkänna sin egen Pull Request
* Ingen annan än Product Owner får godkänna Pull Requests
* Ingen annan än Product Owner får merga till `main`
* Alla ändringar ska gå via Pull Request
* `main` ska alltid vara en fungerande version av projektet

---

## Kort arbetsflöde

```text
Issue skapas
→ Person assignar sig själv
→ Kort flyttas till In Progress
→ Branch skapas från main
→ Kod skrivs och testas
→ Branch pushas till GitHub
→ Pull Request skapas
→ Product Owner granskar
→ Product Owner godkänner och mergar
→ Issue stängs
```

---

## Exempel: Issue #19

Issue:

```text
Skapa hemkatalog för ny användare #19
```

Branch:

```bash
git switch main
git pull origin main
git switch -c function/New-OnboardifyHomeFolder
```

Efter ändringar:

```bash
git status
git add .
git commit -m "Add New-OnboardifyHomeFolder function (#19)"
git push -u origin function/New-OnboardifyHomeFolder
```

Skapa sedan en Pull Request i GitHub och koppla den till Issue #19.

Product Owner granskar, godkänner och mergar.