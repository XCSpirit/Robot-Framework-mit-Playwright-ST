"""
CustomKeywords.py – Custom Robot Framework Keyword Library

╔══════════════════════════════════════════════════════════════════╗
║  Playwright TypeScript (Helper Class)                            ║
║                                                                  ║
║  // helpers/CustomHelpers.ts                                     ║
║  export class CustomHelpers {                                    ║
║    generateRandomTodo(): string { return faker.lorem.words(3) }  ║
║    generateTestRunId(): string { return Date.now().toString() }  ║
║  }                                                               ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  Robot Framework (Python Library)                                ║
║                                                                  ║
║  # libraries/CustomKeywords.py                                   ║
║  class CustomKeywords:                                           ║
║      def generate_random_todo_text(self): ...                    ║
║      def generate_test_run_id(self): ...                         ║
║                                                                  ║
║  Verwendung in .robot:                                           ║
║      Library    ../libraries/CustomKeywords.py                   ║
║      ${todo}=   Generate Random Todo Text                        ║
╚══════════════════════════════════════════════════════════════════╝

WICHTIG: Methoden-Naming
  Python:         snake_case           generate_random_todo_text()
  Robot Framework: "Title Case Spaces"  Generate Random Todo Text

Jede public Methode (kein führendes _) wird automatisch ein RF Keyword.
"""

import datetime
import uuid
import time

try:
    import requests
    REQUESTS_AVAILABLE = True
except ImportError:
    REQUESTS_AVAILABLE = False

try:
    from faker import Faker
    _faker = Faker("de_DE")  # Deutsche Faker-Daten
    FAKER_AVAILABLE = True
except ImportError:
    _faker = None
    FAKER_AVAILABLE = False


