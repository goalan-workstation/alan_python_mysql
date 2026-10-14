# -*- coding: utf-8 -*-
"""Alwaysdata Python WSGI 進入點。Site 設定 application path 請填 wsgi:application"""
import os
import sys

CURRENT_DIR = os.path.dirname(os.path.abspath(__file__))
if CURRENT_DIR not in sys.path:
    sys.path.insert(0, CURRENT_DIR)

from app import app as application  # noqa: E402
