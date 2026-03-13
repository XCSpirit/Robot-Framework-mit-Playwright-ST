# =============================================================================
# todo_page.resource – Todo-Seite Keywords
# =============================================================================
#
# Zeigt:
# - XPath mit xpath= Präfix (CSS Selektoren brauchen keinen Präfix)
# - Keyword-Komposition für CRUD-Operationen
# - Wait For Elements State für auto-wait Verhalten
# =============================================================================

*** Settings ***
Library    Browser
Library    ../libraries/CustomKeywords.py
Resource   common.resource


*** Variables ***
${TODO_INPUT}     [data-testid="todo-input"]
${ADD_BUTTON}     [data-testid="add-todo-button"]
${TODO_LIST}      [data-testid="todo-list"]
${TODO_EMPTY}     [data-testid="todo-empty"]


*** Keywords ***
Alle Todos Zurücksetzen
    [Arguments]    ${username}=admin
    # Setzt Todos zurück damit Tests idempotent sind (mehrfach ausführbar)
    Clear All Todos    ${username}


Zur Todos-Seite Navigieren
    Go To    ${BASE_URL}/todos
    # Playwright: await page.waitForSelector('[data-testid="todo-input"]')
    # Browser Library macht auto-wait – aber explizites Warten ist gute Praxis
    Wait For Elements State    ${TODO_INPUT}    visible


Todo Hinzufügen
    [Arguments]    ${text}
    # Playwright: await page.fill('[data-testid="todo-input"]', text)
    Fill Text    ${TODO_INPUT}    ${text}
    # Playwright: await page.click('[data-testid="add-todo-button"]')
    Click        ${ADD_BUTTON}
    # Warten bis das neue Item in der Liste erscheint
    # XPath: braucht xpath= Präfix in Browser Library (CSS braucht keinen Präfix)
    # Playwright: await page.locator(`xpath=//li[contains(., '${text}')]`).waitFor()
    Wait For Elements State    xpath=//li[contains(., '${text}')]    visible


Todo Sollte Sichtbar Sein
    [Arguments]    ${text}
    # Playwright: await expect(page.locator(`xpath=//li[contains(., '${text}')]`)).toBeVisible()
    Wait For Elements State    xpath=//li[contains(., '${text}')]    visible


Todo Sollte Nicht Sichtbar Sein
    [Arguments]    ${text}
    # 'detached' = Element existiert nicht mehr im DOM
    # Playwright: await expect(page.locator(`xpath=//li[contains(., '${text}')]`)).not.toBeAttached()
    Wait For Elements State    xpath=//li[contains(., '${text}')]    detached


Todo Als Erledigt Markieren
    [Arguments]    ${text}
    # Klick auf den "Erledigen" Button innerhalb des Todo-Items
    # Playwright: await page.locator(`xpath=//li[contains(., '${text}')]//button[@data-action='complete']`).click()
    Click    xpath=//li[contains(., '${text}')]//button[@data-action="complete"]


Todo Löschen
    [Arguments]    ${text}
    Click    xpath=//li[contains(., '${text}')]//button[@data-action="delete"]


Todo Sollte Erledigt Sein
    [Arguments]    ${text}
    # Prüfen ob das li-Element die CSS-Klasse 'completed' hat
    # Playwright: await expect(page.locator(`xpath=//li[contains(., '${text}')]`)).toHaveClass(/completed/)
    ${classes}=    Get Attribute    xpath=//li[contains(., '${text}')]    class
    Should Contain    ${classes}    completed
