# =============================================================================
# login_page.resource – Page Object Pattern in Robot Framework
# =============================================================================
#
# ┌─────────────────────────────────────────────────────────────────────────┐
# │  PLAYWRIGHT TS (Page Object)    │  ROBOT FRAMEWORK (Resource File)      │
# ├─────────────────────────────────────────────────────────────────────────┤
# │  export class LoginPage {       │  *** Settings ***                     │
# │    constructor(page: Page) {    │  Library    Browser                   │
# │      this.page = page           │                                       │
# │    }                            │  *** Variables ***                    │
# │                                 │  ${USERNAME_INPUT}  [data-testid=...] │
# │    usernameInput =              │                                       │
# │      '[data-testid=...]'        │  *** Keywords ***                     │
# │                                 │  Mit Zugangsdaten Einloggen               │
# │    async login(u, p) {          │      [Arguments]  ${u}  ${p}          │
# │      await page.fill(           │      Fill Text  ${USERNAME_INPUT}  ${u│
# │        this.usernameInput, u)   │      Fill Text  ${PASSWORD_INPUT}  ${p│
# │      await page.click(          │      Click  ${LOGIN_BUTTON}           │
# │        this.loginButton)        │                                       │
# │    }                            │                                       │
# │  }                              │                                       │
# └─────────────────────────────────────────────────────────────────────────┘
#
# Die "Klasse" wird zum Resource File.
# Die "Methoden" werden zu Keywords.
# Das "this.page" ist implizit – Browser Library verwaltet die Page.
# =============================================================================

*** Settings ***
Library    Browser
Resource   common.resource


*** Variables ***
# Selektoren als benannte Konstanten – genau wie in Playwright TS:
#   private usernameInput = '[data-testid="username-input"]'
# CSS-Selektor Syntax ist IDENTISCH zu Playwright!
${USERNAME_INPUT}     [data-testid="username-input"]
${PASSWORD_INPUT}     [data-testid="password-input"]
${LOGIN_BUTTON}       [data-testid="login-button"]
${LOGIN_ERROR}        [data-testid="login-error"]
${LOGOUT_LINK}        [data-testid="logout-link"]


*** Keywords ***
Mit Zugangsdaten Einloggen
    # [Arguments] = Funktionsparameter
    # Playwright TS: async login(username: string, password: string)
    [Arguments]    ${username}    ${password}

    # Playwright: await page.fill('[data-testid="username-input"]', username)
    Fill Text    ${USERNAME_INPUT}    ${username}

    # Playwright: await page.fill('[data-testid="password-input"]', password)
    Fill Text    ${PASSWORD_INPUT}    ${password}

    # Playwright: await page.click('[data-testid="login-button"]')
    Click    ${LOGIN_BUTTON}


Als Admin Einloggen
    # Komposition: dieses Keyword ruft andere Keywords auf
    # Playwright TS: async loginAsAdmin() { await this.goto(); await this.login('admin', '...') }
    Zur Login-Seite Navigieren
    Mit Zugangsdaten Einloggen    admin    password123


Ausloggen
    # Playwright: await page.click('[data-testid="logout-link"]')
    Click    ${LOGOUT_LINK}
    Wait For Elements State    ${LOGIN_BUTTON}    visible


Login-Fehler Prüfen
    [Arguments]    ${expected_text}
    # Playwright: await expect(page.locator('[data-testid="login-error"]')).toContainText('...')
    Wait For Elements State    ${LOGIN_ERROR}    visible
    Get Text    ${LOGIN_ERROR}    contains    ${expected_text}
