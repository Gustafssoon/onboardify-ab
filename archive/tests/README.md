# Tester

Den här mappen innehåller enkla testscript för Onboardify AB.

Syftet är att snabbt kunna kontrollera att projektets PowerShell-moduler och grundfunktioner fungerar innan hela onboarding-processen körs.

Testerna är främst tänkta som enkla kontrolltester/smoke tests under utveckling.

---

## Kör testerna

Kör från repo-roten:

```powershell
.\tests\Test-Onboardify.ps1
```

---

## Vad testas?

Testscriptet kontrollerar bland annat att:

* modulfilerna finns
* modulerna går att importera
* viktiga funktioner finns tillgängliga
* loggning fungerar
* JSON-data kan läsas in
* användardata kan valideras
* grundflödet fungerar utan att skapa användare i AD

---

## Vad testas inte?

Testscriptet gör inga skarpa ändringar i Active Directory.

Det skapar inte:

* AD-användare
* grupper
* gruppmedlemskap
* hemkataloger
* ändringar i OU-strukturen

Syftet är att kontrollera att koden är redo att köras vidare i DemoMode eller labbmiljö.

---

## Rekommenderat arbetssätt

Kör testerna efter ändringar i:

* `src/Start-Onboarding.ps1`
* `src/modules/`
* `config/customer.sample.json`
* valideringslogik
* importlogik
* loggning

Exempel:

```powershell
.\tests\Test-Onboardify.ps1
```

Om testerna passerar kan nästa steg vara att köra huvudscriptet i DemoMode:

```powershell
.\src\Start-Onboarding.ps1 -DataPath .\config\customer.sample.json -DemoMode
```

---

## Framtida förbättringar

Senare kan testerna byggas ut med till exempel:

* Pester-tester
* separata tester per modul
* testdata för både godkända och felaktiga användare
* kontroll av DemoMode
* bättre rapportering av testresultat

---

## Viktigt

Tester ska kunna köras utan att påverka Active Directory.

Om ett test i framtiden behöver göra skarpa ändringar ska det dokumenteras tydligt och helst ligga separat från de vanliga grundtesterna.