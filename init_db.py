# -*- coding: utf-8 -*-
"""建表 + 種子資料。執行: python init_db.py"""
from werkzeug.security import generate_password_hash
import db

SCHEMA_FILE = "schema.sql"

ABOUT_SEED = {
    "name": "Alan",
    "title": "Python 全端工程師",
    "subtitle": "用程式打造有溫度的科技體驗｜Flask × MySQL × JS 特效",
    "description": "哈囉，我是 Alan！專注於 Python 後端與資料庫應用開發，熟悉 Flask、MySQL、PHP 與前端 JS 特效。喜歡把複雜的需求變成簡潔、快速、好維護的系統。這個一頁式網站本身就是一個 Flask + MySQL CRUD 作品：前台內容與後台管理全部連動資料庫。",
    "skills": "Python,Flask,MySQL,JavaScript,PHP,HTML/CSS",
    "avatar_url": "https://api.dicebear.com/9.x/bottts-neutral/svg?seed=Alan",
    "email": "alan@example.com",
    "phone": "0912-345-678",
    "location": "台灣・台北",
}

WORKS_SEED = [
    ("智慧電商後台", "Web 開發", "Flask + MySQL 打造的訂單/商品/會員管理後台，含圖表儀表板與權限控管。", "", "", "Python,Flask,MySQL,Chart.js", 30, 1),
    ("個人科技形象站", "前端特效", "Canvas 粒子星空、打字機、3D 傾斜卡片、Scroll 進場動畫的一頁式網站。", "", "", "HTML,CSS,JavaScript,Canvas", 20, 1),
    ("留言板 CRUD 系統", "Web 開發", "本專案前身：訪客留言、前後台連動、已讀/未讀、完整 CRUD。", "", "", "Python,Flask,PyMySQL", 10, 1),
]


def main():
    with open(SCHEMA_FILE, "r", encoding="utf-8") as f:
        sql_text = f.read()
    conn = db.get_conn()
    try:
        with conn.cursor() as cur:
            for stmt in sql_text.split(";"):
                stmt = stmt.strip()
                if stmt:
                    cur.execute(stmt)
    finally:
        conn.close()
    print("資料表建立完成")

    if not db.query_one("SELECT id FROM about LIMIT 1"):
        db.execute(
            "INSERT INTO about (name,title,subtitle,description,skills,avatar_url,email,phone,location)"
            " VALUES (%(name)s,%(title)s,%(subtitle)s,%(description)s,%(skills)s,%(avatar_url)s,%(email)s,%(phone)s,%(location)s)",
            ABOUT_SEED,
        )
        print("about 種子完成")

    if not db.query_one("SELECT id FROM works LIMIT 1"):
        for w in WORKS_SEED:
            db.execute(
                "INSERT INTO works (title,category,description,image_url,link_url,tech_tags,sort_order,is_show)"
                " VALUES (%s,%s,%s,%s,%s,%s,%s,%s)", w,
            )
        print("works 種子完成")

    if not db.query_one("SELECT id FROM admins WHERE username='root'"):
        db.execute(
            "INSERT INTO admins (username,password_hash,nickname) VALUES (%s,%s,%s)",
            ("root", generate_password_hash("alan1123"), "站長 Alan"),
        )
        print("管理員 root / alan1123 建立完成")
    else:
        print("管理員 root 已存在")
    print("全部完成！")


if __name__ == "__main__":
    main()
