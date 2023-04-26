from flask import Flask, redirect, url_for, render_template, flash
from flask_dance.contrib.google import make_google_blueprint, google
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, logout_user, current_user, login_required

app = Flask(__name__)
app.config["SECRET_KEY"] = "your_secret_key"
app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///db.sqlite3"
app.config["OAUTHLIB_INSECURE_TRANSPORT"] = 1  # Use this only for development

db = SQLAlchemy(app)
login_manager = LoginManager(app)
login_manager.login_view = "google.login"  # Redirect to Google login when accessing protected routes

google_blueprint = make_google_blueprint(
    client_id="your_client_id",
    client_secret="your_client_secret",
    scope=["profile", "email"],
    redirect_url="/google/authorized",
)

app.register_blueprint(google_blueprint, url_prefix="/google")

class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(80), unique=True, nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)

    def __repr__(self):
        return f"<User {self.username}>"

@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/google/authorized")
def authorized():
    if not google.authorized:
        return redirect(url_for("google.login"))

    resp = google.get("/oauth2/v2/userinfo")
    if resp.ok:
        user_info = resp.json()
        email = user_info["email"]
        user = User.query.filter_by(email=email).first()

        if not user:
            user = User(username=user_info["name"], email=email)
            db.session.add(user)
            db.session.commit()

        login_user(user)

        flash("You have successfully logged in.", "success")
        return redirect(url_for("index"))

    flash("Failed to log in.", "error")
    return redirect(url_for("index"))

@app.route("/logout")
@login_required
def logout():
    logout_user()
    flash("You have successfully logged out.", "success")
    return redirect(url_for("index"))

@app.route("/dashboard")
@login_required
def dashboard():
    return render_template("dashboard.html")

if __name__ == "__main__":
    db.create_all()
    app.run(debug=True)
