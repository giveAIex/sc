-- 创建数据库
CREATE DATABASE IF NOT EXISTS ling_mall DEFAULT CHARACTER SET utf8mb4;
USE ling_mall;

-- 先删除已存在的表（避免表已存在错误，注意删除顺序：先删有外键的表，再删被引用的表）
DROP TABLE IF EXISTS mall_order;
DROP TABLE IF EXISTS goods;
DROP TABLE IF EXISTS goods_category;
DROP TABLE IF EXISTS user;

-- 1. 用户表（区分角色：1=管理员，2=商家，3=客户）
CREATE TABLE user (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    role INT NOT NULL COMMENT '1-管理员 2-商家 3-客户',
    phone VARCHAR(20),
    email VARCHAR(50),
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 2. 商品分类表
CREATE TABLE goods_category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(200) COMMENT '分类描述'
);

-- 3. 商品表
CREATE TABLE goods (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    category_id INT,
    merchant_id INT,
    img_url VARCHAR(200),
    description VARCHAR(500) COMMENT '商品描述',
    status INT DEFAULT 1 COMMENT '1-上架 0-下架',
    FOREIGN KEY (category_id) REFERENCES goods_category(id),
    FOREIGN KEY (merchant_id) REFERENCES user(id)
);

-- 4. 订单表
CREATE TABLE mall_order (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_no VARCHAR(30) NOT NULL UNIQUE,
    user_id INT,
    goods_id INT,
    num INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status INT DEFAULT 0 COMMENT '0-待付款 1-待发货 2-待收货 3-完成 4-取消',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES user(id),
    FOREIGN KEY (goods_id) REFERENCES goods(id)
);

-- 插入测试数据
INSERT INTO user (username, password, role) VALUES 
('admin', '123456', 1),  -- 管理员账号
('merchant1', '123456', 2), -- 商家账号
('customer1', '123456', 3); -- 客户账号

INSERT INTO goods_category (name, description) VALUES 
('日用百货', '洗发水、毛巾等'),
('食品零食', '饼干、饮料等');

INSERT INTO goods (name, price, stock, category_id, merchant_id, description) VALUES 
('飘柔洗发水', 35.9, 100, 1, 2, '去屑控油'),
('奥利奥饼干', 8.9, 200, 2, 2, '巧克力味');