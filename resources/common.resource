# =============================================================================
# common.resource – Geteilte Browser-Infrastruktur
# =============================================================================
#
# Entspricht in Playwright TS: playwright.config.ts + fixtures
#
# Playwright TS:
#   export default defineConfig({
#     use: {
#       baseURL: 'http://localhost:5000',
#       headless: true,
#       viewport: { width: 1280, height: 720 },
#     }
#   })
#
# In RF werden Konfigurationswerte als Variables definiert und
# können per CLI überschrieben werden:
#   robot --variable HEADLESS:False tests/      ← Browser anzeigen
#   robot --variable BASE_URL:http://staging    ← andere Umgebung
# =============================================================================

*** Settings ***
Library    Browser


*** Variables ***
# Diese Werte können per CLI überschrieben werden:
# robot --variable BASE_URL:http://staging.example.com tests/
${BASE_URL}     http://localhost:5000
${BROWSER}      chromium
${HEADLESS}     ${True}
${TIMEOUT}      10s
${VIEWPORT_W}   ${1280}
${VIEWPORT_H}   ${720}


*** Keywords ***
Browser Öffnen
    # Playwright TS:
    #   const browser = await chromium.launch({ headless: true })
    #   const context = await browser.newContext({ viewport: { width: 1280, height: 720 } })
    #   const page = await context.newPage()
    #   await page.goto('http://localhost:5000')
    #
    # Browser Library verwaltet browser/context/page intern.
    # New Browser → New Context → New Page = das Drei-Ebenen-Modell wie in Playwright
    New Browser    ${BROWSER}    headless=${HEADLESS}
    New Context
    ...    viewport={'width': ${VIEWPORT_W}, 'height': ${VIEWPORT_H}}
    ...    acceptDownloads=False
    New Page    ${BASE_URL}
    Set Browser Timeout    ${TIMEOUT}


Zur Login-Seite Navigieren
    # Playwright: await page.goto('/login')
    Go To    ${BASE_URL}/login
    Wait For Elements State    [data-testid="login-button"]    visible
