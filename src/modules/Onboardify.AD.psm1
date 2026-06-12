# Ser till att svenska tecken som å, ä och ö visas rätt i terminalen.
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# Rensar text så att den kan användas i SamAccountName.
# Används för korta AD-användarnamn utan punkter.
function Convert-ToAscii {
    [CmdletBinding()]
    param(
        # Texten som ska rensas.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    # Stoppar om texten är tom.
    if ([string]::IsNullOrWhiteSpace($Text)) {
        throw "Texten som ska rensas får inte vara tom."
    }

    # Gör texten till små bokstäver.
    $cleanText = $Text.ToLower().Trim()

    # Byter svenska tecken och vanliga specialtecken.
    $replacements = @{
        'å' = 'a'
        'ä' = 'a'
        'ö' = 'o'
        'é' = 'e'
        'è' = 'e'
        'ê' = 'e'
        'ü' = 'u'
        'û' = 'u'
    }

    # Ersätter tecknen ovan.
    foreach ($key in $replacements.Keys) {
        $cleanText = $cleanText.Replace($key, $replacements[$key])
    }

    # Tar bort allt som inte är bokstäver eller siffror.
    $cleanText = $cleanText -replace '[^a-z0-9]', ''

    # Stoppar om allt försvann vid rensning.
    if ([string]::IsNullOrWhiteSpace($cleanText)) {
        throw "Texten blev tom efter rensning av specialtecken."
    }

    return $cleanText
}

# Skapar nästa lediga SamAccountName.
# Format: tre första bokstäverna i förnamn + första bokstaven i efternamn + löpnummer.
function Get-NextSamAccountName {
    [CmdletBinding()]
    param(
        # Förnamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FirstName,

        # Efternamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LastName
    )

    # Kontrollerar att AD-modulen finns.
    if (-not (Get-Command Get-ADUser -ErrorAction SilentlyContinue)) {
        throw "Active Directory-modulen är inte installerad."
    }

    # Rensar förnamn och efternamn för AD-användarnamn.
    $firstNameClean = Convert-ToAscii -Text $FirstName
    $lastNameClean  = Convert-ToAscii -Text $LastName

    # Hämtar max tre första tecken från förnamnet.
    $firstPart = if ($firstNameClean.Length -ge 3) {
        $firstNameClean.Substring(0, 3)
    }
    else {
        $firstNameClean
    }

    # Hämtar första tecknet från efternamnet.
    $lastPart = $lastNameClean.Substring(0, 1)

    # Bygger prefixet, till exempel gaba eller asaa.
    $prefix = ($firstPart + $lastPart).ToLower()

    # Stoppar om prefixet inte gick att skapa.
    if ([string]::IsNullOrWhiteSpace($prefix)) {
        throw "Kunde inte skapa prefix för SamAccountName."
    }

    # Hämtar befintliga användare som börjar med samma prefix.
    $existingUsers = Get-ADUser `
        -Filter "SamAccountName -like '$prefix*'" `
        -Properties SamAccountName `
        -ErrorAction Stop

    # Första användaren ska börja på 100.
    $highestNumber = 99

    # Skyddar prefixet innan regex används.
    $escapedPrefix = [regex]::Escape($prefix)

    # Letar efter högsta befintliga nummer.
    foreach ($existingUser in $existingUsers) {
        if ($existingUser.SamAccountName -match "^$escapedPrefix(\d+)$") {
            $number = [int]$matches[1]

            if ($number -gt $highestNumber) {
                $highestNumber = $number
            }
        }
    }

    # Returnerar nästa lediga användarnamn.
    return "$prefix$($highestNumber + 1)"
}

# Hämtar vilken e-postdomän som ska användas.
function Get-OnboardifyEmailDomain {
    [CmdletBinding()]
    param(
        # Hela användarobjektet från JSON/CSV.
        [Parameter(Mandatory = $true)]
        [PSObject]$User,

        # Standarddomän om inget annat finns.
        [string]$DefaultDomain = "exempel.com"
    )

    # Använder emailDomain om det finns.
    if ($User.PSObject.Properties.Name -contains "emailDomain") {
        if (-not [string]::IsNullOrWhiteSpace($User.emailDomain)) {
            return $User.emailDomain.Trim().TrimStart("@").ToLower()
        }
    }

    # Hämtar domänen från email om email redan finns.
    if ($User.PSObject.Properties.Name -contains "email") {
        if (-not [string]::IsNullOrWhiteSpace($User.email) -and $User.email -match "@(.+)$") {
            return $matches[1].Trim().ToLower()
        }
    }

    # Använder standarddomän om inget annat finns.
    return $DefaultDomain.Trim().TrimStart("@").ToLower()
}

# Skapar nästa lediga e-postadress och UPN.
# Format: förnamn.efternamn@domän.
function Get-NextEmailAddress {
    [CmdletBinding()]
    param(
        # Förnamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FirstName,

        # Efternamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LastName,

        # Domän som ska användas efter @.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Domain
    )

    # Kontrollerar att AD-modulen finns.
    if (-not (Get-Command Get-ADUser -ErrorAction SilentlyContinue)) {
        throw "Active Directory-modulen är inte installerad."
    }

    # Rensar domänen från eventuellt @.
    $domainClean = $Domain.Trim().TrimStart("@").ToLower()

    # Enkel kontroll av domänformat.
    if ($domainClean -notmatch '^[a-z0-9.-]+$') {
        throw "Ogiltig e-postdomän: $domainClean"
    }

    # Rensar namn för e-post.
    # Exempel: Gabriel Andersson Svensson blir gabriel.andersson.svensson.
    $firstNameClean = Convert-ToEmailNamePart -Text $FirstName
    $lastNameClean  = Convert-ToEmailNamePart -Text $LastName

    # Bygger lokal del av e-postadressen.
    $localBase = "$firstNameClean.$lastNameClean"

    # Tar bort dubbla punkter och punkt i början/slutet.
    $localBase = ($localBase -replace '\.+', '.').Trim('.')

    # Testar först utan siffra, sedan med löpnummer.
    for ($counter = 0; $counter -le 999; $counter++) {
        $localPart = if ($counter -eq 0) {
            $localBase
        }
        else {
            "$localBase$counter"
        }

        # Skapar kandidat för e-post och UPN.
        $candidate = "$localPart@$domainClean"

        # Kontrollerar om adressen redan används.
        $existingUser = Get-ADUser `
            -Filter "UserPrincipalName -eq '$candidate' -or EmailAddress -eq '$candidate'" `
            -Properties UserPrincipalName, EmailAddress `
            -ErrorAction Stop

        # Returnerar adressen om den är ledig.
        if (-not $existingUser) {
            return $candidate
        }
    }

    throw "Kunde inte skapa en ledig e-postadress för $FirstName $LastName."
}

