from flask import Blueprint, flash, g, redirect, render_template, request, url_for
from werkzeug.exceptions import abort

from flaskr.auth import login_required
from flaskr.db import get_db

bp = Blueprint("blog", __name__, url_prefix="/posts")


def get_all_posts(search=""):
    db = get_db()
    posts = db.execute(
        "SELECT p.id, title, body, created, author_id, username"
        " FROM post p JOIN user u ON  p.author_id = u.id"
        " WHERE body like ('%' || ?1 || '%')"
        " OR title like ('%' || ?1 || '%')"
        " ORDER BY created DESC",
        (search,),
    ).fetchall()
    return posts


@bp.route("/")
def index():
    query = request.args.get("q", "")

    posts = get_all_posts(search=query)
    return render_template("blog/index.html", posts=posts)


@bp.route("/create", methods=("GET", "POST"))
@login_required
def create():
    if request.method == "POST":
        title = request.form["title"]
        body = request.form["body"]
        error = None

        if not title:
            error = "Title is required"

        if error is not None:
            flash(error)
        else:
            db = get_db()
            db.execute(
                " INSERT INTO post (title, body, author_id) Values (?, ?, ?) ",
                (title, body, g.user["id"]),
            )
            db.commit()
            return redirect(url_for("blog.index"))
    return render_template("blog/create.html")


def get_post(id, check_author=True):
    post = (
        get_db()
        .execute(
            "SELECT p.id, title, body, created, author_id, username"
            " FROM post p JOIN user u ON p.author_id = u.id"
            " WHERE p.id = ?",
            (id,),
        )
        .fetchone()
    )

    if post is None:
        abort(404, f"Post id {id} doesn't exist.")

    if check_author and post["author_id"] != g.user["id"]:
        abort(403)

    return post


def get_comments(id):
    comments = (
        get_db()
        .execute(
            "SELECT c.id, c.body, c.created, u.username"
            " FROM comment c JOIN user u ON c.author_id = u.id"
            " WHERE c.post_id = ?"
            " ORDER BY c.created DESC",
            (id,),
        )
        .fetchall()
    )

    return comments


@bp.route("/<int:id>", methods=("GET",))
def view_post(id):
    post = get_post(id, check_author=False)
    comments = get_comments(id)

    return render_template("blog/view.html", post=post, comments=comments)


@bp.route("/<int:id>/update", methods=("GET", "POST"))
@login_required
def update(id):
    post = get_post(id)

    if request.method == "POST":
        title = request.form["title"]
        body = request.form["body"]
        error = None

        if not title:
            error = "Title is required"

        if error is not None:
            flash(error)
        else:
            db = get_db()
            db.execute(
                "UPDATE post SET title = ?, body = ? WHERE id = ?", (title, body, id)
            )
            db.commit()
            return redirect(url_for("blog.index"))

    return render_template("blog/update.html", post=post)


@bp.route("/<int:id>/delete", methods=("POST",))
@login_required
def delete(id):
    get_post(id)
    db = get_db()
    db.execute("DELETE FROM post WHERE id = ?", (id,))
    db.commit()
    return redirect(url_for("blog.index"))


@bp.route("/<int:id>/comment", methods=("POST",))
@login_required
def comment(id):
    get_post(id, check_author=False)

    body = request.form["body"]
    error = None

    if not body:
        error = "Comment cannot be empty."

    if error is not None:
        flash(error)
    else:
        db = get_db()
        db.execute(
            "INSERT INTO comment (body, author_id, post_id) VALUES (?, ?, ?)",
            (body, g.user["id"], id),
        )
        db.commit()

    return redirect(url_for("blog.view_post", id=id))


# @bp.route('/search', methods=['GET', 'POST'])
# def search():
