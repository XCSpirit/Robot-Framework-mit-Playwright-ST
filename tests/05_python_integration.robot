# =============================================================================
# LEKTION 5: Python-Integration – Custom Keywords Library
# =============================================================================
#
# Playwright TS Äquivalent:
#   import { CustomHelpers } from './helpers/CustomHelpers'
#   const helpers = new CustomHelpers()
#   const todo = helpers.generateRandomTodo()
#
# In RF:
#   Library    ../libraries/CustomKeywords.py
#   ${todo}=   Generate Random Todo Text
#
# Eine Python-Klasse wird direkt zur RF Library.
# Methoden-Namen: snake_case (Python) → "Title Case With Spaces" (RF)
#
# Lies libraries/CustomKeywords.py um zu verstehen wie es funktioniert!
# =============================================================================

*** Settings ***
# Eigene Python-Library importieren
Library    ../libraries/CustomKeywords.py

Resource    ../resources/common.resource
Resource    ../resources/login_page.resource
Resource    ../resources/todo_page.resource

Suite Setup    Run Keywords
...            Browser Öffnen
...            AND    Als Admin Einloggen

Suite Teardown    Close Browser
Test Setup    Run Keywords
...           Alle Todos Zurücksetzen    admin
...           AND    Zur Todos-Seite Navigieren


*** Test Cases ***
Zufälliges Todo Erstellen Und Prüfen
    [Tags]    python    faker
    # ${var}= = Rückgabewert eines Keywords in Variable speichern
    # Playwright TS: const randomTodo = helpers.generateRandomTodo()
    ${random_todo}=    Generate Random Todo Text

    # RF: Wert der Variable in Logs ausgeben (erscheint im HTML-Report)
    Log    Generiertes Todo: ${random_todo}

    Todo Hinzufügen    ${random_todo}
    Todo Sollte Sichtbar Sein    ${random_todo}


Test Run ID Für CI-Nachverfolgung
    [Tags]    python    ci
    # Nützlich um Testläufe in CI-Logs zu korrelieren
    ${run_id}=    Generate Test Run ID
    # console=True → erscheint auch im Terminal (nicht nur im HTML-Report)
    Log    Test Run ID: ${run_id}    console=True


Generierte Benutzerdaten Verwenden
    [Tags]    python
    # Python kann Dictionaries zurückgeben
    # Playwright TS: const data = generateTestUserData(); console.log(data.username)
    ${user_data}=    Generate Test User Data

    # Dictionary-Werte zugreifen: ${dict}[key]
    Log    Generierter Name: ${user_data}[first_name] ${user_data}[last_name]
    Log    Generierte E-Mail: ${user_data}[email]

    # Wir können die Daten in Tests nutzen
    ${full_name}=    Set Variable    ${user_data}[first_name] ${user_data}[last_name]
    Should Not Be Empty    ${full_name}


Backend-State Per API Prüfen
    [Tags]    python    api
    # Python-Keywords können HTTP-Requests machen
    # → Backend-State verifizieren OHNE durch die UI zu klicken
    # Playwright TS: const count = await request.get('/api/todos').then(r => r.json()).then(d => d.length)
    Todo Hinzufügen    API-Prüfungs-Todo

    ${count}=    Get Todo Count Via API    admin
    Log    Anzahl Todos für admin (per API): ${count}

    # count ist ein Integer aus Python – RF kann damit rechnen
    Should Be True    ${count} > 0


App Ist Erreichbar (Polling)
    [Tags]    python    smoke
    # Nützlich in CI wenn die App etwas braucht um zu starten
    # Python-Keyword pollt den /api/health Endpunkt
    Wait For App To Start    http://localhost:5000
    Log    App ist erreichbar!
