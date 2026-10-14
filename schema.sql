-- alan_python 資料庫建表 (utf8mb4)
CREATE DATABASE IF NOT EXISTS `alan_python` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `alan_python`;

-- 關於我
CREATE TABLE IF NOT EXISTS `about` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL DEFAULT 'Alan' COMMENT '姓名',
  `title` VARCHAR(100) NOT NULL DEFAULT 'Python 全端工程師' COMMENT '職稱',
  `subtitle` VARCHAR(255) NOT NULL DEFAULT '用程式打造有溫度的科技體驗' COMMENT '副標',
  `description` TEXT COMMENT '自我介紹',
  `skills` VARCHAR(500) NOT NULL DEFAULT 'Python,Flask,MySQL,JavaScript,PHP' COMMENT '技能(逗號分隔)',
  `avatar_url` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '大頭貼URL',
  `email` VARCHAR(100) NOT NULL DEFAULT 'alan@example.com',
  `phone` VARCHAR(30) NOT NULL DEFAULT '0912-345-678',
  `location` VARCHAR(100) NOT NULL DEFAULT '台灣・台北',
  `updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='關於我';

-- 作品分享
CREATE TABLE IF NOT EXISTS `works` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL COMMENT '作品標題',
  `category` VARCHAR(50) NOT NULL DEFAULT 'Web 開發' COMMENT '分類',
  `description` TEXT COMMENT '作品介紹',
  `image_url` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '封面圖URL',
  `link_url` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '作品連結',
  `tech_tags` VARCHAR(255) NOT NULL DEFAULT '' COMMENT '技術標籤(逗號分隔)',
  `sort_order` INT NOT NULL DEFAULT 0 COMMENT '排序(大到小)',
  `is_show` TINYINT(1) NOT NULL DEFAULT 1 COMMENT '1顯示 0隱藏',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_show_sort` (`is_show`, `sort_order`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='作品分享';

-- 聯絡我(前台留言)
CREATE TABLE IF NOT EXISTS `messages` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(50) NOT NULL COMMENT '姓名',
  `email` VARCHAR(100) NOT NULL COMMENT '信箱',
  `subject` VARCHAR(150) NOT NULL DEFAULT '' COMMENT '主旨',
  `message` TEXT NOT NULL COMMENT '留言內容',
  `is_read` TINYINT(1) NOT NULL DEFAULT 0 COMMENT '0未讀 1已讀',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_read_time` (`is_read`, `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聯絡我留言';

-- 後台管理員管理
CREATE TABLE IF NOT EXISTS `admins` (
  `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(50) NOT NULL COMMENT '帳號',
  `password_hash` VARCHAR(255) NOT NULL COMMENT '密碼雜湊',
  `nickname` VARCHAR(50) NOT NULL DEFAULT '管理員' COMMENT '暱稱',
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='後台管理員管理';
