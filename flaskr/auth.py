import functools


from click.termui import confirm
from flask import (
    Blueprint,
    flash,
    g,
    redirect,
    render_template,
    request,
    session,
    url_for,
)

from werkzeug.security import check_password_hash, generate_password_hash

from flaskr.db import get_db

bp = Blueprint("auth", __name__, url_prefix="/auth")


@bp.route("/register", methods=("GET", "POST"))
def register():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        db = get_db()
        error = None

        if not username:
            error = "Login jest wymagany"
        elif not password:
            error = "Hasło jest wymagane."

        if error is None:
            try:
                db.execute(
                    "INSERT INTO user (username, password) VALUES (?, ?)",
                    (username, generate_password_hash(password)),
                    # baza danych escapuje dane, więc nie powinno być możliwe zrobić injection tu
                )
                db.commit()
            except db.IntegrityError:
                error = f"Użytkownik {username} już jest zarejestrowany."
            else:
                return redirect(url_for("auth.login"))

        flash(error)

    return render_template("auth/register.html")


@bp.route("/login", methods=("GET", "POST"))
def login():
    if request.method == "POST":
        username = request.form["username"]
        password = request.form["password"]
        db = get_db()
        error = None
        user = db.execute(
            "SELECT * FROM user WHERE username = ?", (username,)
        ).fetchone()

        # czy jest taki login w bazie i czy ma takie hasło
        if user is None or not check_password_hash(user["password"], password):
            error = "Niepoprawny login lub hasło."

        if error is None:
            session.clear()
            session["user_id"] = user["id"]
            return redirect(url_for("index"))

        flash(error)

    return render_template("auth/login.html")


# sprawdza czy nie ma już zesji z użytkownikiem
@bp.before_app_request
def load_logged_in_user():
    user_id = session.get("user_id")

    if user_id is None:
        g.user = None
    else:
        g.user = (
            get_db().execute("SELECT * FROM user WHERE id = ?", (user_id,)).fetchone()
        )


@bp.route("/logout")
def logout():
    session.clear()
    return redirect(url_for("index"))


# wymaganie loginu, jeśli  nie jest zalogowany, otoczka przekierowuje do strony logowania.
def login_required(view):
    @functools.wraps(view)
    def wrapped_view(**kwargs):
        if g.user is None:
            return redirect(url_for("suth.login"))

        return view(**kwargs)

    return wrapped_view


@bp.route("/profile", methods=("GET",))
@login_required
def profile():
    user = (
        get_db()
        .execute("SELECT id, username, bio FROM user WHERE id = ?", (g.user["id"],))
        .fetchone()
    )

    return render_template("auth/profile.html", user=user)


@bp.route("/profile/update-username", methods=("POST",))
@login_required
def update_username():
    username = request.form["username"]
    db = get_db()
    error = None

    if not username:
        error = "Username is required"

    if username != g.user["username"]:
        if (
            db.execute("SELECT id FROM user WHERE username = ?", (username,)).fetchone()
            is not None
        ):
            error = f"Username {username} is already taken"

    if error is None:
        db.execute(
            "UPDATE user SET username = ? WHERE id = ?", (username, g.user["id"])
        )
        db.commit()

        session["user_id"] = g.user["id"]
        session["username"] = username

        flash("Username updated successfully.")
    else:
        flash(error)

    return redirect(url_for("auth.profile"))


@bp.route("/profile/update-bio", methods=("POST",))
@login_required
def update_bio():
    bio = request.form["bio"]
    db = get_db()

    db.execute("UPDATE user SET bio = ? WHERE id = ?", (bio, g.user["id"]))
    db.commit()

    flash("Bio updated successfully.")
    return redirect(url_for("auth.profile"))


@bp.route("/change-password", methods=("POST",))
@login_required
def change_password():
    old_password = request.form["old_password"]
    new_password = request.form["new_password"]
    confirm_password = request.form["confirm_password"]

    db = get_db()
    error = None

    user_hash = db.execute(
        "SELECT password FROM user WHERE id = ?", (g.user["id"],)
    ).fetchone()

    if not check_password_hash(user_hash["password"], old_password):
        error = "Incorrect password."
    elif not new_password:
        error = "New password is required."
    elif new_password != confirm_password:
        error = "New passwords do not match."

    if error is None:
        db.execute(
            "UPDATE user SET password = ? WHERE id = ?",
            (generate_password_hash(new_password), g.user["id"]),
        )
        db.commit()
        flash("Password updated successfully.")
    else:
        flash(error)

    return redirect(url_for("auth.profile"))