# Rensar text så att den kan användas i e-postadresser.
# Mellanslag och bindestreck görs om till punkter.
function Convert-ToEmailNamePart {
    [CmdletBinding()]
    param(
        # Texten som ska rensas för e-post.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    # Stoppar om texten är tom.
    if ([string]::IsNullOrWhiteSpace($Text)) {
        throw "Texten som ska användas i e-post får inte vara tom."
    }

    # Gör texten till små bokstäver.
    $cleanText = $Text.ToLower().Trim()

    # Byter svenska tecken och vanliga specialtecken.
    $replacements = @{
        'å' = 'a'
        'ä' = 'a'
        'ö' = 'o'
        'é' = 'e'
        'è' = 'e'
        'ê' = 'e'
        'ü' = 'u'
        'û' = 'u'
    }

    # Ersätter tecknen ovan.
    foreach ($key in $replacements.Keys) {
        $cleanText = $cleanText.Replace($key, $replacements[$key])
    }

    # Gör om specialtecken, mellanslag och bindestreck till punkt.
    $cleanText = $cleanText -replace '[^a-z0-9]+', '.'

    # Tar bort dubbla punkter.
    $cleanText = $cleanText -replace '\.+', '.'

    # Tar bort punkt i början och slutet.
    $cleanText = $cleanText.Trim('.')

    # Stoppar om allt försvann vid rensning.
    if ([string]::IsNullOrWhiteSpace($cleanText)) {
        throw "Texten blev tom efter rensning för e-post."
    }

    return $cleanText
}

# Rensar text så att den kan användas i e-postadresser.
function Convert-ToEmailNamePart {
    [CmdletBinding()]
    param(
        # Texten som ska rensas för e-post.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Text
    )

    # Stoppar funktionen om texten bara består av tomma tecken.
    if ([string]::IsNullOrWhiteSpace($Text)) {
        throw "Texten som ska användas i e-post får inte vara tom."
    }

    # Gör texten till små bokstäver och tar bort mellanslag i början/slutet.
    $cleanText = $Text.ToLower().Trim()

    # Byter ut svenska tecken och några vanliga specialtecken mot enklare bokstäver.
    $replacements = @{
        'å' = 'a'
        'ä' = 'a'
        'ö' = 'o'
        'é' = 'e'
        'è' = 'e'
        'ê' = 'e'
        'ü' = 'u'
        'û' = 'u'
    }

    # Loopar igenom alla tecken som ska ersättas.
    foreach ($key in $replacements.Keys) {
        $cleanText = $cleanText.Replace($key, $replacements[$key])
    }

    # Gör om allt som inte är bokstäver eller siffror till punkt.
    # Detta gör att mellanslag, bindestreck och liknande blir avgränsare i e-postadressen.
    $cleanText = $cleanText -replace '[^a-z0-9]+', '.'

    # Tar bort dubbla punkter om flera specialtecken råkar hamna efter varandra.
    $cleanText = $cleanText -replace '\.+', '.'

    # Tar bort punkt i början eller slutet.
    $cleanText = $cleanText.Trim('.')

    # Stoppar funktionen om texten blev tom efter rensning.
    if ([string]::IsNullOrWhiteSpace($cleanText)) {
        throw "Texten blev tom efter rensning för e-post."
    }

    return $cleanText
}

# Skapar nästa lediga SamAccountName.
# Formatet blir de tre första bokstäverna i förnamnet + första bokstaven i efternamnet + löpnummer.
function Get-NextSamAccountName {
    [CmdletBinding()]
    param(
        # Förnamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FirstName,

        # Efternamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LastName
    )

    # Kontrollerar att AD-kommandot Get-ADUser finns tillgängligt.
    # Om AD-modulen saknas ska vi stoppa direkt med ett tydligt fel.
    if (-not (Get-Command Get-ADUser -ErrorAction SilentlyContinue)) {
        throw "Active Directory-modulen är inte installerad."
    }

    # Rensar förnamn och efternamn från svenska tecken och specialtecken.
    $firstNameClean = Convert-ToAscii -Text $FirstName
    $lastNameClean  = Convert-ToAscii -Text $LastName

    # Hämtar max tre första tecken från förnamnet.
    # Om förnamnet är kortare än tre tecken används hela förnamnet.
    $firstPart = if ($firstNameClean.Length -ge 3) {
        $firstNameClean.Substring(0, 3)
    }
    else {
        $firstNameClean
    }

    # Hämtar första tecknet från efternamnet.
    $lastPart = $lastNameClean.Substring(0, 1)

    # Bygger prefixet som används före siffrorna.
    $prefix = ($firstPart + $lastPart).ToLower()

    # Extra kontroll så att vi inte råkar söka eller skapa ett tomt användarnamn.
    if ([string]::IsNullOrWhiteSpace($prefix)) {
        throw "Kunde inte skapa prefix för SamAccountName."
    }

    # Hämtar alla befintliga AD-användare som börjar med samma prefix.
    # -ErrorAction Stop gör att AD-fel fångas av try/catch i huvudfunktionen.
    $existingUsers = Get-ADUser `
        -Filter "SamAccountName -like '$prefix*'" `
        -Properties SamAccountName `
        -ErrorAction Stop

    # Startar på 99 eftersom första nya användaren ska bli 100.
    $highestNumber = 99

    # Skyddar prefixet innan det används i regex-matchning.
    $escapedPrefix = [regex]::Escape($prefix)

    # Går igenom befintliga användare och letar efter högsta numret.
    foreach ($existingUser in $existingUsers) {

        # Matchar bara namn som följer formatet prefix + siffror.
        # Exempel: ands100, ands101.
        if ($existingUser.SamAccountName -match "^$escapedPrefix(\d+)$") {
            $number = [int]$matches[1]

            if ($number -gt $highestNumber) {
                $highestNumber = $number
            }
        }
    }

    # Returnerar nästa lediga användarnamn.
    return "$prefix$($highestNumber + 1)"
}

# Hämtar vilken e-postdomän som ska användas för användaren.
function Get-OnboardifyEmailDomain {
    [CmdletBinding()]
    param(
        # Hela användarobjektet från JSON/CSV.
        [Parameter(Mandatory = $true)]
        [PSObject]$User,

        # Standarddomän om ingen annan domän finns angiven.
        [string]$DefaultDomain = "exempel.com"
    )

    # Använder emailDomain om det finns i användardatan.
    if ($User.PSObject.Properties.Name -contains "emailDomain") {
        if (-not [string]::IsNullOrWhiteSpace($User.emailDomain)) {
            return $User.emailDomain.Trim().TrimStart("@").ToLower()
        }
    }

    # Om email redan finns kan vi återanvända domänen från den adressen.
    if ($User.PSObject.Properties.Name -contains "email") {
        if (-not [string]::IsNullOrWhiteSpace($User.email) -and $User.email -match "@(.+)$") {
            return $matches[1].Trim().ToLower()
        }
    }

    # Om ingen domän hittas används standarddomänen.
    return $DefaultDomain.Trim().TrimStart("@").ToLower()
}

# Skapar nästa lediga e-postadress och UPN.
# Formatet blir förnamn.efternamn@domän.
function Get-NextEmailAddress {
    [CmdletBinding()]
    param(
        # Förnamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FirstName,

        # Efternamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LastName,

        # Domän som ska användas efter @.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Domain
    )

    # Kontrollerar att AD-kommandot Get-ADUser finns tillgängligt.
    if (-not (Get-Command Get-ADUser -ErrorAction SilentlyContinue)) {
        throw "Active Directory-modulen är inte installerad."
    }

    # Rensar domänen från eventuellt @ i början.
    $domainClean = $Domain.Trim().TrimStart("@").ToLower()

    # Enkel kontroll så att domänen inte innehåller konstiga tecken.
    if ($domainClean -notmatch '^[a-z0-9.-]+$') {
        throw "Ogiltig e-postdomän: $domainClean"
    }

    # Rensar förnamn och efternamn innan de används i e-postadressen.
    # Här används en separat funktion för e-post så att mellanslag och bindestreck blir punkter.
    # Exempel: Anders Andersson Svensson blir anders.andersson.svensson
    $firstNameClean = Convert-ToEmailNamePart -Text $FirstName
    $lastNameClean  = Convert-ToEmailNamePart -Text $LastName

    # Bygger grunden för e-postadressen.
    # Om efternamnet innehåller flera delar behålls dessa med punkt mellan.
    $localBase = "$firstNameClean.$lastNameClean"

    # Tar bort eventuella dubbla punkter och punkt i början/slutet.
    $localBase = ($localBase -replace '\.+', '.').Trim('.')

    # Testar först utan siffra, sedan med löpnummer om adressen redan finns.
    for ($counter = 0; $counter -le 999; $counter++) {

        # Första försöket blir förnamn.efternamn.
        # Nästa försök blir förnamn.efternamn1, förnamn.efternamn2 och så vidare.
        $localPart = if ($counter -eq 0) {
            $localBase
        }
        else {
            "$localBase$counter"
        }

        # Skapar kandidat för e-postadress och UPN.
        $candidate = "$localPart@$domainClean"

        # Kontrollerar om adressen redan används som UPN eller e-post i AD.
        $existingUser = Get-ADUser `
            -Filter "UserPrincipalName -eq '$candidate' -or EmailAddress -eq '$candidate'" `
            -Properties UserPrincipalName, EmailAddress `
            -ErrorAction Stop

        # Om ingen användare hittas är adressen ledig.
        if (-not $existingUser) {
            return $candidate
        }
    }

    # Om alla försök upp till 999 är upptagna stoppas scriptet.
    throw "Kunde inte skapa en ledig e-postadress för $FirstName $LastName."
}

