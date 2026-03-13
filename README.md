# Robot Framework + Playwright – Demo Projekt

Praxisbeispiel für Playwright-Entwickler die Robot Framework lernen.

---

## Voraussetzungen

- [Python 3.11+](https://www.python.org/downloads/)
- [Node.js 18+](https://nodejs.org/)

Tipp – schnelle Installation via Windows Terminal:
```
winget install Python.Python.3.12
winget install OpenJS.NodeJS.LTS
```

### VS Code Extension

**[RobotCode](https://marketplace.visualstudio.com/items?itemName=d-biehl.robotcode)** (`d-biehl.robotcode`) – empfohlene Extension für `.robot` Dateien:
- Keyword-Autovervollständigung
- Syntax-Highlighting
- Integrierter Test-Runner
- Go-to-Definition für Keywords und Resource Files

---

## Setup

```bash
npm run setup
```

> `rfbrowser init` lädt die Playwright Browser-Binaries (~300 MB) –
> entspricht `npx playwright install` aus der Playwright-TS-Welt.

---

## Projekt starten

**Terminal 1 – Demo-App:**
```bash
npm run app
```
App läuft auf http://localhost:5000 · Login: `admin / password123`

**Terminal 2 – Tests:**
```bash
# Alle Tests:
npm test

# Einzelner Test (Einstieg):
npm run test:one

# Mit sichtbarem Browser:
npm run test:visible

# Nur smoke Tests:
npm run test:smoke
```

---

## Lernpfad

| # | Datei | Konzept | Playwright-Äquivalent |
|---|-------|---------|----------------------|
| 1 | `app/app.py` | Was wir testen | Die Web-App selbst |
| 2 | `tests/01_hello_world.robot` | RF Syntax, erste Keywords | `test('name', async({page})=>{})` |
| 3 | `resources/common.resource` | Browser-Setup, Variablen | `playwright.config.ts` |
| 4 | `resources/login_page.resource` | **Page Object Pattern** | `class LoginPage {}` |
| 5 | `tests/02_login_tests.robot` | Setup/Teardown | `beforeAll/afterAll/beforeEach` |
| 6 | `tests/03_data_driven.robot` | `[Template]` | `test.each([...])` |
| 7 | `resources/todo_page.resource` | XPath, Keyword-Komposition | Weitere Page Objects |
| 8 | `tests/04_todo_crud.robot` | Vollständiger CRUD-Workflow | Multi-Step Tests |
| 9 | `libraries/CustomKeywords.py` | Python → RF Library | `import { MyHelper }` |
| 10 | `tests/05_python_integration.robot` | Python-Keywords nutzen | Custom Fixtures/Helpers |
| 11 | `variables/staging.py` | Umgebungs-Switching | `.env` / `process.env` |

---

## Nützliche Kommandos

```bash
# Gegen Staging:
robot --variablefile variables/staging.py --outputdir results tests/

# Parallel (pabot):
pabot --processes 4 --outputdir results tests/
```

---

## Projektstruktur

```
robot-playwright-demo/
├── app/                    # Flask Demo-Web-App
│   ├── app.py
│   ├── models.py
│   └── templates/
├── tests/                  # Robot Framework Test Suites
│   ├── 01_hello_world.robot
│   ├── 02_login_tests.robot
│   ├── 03_data_driven.robot
│   ├── 04_todo_crud.robot
│   └── 05_python_integration.robot
├── resources/              # Page Objects als .resource Files
│   ├── common.resource
│   ├── login_page.resource
│   ├── dashboard_page.resource
│   └── todo_page.resource
├── libraries/
│   └── CustomKeywords.py   # Python Library
├── variables/
│   ├── dev.py
│   └── staging.py
└── results/                # HTML-Reports (nach Testlauf)
```

---

## Keyword-Mapping

| Aktion | Playwright (TS) | Robot Framework |
|--------|----------------|-----------------|
| Seite öffnen | `await page.goto(url)` | `New Page    url` |
| Klicken | `await page.click(sel)` | `Click    selector` |
| Text eingeben | `await page.fill(sel, text)` | `Fill Text    sel    text` |
| Text prüfen | `expect(loc).toHaveText(t)` | `Get Text    sel    ==    text` |
| Sichtbarkeit | `expect(loc).toBeVisible()` | `Wait For Elements State    sel    visible` |
| Screenshot | `await page.screenshot()` | `Take Screenshot` |

---

## Test-Accounts

| Username | Passwort | Verhalten |
|----------|----------|-----------|
| `admin` | `password123` | Login → Dashboard |
| `user1` | `testpass` | Login → Dashboard |
| `locked` | *(beliebig)* | Immer gesperrt |

---

## Ressourcen

- [Robot Framework Docs](https://robotframework.org)
- [Browser Library Keywords](https://marketsquare.github.io/robotframework-browser/Browser.html)
- [RF Best Practices](https://github.com/robotframework/HowToWriteGoodTestCases)
