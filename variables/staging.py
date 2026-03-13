"""
staging.py – Robot Framework Variable File für die STAGING-Umgebung

Verwendung:
  robot --variablefile variables/staging.py tests/

Playwright TS Äquivalent:
  // playwright.config.ts mit mehreren Projects/Environments
  projects: [
    { name: 'staging', use: { baseURL: 'https://staging.example.com' } }
  ]

Das ist einer der großen Vorteile von RF Variable Files:
Dieselben Tests laufen gegen verschiedene Umgebungen,
ohne eine Zeile Test-Code zu ändern.
"""

# URL der Staging-Umgebung
BASE_URL = "https://staging.your-app.example.com"

# Staging ist oft langsamer als local
BROWSER = "chromium"
HEADLESS = True
TIMEOUT = "20s"

# Staging-Credentials – NIEMALS hardcoden!
# In echter CI: aus Environment Variables lesen
import os
ADMIN_USER = os.environ.get("STAGING_ADMIN_USER", "staging_admin")
ADMIN_PASS = os.environ.get("STAGING_ADMIN_PASS", "BITTE_ENV_VAR_SETZEN")
TEST_USER = os.environ.get("STAGING_TEST_USER", "staging_user")
TEST_PASS = os.environ.get("STAGING_TEST_PASS", "BITTE_ENV_VAR_SETZEN")
