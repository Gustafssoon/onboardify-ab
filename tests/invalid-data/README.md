# Felaktig testdata

Den här mappen innehåller testdata som medvetet är felaktig.

Syftet är att kunna testa att Onboardify fångar fel på ett kontrollerat sätt vid validering, felhantering och loggning.

Testfilerna ska inte användas som korrekt kunddata. De är bara till för att visa att scriptet reagerar rätt när indata innehåller fel.

## Testfall

| Fil                           | Vad är fel?                                                  | Förväntat resultat                                                              |
| ----------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------- |
| `missing-required-field.json` | Ett obligatoriskt fält saknas helt, till exempel `username`. | Valideringen ska stoppa användaren eftersom nödvändig information saknas.       |
| `empty-username.json`         | Fältet `username` finns, men värdet är tomt.                 | Valideringen ska stoppa användaren eftersom användarnamnet inte är giltigt.     |
| `invalid-ou.json`             | Användaren pekar mot en OU som inte finns i AD-strukturen.   | Scriptet ska kunna visa eller logga att användaren inte kan placeras i rätt OU. |
| `non-existing-group.json`     | Användaren har en grupp som inte finns.                      | Scriptet ska kunna visa eller logga att gruppen inte kunde hittas.              |

## Förväntat resultat

När dessa filer används ska scriptet inte skapa användaren som vanligt.

I stället ska felet kunna visas i terminalen eller loggas så att IT kan felsöka vad som gick fel.

## Kommentar

Testfallen för saknat fält och tomt användarnamn testar grundläggande validering.

Testfallen för felaktig OU och grupp är mer kopplade till AD-miljön och kan användas när funktionerna för OU och grupphantering testas.