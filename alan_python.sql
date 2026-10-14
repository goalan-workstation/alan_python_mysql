-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 2026-10-14 07:46:17
-- 伺服器版本： 10.4.32-MariaDB
-- PHP 版本： 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `alan_python`
--

-- --------------------------------------------------------

--
-- 資料表結構 `about`
--

CREATE TABLE `about` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL DEFAULT 'Alan' COMMENT '姓名',
  `title` varchar(100) NOT NULL DEFAULT 'Python 全端工程師' COMMENT '職稱',
  `subtitle` varchar(255) NOT NULL DEFAULT '用程式打造有溫度的科技體驗' COMMENT '副標',
  `description` text DEFAULT NULL COMMENT '自我介紹',
  `skills` varchar(500) NOT NULL DEFAULT 'Python,Flask,MySQL,JavaScript,PHP' COMMENT '技能(逗號分隔)',
  `avatar_url` varchar(255) NOT NULL DEFAULT '' COMMENT '大頭貼URL',
  `email` varchar(100) NOT NULL DEFAULT 'alan@example.com',
  `phone` varchar(30) NOT NULL DEFAULT '0912-345-678',
  `location` varchar(100) NOT NULL DEFAULT '台灣・台北',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='關於我';

--
-- 傾印資料表的資料 `about`
--

INSERT INTO `about` (`id`, `name`, `title`, `subtitle`, `description`, `skills`, `avatar_url`, `email`, `phone`, `location`, `updated_at`) VALUES
(1, 'Alan', 'Python 全端工程師', '用程式打造有溫度的科技體驗｜Flask × MySQL × JS 特效', '哈囉，我是 Alan！此網站使用 Python 後端與資料庫應用開發，Flask、MySQL、PHP 與前端 JS 特效。喜歡把複雜的需求變成簡潔、快速、好維護的系統。這個一頁式網站本身就是一個 Flask + MySQL CRUD 作品：前台內容與後台管理全部連動資料庫。', 'Python,Flask,MySQL,JavaScript,PHP,HTML/CSS', 'https://api.dicebear.com/9.x/bottts-neutral/svg?seed=Alan', 'go.alan@gmail.com', '0918-066725', '台灣・台中', '2026-10-14 03:52:40');

-- --------------------------------------------------------

--
-- 資料表結構 `admins`
--

CREATE TABLE `admins` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL COMMENT '帳號',
  `password_hash` varchar(255) NOT NULL COMMENT '密碼雜湊',
  `nickname` varchar(50) NOT NULL DEFAULT '管理員' COMMENT '暱稱',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='後台管理員管理';

--
-- 傾印資料表的資料 `admins`
--

INSERT INTO `admins` (`id`, `username`, `password_hash`, `nickname`, `created_at`) VALUES
(1, 'root', 'scrypt:32768:8:1$aXz43dLN1rLPnDEs$d8e7115787f7f3cc36654f9f5b5c5edcc1fab9cd13bb2afb80d07a1c5a6d7c543c66f6614553bd5eca4b4ade528bbeb3b1fc1f4ecdeea401a856b10c2be9b1bf', '站長 Alan', '2026-10-14 03:28:15'),
(2, 'test', 'scrypt:32768:8:1$VinBgQTlKx2GSwbR$611fb6b127f4fb364d22654f8670bedb0b56cac40f47d46b6d0eb4967d7a43b9d86e37fef016ddf27d6d166eb82c42096f6b602dfb92e1a821c7919eac9c1f29', '測試員', '2026-10-14 03:51:11');

-- --------------------------------------------------------

--
-- 資料表結構 `messages`
--

CREATE TABLE `messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(50) NOT NULL COMMENT '姓名',
  `email` varchar(100) NOT NULL COMMENT '信箱',
  `subject` varchar(150) NOT NULL DEFAULT '' COMMENT '主旨',
  `message` text NOT NULL COMMENT '留言內容',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0未讀 1已讀',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='聯絡我留言';

--
-- 傾印資料表的資料 `messages`
--

INSERT INTO `messages` (`id`, `name`, `email`, `subject`, `message`, `is_read`, `created_at`) VALUES
(1, 'Alan Jiang', 'go.alan@gmail.com', '測試留言', '妳好', 0, '2026-10-14 03:53:59');

-- --------------------------------------------------------

--
-- 資料表結構 `works`
--

CREATE TABLE `works` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(100) NOT NULL COMMENT '作品標題',
  `category` varchar(50) NOT NULL DEFAULT 'Web 開發' COMMENT '分類',
  `description` text DEFAULT NULL COMMENT '作品介紹',
  `image_url` varchar(255) NOT NULL DEFAULT '' COMMENT '封面圖URL',
  `link_url` varchar(255) NOT NULL DEFAULT '' COMMENT '作品連結',
  `tech_tags` varchar(255) NOT NULL DEFAULT '' COMMENT '技術標籤(逗號分隔)',
  `sort_order` int(11) NOT NULL DEFAULT 0 COMMENT '排序(大到小)',
  `is_show` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1顯示 0隱藏',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='作品分享';

--
-- 傾印資料表的資料 `works`
--

INSERT INTO `works` (`id`, `title`, `category`, `description`, `image_url`, `link_url`, `tech_tags`, `sort_order`, `is_show`, `created_at`) VALUES
(1, '智慧電商後台', 'Web 開發', 'Flask + MySQL 打造的訂單/商品/會員管理後台，含圖表儀表板與權限控管。', '', '', 'Python,Flask,MySQL,Chart.js', 30, 1, '2026-10-14 03:28:15'),
(2, '個人科技形象站', '前端特效', 'Canvas 粒子星空、打字機、3D 傾斜卡片、Scroll 進場動畫的一頁式網站。', '', '', 'HTML,CSS,JavaScript,Canvas', 20, 1, '2026-10-14 03:28:15'),
(3, '留言板 CRUD 系統', 'Web 開發', '本專案前身：訪客留言、前後台連動、已讀/未讀、完整 CRUD。', '', '', 'Python,Flask,PyMySQL', 10, 1, '2026-10-14 03:28:15');

--
-- 已傾印資料表的索引
--

--
-- 資料表索引 `about`
--
ALTER TABLE `about`
  ADD PRIMARY KEY (`id`);

--
-- 資料表索引 `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_username` (`username`);

--
-- 資料表索引 `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_read_time` (`is_read`,`created_at`);

--
-- 資料表索引 `works`
--
ALTER TABLE `works`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_show_sort` (`is_show`,`sort_order`);

--
-- 在傾印的資料表使用自動遞增(AUTO_INCREMENT)
--

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `about`
--
ALTER TABLE `about`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `admins`
--
ALTER TABLE `admins`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- 使用資料表自動遞增(AUTO_INCREMENT) `works`
--
ALTER TABLE `works`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
