"""
app.py – Flask Demo-Applikation für Robot Framework Training.

Diese App simuliert eine einfache Webanwendung mit:
- Login / Logout
- Dashboard
- Todo-Liste (CRUD)
- REST-API Endpunkt (für Python-Library Demo in RF)

Alle HTML-Elemente haben data-testid Attribute –
genau wie Playwright-Entwickler es gewohnt sind.
"""

from flask import (
    Flask, render_template, request, redirect,
    url_for, session, jsonify, flash
)
import models

app = Flask(__name__)
app.secret_key = "robot-demo-secret-key-not-for-production"


# ─────────────────────────────────────────────
# Hilfsfunktion: Login-Schutz
# ─────────────────────────────────────────────
def require_login():
    if "username" not in session:
        return redirect(url_for("login"))
    return None


# ─────────────────────────────────────────────
# Routes
# ─────────────────────────────────────────────
@app.route("/")
def index():
    if "username" in session:
        return redirect(url_for("dashboard"))
    return redirect(url_for("login"))


@app.route("/login", methods=["GET", "POST"])
def login():
    error = None
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")

        if not username or not password:
            error = "Username and password are required"
        else:
            ok, result = models.validate_login(username, password)
            if ok:
                session["username"] = username
                session["user_name"] = result["name"]
                session["user_role"] = result["role"]
                return redirect(url_for("dashboard"))
            else:
                error = result

    return render_template("login.html", error=error)


@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("login"))


@app.route("/dashboard")
def dashboard():
    redir = require_login()
    if redir:
        return redir
    username = session["username"]
    todos = models.get_todos(username)
    open_count = sum(1 for t in todos if not t["complete"])
    done_count = sum(1 for t in todos if t["complete"])
    return render_template(
        "dashboard.html",
        user_name=session["user_name"],
        user_role=session["user_role"],
        open_count=open_count,
        done_count=done_count,
        total_count=len(todos),
    )


@app.route("/todos", methods=["GET", "POST"])
def todos():
    redir = require_login()
    if redir:
        return redir
    username = session["username"]

    if request.method == "POST":
        text = request.form.get("text", "").strip()
        if text:
            models.add_todo(username, text)
        return redirect(url_for("todos"))

    return render_template(
        "todos.html",
        todos=models.get_todos(username),
        user_name=session["user_name"],
    )


@app.route("/todos/<int:todo_id>/complete", methods=["POST"])
def complete_todo(todo_id):
    redir = require_login()
    if redir:
        return redir
    models.toggle_todo(session["username"], todo_id)
    return redirect(url_for("todos"))


@app.route("/todos/<int:todo_id>/delete", methods=["POST"])
def delete_todo(todo_id):
    redir = require_login()
    if redir:
        return redir
    models.delete_todo(session["username"], todo_id)
    return redirect(url_for("todos"))


# ─────────────────────────────────────────────
# REST-API (für CustomKeywords.py Demo)
# ─────────────────────────────────────────────
@app.route("/api/todos/<username>")
def api_todos(username):
    """
    Gibt Todos eines Users als JSON zurück.
    Genutzt von CustomKeywords.get_todo_count_via_api()
    um zu zeigen, wie Python-Keywords Backend-State prüfen können
    ohne durch die UI zu gehen.
    """
    todos = models.get_todos(username)
    return jsonify(todos)


@app.route("/api/todos/<username>/clear", methods=["POST"])
def api_clear_todos(username):
    """Löscht alle Todos eines Users – nur für Tests gedacht."""
    models.clear_todos(username)
    return jsonify({"status": "cleared"})


@app.route("/api/health")
def health():
    """Health-Check Endpunkt – genutzt von wait_for_app_to_start()"""
    return jsonify({"status": "ok"})


# ─────────────────────────────────────────────
# Start
# ─────────────────────────────────────────────
if __name__ == "__main__":
    print("\n" + "=" * 50)
    print("  Robot Framework Demo App läuft!")
    print("  Öffne: http://localhost:5000")
    print("  Login: admin / password123")
    print("=" * 50 + "\n")
    app.run(debug=True, port=5000)
