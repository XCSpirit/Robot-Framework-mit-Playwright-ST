# =============================================================================
# LEKTION 2: Login-Tests mit Setup & Teardown + Resource Files
# =============================================================================
#
# Neu in dieser Lektion:
# - Resource Files (= Page Object Pattern in RF)
# - Suite Setup / Suite Teardown  (= beforeAll / afterAll)
# - Test Setup / Test Teardown    (= beforeEach / afterEach)
# - Per-Test Teardown mit [Teardown]
# =============================================================================

*** Settings ***
# Resource-Dateien importieren – wie Page Objects in Playwright TS:
#   import { LoginPage } from './pages/LoginPage'
Resource    ../resources/common.resource
Resource    ../resources/login_page.resource
Resource    ../resources/dashboard_page.resource

# Suite Setup = beforeAll() – einmal vor allen Tests in dieser Datei
# Suite Teardown = afterAll() – einmal nach allen Tests
Suite Setup       Browser Öffnen
Suite Teardown    Close Browser

# Test Setup = beforeEach() – vor jedem einzelnen Test
# Wir navigieren vor jedem Test zur Login-Seite
Test Setup        Zur Login-Seite Navigieren


*** Test Cases ***
Erfolgreicher Login zeigt Dashboard
    # Keywords kommen aus login_page.resource (= Page Object)
    Mit Zugangsdaten Einloggen    admin    password123

    # Playwright: await expect(page.locator('[data-testid="welcome-message"]')).toBeVisible()
    Dashboard Zeigt Willkommen Für    Admin User

    # Per-Test Teardown – wird IMMER ausgeführt, auch bei Fehler
    # Playwright: afterEach(() => page.goto('/login'))
    [Teardown]    Zur Login-Seite Navigieren


Login Mit Falschem Passwort Zeigt Fehlermeldung
    Mit Zugangsdaten Einloggen    admin    falschespasswort

    # Playwright: await expect(page.locator('[data-testid="login-error"]')).toBeVisible()
    Login-Fehler Prüfen    Invalid credentials


Gesperrter Account Zeigt Gesperrte-Nachricht
    Mit Zugangsdaten Einloggen    locked    beliebigPasswort

    Login-Fehler Prüfen    locked


Leeres Username-Feld Zeigt Fehlermeldung
    # ${EMPTY} ist eine eingebaute RF Variable für einen leeren String
    Mit Zugangsdaten Einloggen    ${EMPTY}    einPasswort

    Login-Fehler Prüfen    required


Leeres Passwort-Feld Zeigt Fehlermeldung
    Mit Zugangsdaten Einloggen    admin    ${EMPTY}

    Login-Fehler Prüfen    required


Login Und Ausloggen Funktioniert
    Mit Zugangsdaten Einloggen    admin    password123
    Dashboard Zeigt Willkommen Für    Admin User

    # Ausloggen Keyword aus login_page.resource
    Ausloggen

    # Nach Ausloggen sollte Login-Button sichtbar sein
    Wait For Elements State    [data-testid="login-button"]    visible


user1 Kann Sich Auch Einloggen
    Mit Zugangsdaten Einloggen    user1    testpass
    Dashboard Zeigt Willkommen Für    Test User

    [Teardown]    Zur Login-Seite Navigieren
