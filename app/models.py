"""
models.py – In-Memory Datenmodell für die Demo-App.

Kein Datenbank-Setup nötig – alles im RAM.
Beim Neustart der App werden Todos zurückgesetzt (Absicht: vorhersagbarer Testzustand).
"""

# Hard-coded Benutzer
# admin/password123  → normaler Admin
# user1/testpass     → normaler User
# locked/anything    → immer gesperrt (für Error-Test-Scenarios)
USERS = {
    "admin": {
        "password": "password123",
        "role": "admin",
        "name": "Admin User",
        "locked": False,
    },
    "user1": {
        "password": "testpass",
        "role": "user",
        "name": "Test User",
        "locked": False,
    },
    "locked": {
        "password": None,
        "role": "user",
        "name": "Locked Account",
        "locked": True,
    },
}

# Todos: { username: [ { id, text, complete } ] }
# Mit Start-Daten für admin, damit das Dashboard gleich etwas zeigt
_todos: dict = {
    "admin": [
        {"id": 1, "text": "Robot Framework lernen", "complete": False},
        {"id": 2, "text": "Erste Tests schreiben", "complete": True},
    ],
    "user1": [],
}
_next_id: dict = {"admin": 3, "user1": 1}


def get_user(username: str):
    return USERS.get(username)


def validate_login(username: str, password: str):
    """
    Gibt (True, user_dict) oder (False, error_message) zurück.
    """
    user = USERS.get(username)
    if not user:
        return False, "Invalid credentials"
    if user["locked"]:
        return False, "Account is locked. Please contact support."
    if user["password"] != password:
        return False, "Invalid credentials"
    return True, user


def get_todos(username: str):
    return _todos.get(username, [])


def add_todo(username: str, text: str):
    if username not in _todos:
        _todos[username] = []
        _next_id[username] = 1
    todo_id = _next_id[username]
    _todos[username].append({"id": todo_id, "text": text, "complete": False})
    _next_id[username] += 1
    return todo_id


def toggle_todo(username: str, todo_id: int):
    for todo in _todos.get(username, []):
        if todo["id"] == todo_id:
            todo["complete"] = not todo["complete"]
            return True
    return False


def clear_todos(username: str):
    _todos[username] = []
    _next_id[username] = 1


def delete_todo(username: str, todo_id: int):
    todos = _todos.get(username, [])
    before = len(todos)
    _todos[username] = [t for t in todos if t["id"] != todo_id]
    return len(_todos[username]) < before
