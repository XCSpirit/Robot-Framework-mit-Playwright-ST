# =============================================================================
# LEKTION 1: Dein erster Robot Framework Test
# =============================================================================
#
# Für Playwright-Entwickler: Diese Datei ist dein "Hello World".
# Lies jeden Kommentar – er erklärt, was du als Playwright-Dev bereits kennst.
#
# Nach diesem Test:
#   robot --outputdir results tests/01_hello_world.robot
# → Öffne results/report.html im Browser. Das ist der Grund, warum Kunden RF lieben.
# =============================================================================

*** Settings ***
# ─────────────────────────────────────────────────────────
# Settings = der "Import-Bereich" deiner Datei
# Playwright TS:  import { chromium } from '@playwright/test'
# RF:             Library    Browser
# ─────────────────────────────────────────────────────────
Library    Browser


*** Variables ***
# ─────────────────────────────────────────────────────────
# Variables = Konstanten / Konfigurationswerte
# Playwright TS:  const BASE_URL = 'http://localhost:5000'
# RF:             ${BASE_URL}    http://localhost:5000
#
# ${} = Scalar Variable (ein einzelner Wert)
# @{} = List Variable   (eine Liste)
# &{} = Dict Variable   (ein Dictionary)
# ─────────────────────────────────────────────────────────
${BASE_URL}    http://localhost:5000


*** Test Cases ***
# ─────────────────────────────────────────────────────────
# Test Cases = deine Tests
# Playwright TS:  test('name', async ({ page }) => { ... })
# RF:             Test Name
#                     Keyword    argument
#
# WICHTIG: Einrückung mit 4 Leerzeichen oder 1 Tab
# ─────────────────────────────────────────────────────────

App ist erreichbar und zeigt Login-Seite
    # Browser Library Keyword → Playwright: await page.goto('...')
    New Page    ${BASE_URL}/login

    # Playwright: await expect(page.locator('h1')).toHaveText('Login')
    Get Text    h1    ==    Login

    # Playwright: await expect(page.locator('[data-testid="login-button"]')).toBeVisible()
    Wait For Elements State    [data-testid="login-button"]    visible

    # Immer aufräumen!
    Close Browser


Login-Seite hat alle benötigten Felder
    New Page    ${BASE_URL}/login

    # Playwright: await expect(page.locator('[data-testid="username-input"]')).toBeVisible()
    Wait For Elements State    [data-testid="username-input"]    visible
    Wait For Elements State    [data-testid="password-input"]    visible
    Wait For Elements State    [data-testid="login-button"]      visible

    # Screenshot wird automatisch bei Fehler gemacht – bei Erfolg optional
    Take Screenshot    filename=${OUTPUT_DIR}/01_login_page.png

    Close Browser


Seitentitel ist korrekt
    New Page    ${BASE_URL}/login

    # Playwright: await expect(page).toHaveTitle(/Login/)
    ${title}=    Get Title
    Should Contain    ${title}    Login

    Close Browser