class CustomKeywords:
    """
    Robot Framework Keyword Library für das Demo-Projekt.

    ROBOT_LIBRARY_SCOPE steuert den Lifecycle der Library-Instanz:
      'TEST'   → neue Instanz pro Test     (wie beforeEach in Playwright)
      'SUITE'  → eine Instanz pro .robot Datei
      'GLOBAL' → eine Instanz für den ganzen Testlauf

    In Playwright TS gibt es kein direktes Äquivalent –
    dort gibt es Fixtures mit verschiedenen Scopes.
    """

    ROBOT_LIBRARY_SCOPE = "TEST"
    ROBOT_LIBRARY_VERSION = "1.0.0"

    # ─────────────────────────────────────────────────────────────
    # Testdaten-Generierung
    # ─────────────────────────────────────────────────────────────

    def generate_random_todo_text(self):
        """
        Generiert einen realistischen Todo-Text.

        RF Keyword-Name:  Generate Random Todo Text
        Verwendung:       ${todo}=    Generate Random Todo Text

        Playwright TS Äquivalent:
          const todo = faker.lorem.sentence()
        """
        if FAKER_AVAILABLE:
            verben = ["Kaufen", "Anrufen", "Schreiben", "Lesen", "Prüfen",
                      "Erledigen", "Vorbereiten", "Senden", "Aktualisieren"]
            objekte = ["den Bericht", "das Dokument", "die E-Mail",
                       "den Kollegen", "das Meeting", "die Präsentation",
                       "den Code", "den Test", "die Anforderungen"]
            verb = _faker.random_element(verben)
            objekt = _faker.random_element(objekte)
            return f"{verb}: {objekt}"
        else:
            # Fallback ohne Faker
            return f"Todo-{uuid.uuid4().hex[:6].upper()}"

    def generate_test_user_data(self):
        """
        Gibt ein Dictionary mit generierten Benutzerdaten zurück.

        RF Keyword-Name:  Generate Test User Data
        Verwendung:
          ${data}=    Generate Test User Data
          Log         ${data}[first_name] ${data}[last_name]

        Dictionary-Werte in RF mit ${dict}[key] zugreifen –
        wie data.firstName in Playwright TS.
        """
        if FAKER_AVAILABLE:
            return {
                "username": _faker.user_name(),
                "email": _faker.email(),
                "first_name": _faker.first_name(),
                "last_name": _faker.last_name(),
                "company": _faker.company(),
            }
        else:
            uid = uuid.uuid4().hex[:8]
            return {
                "username": f"user_{uid}",
                "email": f"user_{uid}@example.com",
                "first_name": "Test",
                "last_name": f"User{uid}",
                "company": "Test GmbH",
            }

    def generate_test_run_id(self):
        """
        Generiert eine eindeutige Test-Run-ID für CI-Nachverfolgung.

        RF Keyword-Name:  Generate Test Run ID
        Verwendung:       ${run_id}=    Generate Test Run ID
                          Log           Run-ID: ${run_id}    console=True

        Playwright TS Äquivalent:
          const runId = `RUN_${Date.now()}_${crypto.randomUUID().slice(0, 8)}`
        """
        timestamp = datetime.datetime.now().strftime("%Y%m%d_%H%M%S")
        short_uuid = str(uuid.uuid4()).split("-")[0].upper()
        return f"RUN_{timestamp}_{short_uuid}"

    # ─────────────────────────────────────────────────────────────
    # API / Backend-Interaktion
    # ─────────────────────────────────────────────────────────────

    def get_todo_count_via_api(self, username, base_url="http://localhost:5000"):
        """
        Prüft Backend-State per HTTP-Request – OHNE durch die UI zu gehen.

        RF Keyword-Name:  Get Todo Count Via API
        Verwendung:
          ${count}=    Get Todo Count Via API    admin
          Should Be True    ${count} > 0

        Playwright TS Äquivalent:
          const res = await request.get('/api/todos/admin')
          const todos = await res.json()
          expect(todos.length).toBeGreaterThan(0)

        Das ist ein wichtiges Pattern:
        Python-Keywords können HTTP-Calls machen um den Backend-Zustand
        zu verifizieren – schneller und zuverlässiger als UI-Checks.
        """
        if not REQUESTS_AVAILABLE:
            raise RuntimeError(
                "Das 'requests' Paket ist nicht installiert. "
                "Führe 'pip install requests' aus."
            )
        try:
            response = requests.get(
                f"{base_url}/api/todos/{username}",
                timeout=5
            )
            if response.status_code == 200:
                return len(response.json())
            return 0
        except requests.RequestException as e:
            # robot.api.logger schreibt in den RF HTML-Report
            try:
                from robot.api import logger
                logger.warn(f"API-Aufruf fehlgeschlagen: {e}")
            except ImportError:
                pass
            return -1

    def clear_all_todos(self, username, base_url="http://localhost:5000"):
        """
        Löscht alle Todos eines Users per API – für sauberen Test-Zustand.

        RF Keyword-Name:  Clear All Todos
        Verwendung:       Clear All Todos    admin

        Wird im Test Setup aufgerufen damit jeder Test mit leerer Liste startet,
        egal wie oft die Suite ausgeführt wird.
        """
        if not REQUESTS_AVAILABLE:
            return
        requests.post(f"{base_url}/api/todos/{username}/clear", timeout=5)

    def wait_for_app_to_start(
        self,
        base_url="http://localhost:5000",
        max_attempts=15,
        delay_seconds=1
    ):
        """
        Pollt die App bis sie bereit ist – nützlich in CI-Pipelines.

        RF Keyword-Name:  Wait For App To Start
        Verwendung:       Wait For App To Start    http://localhost:5000

        Playwright TS Äquivalent:
          await waitForUrl('http://localhost:5000/api/health', { timeout: 15000 })
        """
        if not REQUESTS_AVAILABLE:
            # Ohne requests einfach kurz warten
            time.sleep(2)
            return True

        health_url = f"{base_url}/api/health"
        for attempt in range(1, max_attempts + 1):
            try:
                response = requests.get(health_url, timeout=2)
                if response.status_code < 500:
                    try:
                        from robot.api import logger
                        logger.info(
                            f"App ist bereit nach {attempt} Versuch(en): {health_url}"
                        )
                    except ImportError:
                        pass
                    return True
            except requests.RequestException:
                pass
            time.sleep(delay_seconds)

        raise RuntimeError(
            f"App unter {base_url} hat nach {max_attempts} Versuchen "
            f"nicht geantwortet. Ist 'python app/app.py' gestartet?"
        )

    # ─────────────────────────────────────────────────────────────
    # RF-Logging Integration
    # ─────────────────────────────────────────────────────────────

    def log_test_context(self, test_name, environment="dev"):
        """
        Schreibt Test-Kontext in den RF HTML-Report.

        RF Keyword-Name:  Log Test Context
        Verwendung:       Log Test Context    Mein Test    dev

        robot.api.logger schreibt DIREKT in den RF HTML-Report –
        nicht nur in die Konsole wie print().
        Das ist der Unterschied zu console.log() in Playwright TS.
        """
        try:
            from robot.api import logger
            logger.info(
                f"Testkontext: name='{test_name}' | "
                f"env='{environment}' | "
                f"zeit='{datetime.datetime.now().isoformat()}'"
            )
        except ImportError:
            print(f"[TestContext] {test_name} | {environment}")