# Kontrollerar om en användare redan finns i AD baserat på e-post eller UPN.
# Detta minskar risken att samma person skapas flera gånger.
function Test-OnboardifyExistingUser {
    [CmdletBinding()]
    param(
        # E-postadress som ska kontrolleras.
        [Parameter(Mandatory = $true)]
        [string]$EmailAddress,

        # UserPrincipalName som ska kontrolleras.
        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName
    )

    # Söker efter befintlig användare med samma e-post eller UPN.
    $existingUser = Get-ADUser `
        -Filter "UserPrincipalName -eq '$UserPrincipalName' -or EmailAddress -eq '$EmailAddress'" `
        -Properties UserPrincipalName, EmailAddress, SamAccountName `
        -ErrorAction Stop

    return $existingUser
}

# Kontrollerar om användare redan finns via e-post eller UPN.
function Test-OnboardifyExistingUser {
    [CmdletBinding()]
    param(
        # E-postadress som ska kontrolleras.
        [Parameter(Mandatory = $true)]
        [string]$EmailAddress,

        # UPN som ska kontrolleras.
        [Parameter(Mandatory = $true)]
        [string]$UserPrincipalName
    )

    # Söker efter befintlig användare med samma e-post eller UPN.
    $existingUser = Get-ADUser `
        -Filter "UserPrincipalName -eq '$UserPrincipalName' -or EmailAddress -eq '$EmailAddress'" `
        -Properties UserPrincipalName, EmailAddress, SamAccountName `
        -ErrorAction Stop

    return $existingUser
}

