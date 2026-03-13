# =============================================================================
# LEKTION 4: Vollständiger CRUD-Workflow (Create, Read, Update, Delete)
# =============================================================================
#
# Zeigt:
# - Keyword-Komposition: komplexe Abläufe aus kleinen Keywords zusammenbauen
# - Run Keywords ... AND ...  für mehrschrittigen Setup
# - Tests lesen sich wie BDD-Specs – ohne Gherkin/Cucumber
# - Wiederverwendbare Keywords aus resource files
# =============================================================================

*** Settings ***
Resource    ../resources/common.resource
Resource    ../resources/login_page.resource
Resource    ../resources/todo_page.resource

# Mehrere Keywords in Suite Setup:
# Playwright TS:
#   beforeAll(async () => {
#     await loginPage.goto()
#     await loginPage.login('admin', 'password123')
#   })
Suite Setup    Run Keywords
...            Browser Öffnen
...            AND    Als Admin Einloggen

Suite Teardown    Close Browser

# Vor jedem Test: Todos leeren + zur Todos-Seite navigieren
# → Tests sind idempotent, egal wie oft sie ausgeführt werden
Test Setup    Run Keywords
...           Alle Todos Zurücksetzen    admin
...           AND    Zur Todos-Seite Navigieren


*** Test Cases ***
Neues Todo Hinzufügen
    [Tags]    crud    smoke
    Todo Hinzufügen    Einkaufen gehen
    Todo Sollte Sichtbar Sein    Einkaufen gehen


Todo Als Erledigt Markieren
    [Tags]    crud
    Todo Hinzufügen    Hund spazieren führen
    Todo Als Erledigt Markieren    Hund spazieren führen
    Todo Sollte Erledigt Sein    Hund spazieren führen


Todo Löschen
    [Tags]    crud
    Todo Hinzufügen    Temporäre Aufgabe
    Todo Löschen    Temporäre Aufgabe
    Todo Sollte Nicht Sichtbar Sein    Temporäre Aufgabe


Vollständiger CRUD-Zyklus
    [Tags]    crud    smoke
    # Tests in RF lesen sich wie Anforderungen – kein Gherkin nötig
    Todo Hinzufügen    Robot Framework Demo schreiben
    Todo Sollte Sichtbar Sein            Robot Framework Demo schreiben
    Todo Als Erledigt Markieren                     Robot Framework Demo schreiben
    Todo Sollte Erledigt Sein    Robot Framework Demo schreiben
    Todo Löschen                       Robot Framework Demo schreiben
    Todo Sollte Nicht Sichtbar Sein        Robot Framework Demo schreiben


Mehrere Todos Hinzufügen Und Verwalten
    [Tags]    crud
    Todo Hinzufügen    Aufgabe Eins
    Todo Hinzufügen    Aufgabe Zwei
    Todo Hinzufügen    Aufgabe Drei

    Todo Sollte Sichtbar Sein    Aufgabe Eins
    Todo Sollte Sichtbar Sein    Aufgabe Zwei
    Todo Sollte Sichtbar Sein    Aufgabe Drei

    Todo Als Erledigt Markieren    Aufgabe Zwei
    Todo Sollte Erledigt Sein    Aufgabe Zwei

    # Die anderen sind noch offen
    Todo Sollte Sichtbar Sein    Aufgabe Eins
    Todo Sollte Sichtbar Sein    Aufgabe Drei

    Todo Löschen    Aufgabe Drei
    Todo Sollte Nicht Sichtbar Sein    Aufgabe Drei


Todo Feld Ist Sichtbar Und Fokussierbar
    [Tags]    smoke
    # Playwright: await expect(page.locator('[data-testid="todo-input"]')).toBeVisible()
    Wait For Elements State    [data-testid="todo-input"]    visible
    Wait For Elements State    [data-testid="todo-input"]    enabled
