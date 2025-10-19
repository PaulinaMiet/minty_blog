import os

from flask import Flask, redirect


def create_app(test_config=None):
    # stwórz i skonfiguruj aplikację Flask
    app = Flask(__name__, instance_relative_config=True)
    app.config.from_mapping(
        SECRET_KEY="dev",
        DATABASE=os.path.join(app.instance_path, "flaskr.sqlite"),
    )

    if test_config is None:
        # wczytaj konfigurację z pliku konfiguracyjnego
        app.config.from_pyfile("config.py", silent=True)
    else:
        # wczytaj konfigurację z pliku testowego
        app.config.from_mapping(test_config)

    # upewnij się, że folder instancji istnieje
    try:
        os.makedirs(app.instance_path)
    except OSError:
        pass

    from . import db

    db.init_app(app)

    from . import auth

    app.register_blueprint(auth.bp)

    from . import blog

    app.register_blueprint(blog.bp)
    # app.add_url_rule("/", endpoint="index")

    @app.route("/")
    def index():
        return redirect("/posts")

    return app