# Kontrollerar om samma person redan finns i samma OU.
# Används för att kunna köra samma datafil igen utan att skapa dubbletter.
function Test-OnboardifyExistingPerson {
    [CmdletBinding()]
    param(
        # Förnamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$FirstName,

        # Efternamn från användardatan.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$LastName,

        # OU där användaren ska skapas.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$OrganizationUnit
    )

    # Samma namn som används som Name/CN när AD-kontot skapas.
    $displayName = "$FirstName $LastName"

    # Söker efter samma namn i samma OU.
    $existingUser = Get-ADUser `
        -Filter "Name -eq '$displayName'" `
        -SearchBase $OrganizationUnit `
        -Properties SamAccountName, UserPrincipalName, EmailAddress `
        -ErrorAction Stop

    return $existingUser
}

# Skapar en ny AD-användare från importerad användardata.
function New-OnboardifyADUser {
    [CmdletBinding()]
    param (
        # Användarobjekt från JSON/CSV.
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [PSObject]$User
    )

    # Används i catch om något går fel tidigt.
    $username = $null
    $emailAddress = $null
    $userPrincipalName = $null

    try {
        # Kontrollerar obligatoriska fält.
        if ([string]::IsNullOrWhiteSpace($User.firstName)) {
            throw "firstName saknas i användardatan."
        }

        if ([string]::IsNullOrWhiteSpace($User.lastName)) {
            throw "lastName saknas i användardatan."
        }

        if ([string]::IsNullOrWhiteSpace($User.organizationUnit)) {
            throw "organizationUnit saknas i användardatan."
        }

        # Kontrollerar om samma person redan finns i samma OU.
        # Om användaren finns skapas inget nytt konto.
        $existingPerson = Test-OnboardifyExistingPerson `
            -FirstName $User.firstName `
            -LastName $User.lastName `
            -OrganizationUnit $User.organizationUnit

        if ($existingPerson) {
            Write-Host "Användaren finns redan i AD som $($existingPerson.SamAccountName)." -ForegroundColor Yellow

            # Returnerar befintligt användarnamn till huvudscriptet.
            return $existingPerson.SamAccountName
        }

        # Använder e-post från indata om den finns.
        if ($User.PSObject.Properties.Name -contains "email" -and -not [string]::IsNullOrWhiteSpace($User.email)) {
            $emailAddress = $User.email.Trim().ToLower()
        }
        else {
            # Skapar e-post automatiskt om den saknas.
            $emailDomain = Get-OnboardifyEmailDomain -User $User

            $emailAddress = Get-NextEmailAddress `
                -FirstName $User.firstName `
                -LastName $User.lastName `
                -Domain $emailDomain
        }

        # Använder UPN från indata om den finns, annars samma som e-post.
        if ($User.PSObject.Properties.Name -contains "userPrincipalName" -and -not [string]::IsNullOrWhiteSpace($User.userPrincipalName)) {
            $userPrincipalName = $User.userPrincipalName.Trim().ToLower()
        }
        else {
            $userPrincipalName = $emailAddress
        }

        # Kontrollerar om e-post eller UPN redan används.
        $existingUser = Test-OnboardifyExistingUser `
            -EmailAddress $emailAddress `
            -UserPrincipalName $userPrincipalName

        if ($existingUser) {
            Write-Host "Användaren finns redan i AD som $($existingUser.SamAccountName)." -ForegroundColor Yellow

            # Returnerar befintligt användarnamn till huvudscriptet.
            return $existingUser.SamAccountName
        }

        # Skapar nästa lediga SamAccountName.
        $username = Get-NextSamAccountName `
            -FirstName $User.firstName `
            -LastName $User.lastName

        # Skapar ett slumpmässigt lösenord.
        $password = [System.Web.Security.Membership]::GeneratePassword(12, 2)

        # Attribut som skickas till New-ADUser.
        $userAttributes = @{
            SamAccountName    = $username
            UserPrincipalName = $userPrincipalName
            GivenName         = $User.firstName
            Surname           = $User.lastName
            DisplayName       = "$($User.firstName) $($User.lastName)"
            EmailAddress      = $emailAddress
            Path              = $User.organizationUnit
            Name              = "$($User.firstName) $($User.lastName)"
        }

        # Skapar användaren i AD.
        New-ADUser @userAttributes `
            -AccountPassword (ConvertTo-SecureString $password -AsPlainText -Force) `
            -Enabled $true `
            -ErrorAction Stop

        # Lägger användaren i grupper efter att kontot skapats.
        foreach ($group in @($User.groups)) {
            Add-ADGroupMember `
                -Identity $group `
                -Members $username `
                -ErrorAction Stop
        }

        # Visar resultat i terminalen.
        Write-Host "Användaren $username har skapats i AD." -ForegroundColor Green
        Write-Host "E-post/UPN: $emailAddress" -ForegroundColor Green
        Write-Host "Lösenord: $password" -ForegroundColor Green

        # Returnerar användarnamnet till huvudscriptet.
        return $username
    }
    catch {
        # Visar tydligt fel om skapandet misslyckas.
        $displayUsername = if ($username) { $username } else { "okänt användarnamn" }

        Write-Host "Fel vid skapande av användaren ${displayUsername}: $($_.Exception.Message)" -ForegroundColor Red
        throw
    }
}