# =============================================================================
# LEKTION 3: Data-Driven Testing mit [Template]
# =============================================================================
#
# Playwright TS Äquivalent:
#   test.each([
#     ['admin', 'password123', 'Admin User'],
#     ['user1', 'testpass', 'Test User'],
#   ])('Login %s', async ({ page }, username, password, name) => { ... })
#
# In RF: [Template] Keyword + Datentabelle darunter
# RF generiert automatisch aussagekräftige Testnamen aus den Datenwerten!
# =============================================================================

*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/login_page.resource

Suite Setup       Browser Öffnen
Suite Teardown    Close Browser


*** Test Cases ***
# ─────────────────────────────────────────────────────────
# Jede Zeile unter [Template] = ein eigener Testlauf
# Testnamen werden automatisch generiert:
#   "Gültige Login Kombinationen -- admin, password123, Admin User"
#   "Gültige Login Kombinationen -- user1, testpass, Test User"
# ─────────────────────────────────────────────────────────
Gültige Login Kombinationen
    [Tags]    smoke    login    positive
    [Template]    Erfolgreichen Login Prüfen
    # username    password        expected_name
    admin         password123     Admin User
    user1         testpass        Test User


Ungültige Login Versuche
    [Tags]    login    negative
    [Template]    Fehlgeschlagenen Login Prüfen
    # username    password            expected_error_text
    admin         falschespasswort    Invalid credentials
    admin         ${EMPTY}            required
    ${EMPTY}      password123         required
    locked        beliebig            locked
    nichtExistent    password123       Invalid credentials


*** Keywords ***
# ─────────────────────────────────────────────────────────
# Keywords in dieser Datei = lokale Hilfsfunktionen
# (können auch in resource files ausgelagert werden)
#
# [Arguments] = Funktionsparameter
# Playwright TS: async function verifyLogin(username, password, expectedName) { ... }
# ─────────────────────────────────────────────────────────

Erfolgreichen Login Prüfen
    [Arguments]    ${username}    ${password}    ${expected_name}
    Zur Login-Seite Navigieren
    Mit Zugangsdaten Einloggen    ${username}    ${password}
    # Nach erfolgreichem Login sollten wir auf dem Dashboard sein
    Wait For Elements State    [data-testid="welcome-message"]    visible
    Get Text    [data-testid="welcome-message"]    contains    ${expected_name}
    # Aufräumen: zurück zur Login-Seite für den nächsten Testlauf
    Zur Login-Seite Navigieren


Fehlgeschlagenen Login Prüfen
    [Arguments]    ${username}    ${password}    ${expected_error}
    Zur Login-Seite Navigieren
    Mit Zugangsdaten Einloggen    ${username}    ${password}
    Login-Fehler Prüfen    ${expected_error}
