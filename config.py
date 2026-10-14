# -*- coding: utf-8 -*-
"""DB 設定：與 conn/conn.inc.php 保持一致 (預設 XAMPP 本機)。"""
import os

DB_HOST = os.getenv("DB_HOST", "mysql-alanwork.alwaysdata.net")
DB_PORT = int(os.getenv("DB_PORT", "3306"))
DB_NAME = os.getenv("DB_NAME", "alanwork_php_python")
DB_USER = os.getenv("DB_USER", "alanwork")
DB_PASSWORD = os.getenv("DB_PASSWORD", "ji-yuu2013")

SECRET_KEY = os.getenv("SECRET_KEY", "alan-python-tech-2026-secret")
