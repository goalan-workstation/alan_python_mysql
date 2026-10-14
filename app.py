# -*- coding: utf-8 -*-
"""Alan 個人介紹站：前台一頁式 + 深色科技感後台 CRUD。啟動: python app.py"""
from functools import wraps
from flask import Flask, render_template, request, redirect, url_for, session, flash, jsonify
from werkzeug.security import generate_password_hash, check_password_hash
import config
import db

app = Flask(__name__)
app.secret_key = config.SECRET_KEY


def login_required(view):
    @wraps(view)
    def wrapped(*args, **kwargs):
        if not session.get("admin_id"):
            return redirect(url_for("admin_login", next=request.path))
        return view(*args, **kwargs)
    return wrapped


@app.context_processor
def inject_admin():
    return {"admin_nickname": session.get("admin_nickname", "")}


@app.route("/")
def index():
    about = db.query_one("SELECT * FROM about ORDER BY id LIMIT 1")
    works = db.query_all("SELECT * FROM works WHERE is_show=1 ORDER BY sort_order DESC, id DESC")
    skills = [s.strip() for s in (about["skills"] if about and about["skills"] else "").split(",") if s.strip()]
    return render_template("frontend/index.html", about=about, works=works, skills=skills)


@app.route("/contact", methods=["POST"])
def contact():
    name = request.form.get("name", "").strip()
    email = request.form.get("email", "").strip()
    subject = request.form.get("subject", "").strip()
    message = request.form.get("message", "").strip()
    if not name or not email or not message:
        if request.headers.get("X-Requested-With") == "XMLHttpRequest":
            return jsonify({"ok": False, "msg": "姓名、信箱、留言內容為必填!"}), 400
        flash("姓名、信箱、留言內容為必填!", "error")
        return redirect(url_for("index") + "#contact")
    db.execute("INSERT INTO messages (name,email,subject,message) VALUES (%s,%s,%s,%s)",
               (name, email, subject, message))
    if request.headers.get("X-Requested-With") == "XMLHttpRequest":
        return jsonify({"ok": True, "msg": "訊息已送出,Alan 會盡快回覆你!"})
    flash("訊息已送出,謝謝你!", "success")
    return redirect(url_for("index") + "#contact")


@app.route("/admin/login", methods=["GET", "POST"])
def admin_login():
    if session.get("admin_id"):
        return redirect(url_for("admin_dashboard"))
    error = ""
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        password = request.form.get("password", "")
        admin = db.query_one("SELECT * FROM admins WHERE username=%s", (username,))
        if admin and check_password_hash(admin["password_hash"], password):
            session["admin_id"] = admin["id"]
            session["admin_nickname"] = admin["nickname"]
            nxt = request.args.get("next") or url_for("admin_dashboard")
            return redirect(nxt)
        error = "帳號或密碼錯誤"
    return render_template("admin/login.html", error=error)


@app.route("/admin/logout")
def admin_logout():
    session.clear()
    return redirect(url_for("admin_login"))

@app.route("/admin")
@login_required
def admin_dashboard():
    stats = {
        "works": db.query_one("SELECT COUNT(*) AS c FROM works")["c"],
        "works_show": db.query_one("SELECT COUNT(*) AS c FROM works WHERE is_show=1")["c"],
        "unread": db.query_one("SELECT COUNT(*) AS c FROM messages WHERE is_read=0")["c"],
        "messages": db.query_one("SELECT COUNT(*) AS c FROM messages")["c"],
        "admins": db.query_one("SELECT COUNT(*) AS c FROM admins")["c"],
    }
    recent = db.query_all("SELECT * FROM messages ORDER BY id DESC LIMIT 5")
    return render_template("admin/dashboard.html", stats=stats, recent=recent, active="dashboard")


@app.route("/admin/about", methods=["GET", "POST"])
@login_required
def admin_about():
    about = db.query_one("SELECT * FROM about ORDER BY id LIMIT 1")
    if request.method == "POST":
        keys = ["name", "title", "subtitle", "description", "skills", "avatar_url", "email", "phone", "location"]
        data = {k: request.form.get(k, "").strip() for k in keys}
        if about:
            data["id"] = about["id"]
            db.execute("UPDATE about SET name=%(name)s,title=%(title)s,subtitle=%(subtitle)s,"
                       "description=%(description)s,skills=%(skills)s,avatar_url=%(avatar_url)s,"
                       "email=%(email)s,phone=%(phone)s,location=%(location)s WHERE id=%(id)s", data)
        else:
            db.execute("INSERT INTO about (name,title,subtitle,description,skills,avatar_url,email,phone,location)"
                       " VALUES (%(name)s,%(title)s,%(subtitle)s,%(description)s,%(skills)s,%(avatar_url)s,"
                       "%(email)s,%(phone)s,%(location)s)", data)
        flash("關於我已更新!", "success")
        return redirect(url_for("admin_about"))
    return render_template("admin/about_form.html", about=about, active="about")


@app.route("/admin/works")
@login_required
def admin_works():
    rows = db.query_all("SELECT * FROM works ORDER BY sort_order DESC, id DESC")
    return render_template("admin/works_list.html", rows=rows, active="works")


