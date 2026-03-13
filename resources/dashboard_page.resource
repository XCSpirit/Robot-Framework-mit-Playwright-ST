# =============================================================================
# dashboard_page.resource – Dashboard Page Keywords
# =============================================================================

*** Settings ***
Library    Browser
Resource   common.resource


*** Variables ***
${WELCOME_MESSAGE}    [data-testid="welcome-message"]
${USER_ROLE}          [data-testid="user-role"]
${TODO_COUNT}         [data-testid="todo-count"]
${NAV_TODOS}          [data-testid="nav-todos"]


*** Keywords ***
Dashboard Zeigt Willkommen Für
    [Arguments]    ${expected_name}
    # Playwright: await expect(page.locator('[data-testid="welcome-message"]')).toContainText(name)
    Wait For Elements State    ${WELCOME_MESSAGE}    visible
    Get Text    ${WELCOME_MESSAGE}    contains    ${expected_name}


Vom Dashboard Zu Todos Navigieren
    Click    ${NAV_TODOS}
    Wait For Elements State    [data-testid="todo-input"]    visible
