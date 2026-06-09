# Tester

Den här mappen innehåller enkla testscript för Onboardify AB.

Syftet är att snabbt kunna kontrollera att våra PowerShell-moduler och funktioner fungerar innan vi kör hela onboarding-processen.

## Kör testscriptet

Kör från repo-roten:

```powershell
.\tests\Test-Onboardify.ps1
```

## Vad testas?

Testscriptet kontrollerar att:

- modulfilerna finns
- modulerna går att importera
- viktiga funktioner finns
- loggning fungerar
- JSON-data kan läsas in
- användardata kan valideras

## Viktigt

Testscriptet skapar inga användare i Active Directory.

Det används bara för att kontrollera att våra moduler fungerar.