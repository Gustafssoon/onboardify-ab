# Felaktig testdata

Den här mappen innehåller testdata som medvetet är felaktig.

Syftet är att kunna testa att Onboardify fångar fel på ett kontrollerat sätt vid validering, felhantering och loggning.

Testfilerna ska inte användas som korrekt kunddata. De är bara till för att visa att scriptet reagerar rätt när indata innehåller fel.

## Testfall

| Fil                           | Syfte                                                                 |
| ----------------------------- | --------------------------------------------------------------------- |
| `missing-required-field.json` | Testar att valideringen fångar när ett obligatoriskt fält saknas.     |
| `empty-username.json`         | Testar att valideringen fångar ett tomt eller felaktigt användarnamn. |
| `invalid-ou.json`             | Testar hur systemet hanterar en OU som inte finns.                    |
| `non-existing-group.json`     | Testar hur systemet hanterar en grupp som inte finns.                 |

## Förväntat resultat

När dessa filer används ska scriptet inte skapa användaren som vanligt.

I stället ska felet kunna visas i terminalen eller loggas så att IT kan felsöka vad som gick fel.