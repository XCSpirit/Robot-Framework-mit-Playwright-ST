"""
dev.py – Robot Framework Variable File für die DEV-Umgebung

Verwendung:
  robot --variablefile variables/dev.py tests/

Oder in common.resource als Default-Werte (bereits eingetragen).

Playwright TS Äquivalent:
  // playwright.config.ts
  export default defineConfig({
    use: {
      baseURL: 'http://localhost:5000',
    }
  })

  // .env
  BASE_URL=http://localhost:5000
  ADMIN_USER=admin
"""

# URL der Demo-App
BASE_URL = "http://localhost:5000"

# Browser-Einstellungen
BROWSER = "chromium"
HEADLESS = True        # False → Browser wird sichtbar angezeigt (gut für Demos!)
TIMEOUT = "10s"

# Test-Credentials (niemals echte Credentials committen!)
ADMIN_USER = "admin"
ADMIN_PASS = "password123"
TEST_USER = "user1"
TEST_PASS = "testpass"