@app.route("/admin/works/add", methods=["GET", "POST"])
@login_required
def admin_works_add():
    if request.method == "POST":
        db.execute("INSERT INTO works (title,category,description,image_url,link_url,tech_tags,sort_order,is_show)"
                   " VALUES (%s,%s,%s,%s,%s,%s,%s,%s)",
                   (request.form.get("title", "").strip(), request.form.get("category", "Web").strip(),
                    request.form.get("description", "").strip(), request.form.get("image_url", "").strip(),
                    request.form.get("link_url", "").strip(), request.form.get("tech_tags", "").strip(),
                    int(request.form.get("sort_order", 0) or 0), 1 if request.form.get("is_show") else 0))
        flash("作品已新增!", "success")
        return redirect(url_for("admin_works"))
    return render_template("admin/works_form.html", row=None, active="works")

@app.route("/admin/works/edit/<int:wid>", methods=["GET", "POST"])
@login_required
def admin_works_edit(wid):
    row = db.query_one("SELECT * FROM works WHERE id=%s", (wid,))
    if not row:
        flash("找不到該作品", "error")
        return redirect(url_for("admin_works"))
    if request.method == "POST":
        db.execute("UPDATE works SET title=%s,category=%s,description=%s,image_url=%s,link_url=%s,"
                   "tech_tags=%s,sort_order=%s,is_show=%s WHERE id=%s",
                   (request.form.get("title", "").strip(), request.form.get("category", "Web").strip(),
                    request.form.get("description", "").strip(), request.form.get("image_url", "").strip(),
                    request.form.get("link_url", "").strip(), request.form.get("tech_tags", "").strip(),
                    int(request.form.get("sort_order", 0) or 0), 1 if request.form.get("is_show") else 0, wid))
        flash("作品已更新!", "success")
        return redirect(url_for("admin_works"))
    return render_template("admin/works_form.html", row=row, active="works")


@app.route("/admin/works/delete/<int:wid>", methods=["POST"])
@login_required
def admin_works_delete(wid):
    db.execute("DELETE FROM works WHERE id=%s", (wid,))
    flash("作品已刪除", "success")
    return redirect(url_for("admin_works"))


@app.route("/admin/messages")
@login_required
def admin_messages():
    only = request.args.get("only", "all")
    if only == "unread":
        rows = db.query_all("SELECT * FROM messages WHERE is_read=0 ORDER BY id DESC")
    else:
        rows = db.query_all("SELECT * FROM messages ORDER BY id DESC")
    return render_template("admin/messages_list.html", rows=rows, only=only, active="messages")


@app.route("/admin/messages/read/<int:mid>", methods=["POST"])
@login_required
def admin_messages_read(mid):
    db.execute("UPDATE messages SET is_read=1 WHERE id=%s", (mid,))
    return redirect(url_for("admin_messages"))


@app.route("/admin/messages/unread/<int:mid>", methods=["POST"])
@login_required
def admin_messages_unread(mid):
    db.execute("UPDATE messages SET is_read=0 WHERE id=%s", (mid,))
    return redirect(url_for("admin_messages"))


@app.route("/admin/messages/delete/<int:mid>", methods=["POST"])
@login_required
def admin_messages_delete(mid):
    db.execute("DELETE FROM messages WHERE id=%s", (mid,))
    flash("留言已刪除", "success")
    return redirect(url_for("admin_messages"))


@app.route("/admin/admins")
@login_required
def admin_admins():
    rows = db.query_all("SELECT id,username,nickname,created_at FROM admins ORDER BY id")
    return render_template("admin/admins_list.html", rows=rows, active="admins")


@app.route("/admin/admins/add", methods=["GET", "POST"])
@login_required
def admin_admins_add():
    error = ""
    if request.method == "POST":
        username = request.form.get("username", "").strip()
        nickname = request.form.get("nickname", "").strip() or username
        password = request.form.get("password", "")
        if not username or not password:
            error = "帳號與密碼為必填"
        elif db.query_one("SELECT id FROM admins WHERE username=%s", (username,)):
            error = "此帳號已存在"
        else:
            db.execute("INSERT INTO admins (username,password_hash,nickname) VALUES (%s,%s,%s)",
                       (username, generate_password_hash(password), nickname))
            flash("管理員新增成功!", "success")
            return redirect(url_for("admin_admins"))
    return render_template("admin/admins_form.html", error=error, active="admins")


@app.route("/admin/admins/delete/<int:aid>", methods=["POST"])
@login_required
def admin_admins_delete(aid):
    if aid == session.get("admin_id"):
        flash("不能刪除自己!", "error")
        return redirect(url_for("admin_admins"))
    total = db.query_one("SELECT COUNT(*) AS c FROM admins")["c"]
    if total <= 1:
        flash("至少要保留一位管理員!", "error")
        return redirect(url_for("admin_admins"))
    db.execute("DELETE FROM admins WHERE id=%s", (aid,))
    flash("管理員已刪除", "success")
    return redirect(url_for("admin_admins"))


if __name__ == "__main__":
    import os
    app.run(host="127.0.0.1", port=int(os.getenv("PORT", "5000")), debug=True)

# Alwaysdata Python WSGI 進入點：application path 請填 wsgi:application
application = app

