CREATE DATABASE online_shop;
USE online_shop;

CREATE TABLE shipment_types (
  shipment_type_id CHAR(10) PRIMARY KEY,
  description      VARCHAR(255) NOT NULL
);

CREATE TABLE users (
  user_id    INT      PRIMARY KEY,
  stage      CHAR(10) NOT NULL,
  is_paid    BOOLEAN  NOT NULL DEFAULT FALSE
);

CREATE TABLE orders (
  order_id       INT        PRIMARY KEY,
  user_id        INT        NOT NULL,
  stage          CHAR(10)   NOT NULL,
  is_paid        BOOLEAN    NOT NULL DEFAULT FALSE,
  operator       CHAR(10),
  status         CHAR(10)   NOT NULL,
  shipment_type  CHAR(10)   NOT NULL,
  country        TEXT       NOT NULL,
  created_on     DATE       NOT NULL,
  sum_order      INT        NOT NULL,
  sum_shipment   INT        NOT NULL,
  total          INT        AS (sum_order + sum_shipment) STORED,
  FOREIGN KEY (user_id)        REFERENCES users(user_id),
  FOREIGN KEY (shipment_type)  REFERENCES shipment_types(shipment_type_id)
);

CREATE TABLE order_details (
  detail_id        INT          PRIMARY KEY AUTO_INCREMENT,
  order_id         INT          NOT NULL,
  client_name      VARCHAR(255) NOT NULL,
  phone_number     VARCHAR(20),
  email            VARCHAR(255),
  address          VARCHAR(255),
  shipment_type_id CHAR(10)     NOT NULL,
  FOREIGN KEY (order_id)         REFERENCES orders(order_id),
  FOREIGN KEY (shipment_type_id) REFERENCES shipment_types(shipment_type_id)
);

-- вставляем данные в таблицы
INSERT INTO shipment_types (shipment_type_id, description) VALUES
  ('standard', 'Standard Shipping'),
  ('express',  'Express Shipping');

INSERT INTO users (user_id, stage, is_paid) VALUES
  (1, 'new',    FALSE),
  (2, 'active', TRUE),
  (3, 'banned', FALSE);

INSERT INTO orders (order_id, user_id, stage, is_paid, operator, status, shipment_type, country, created_on, sum_order, sum_shipment)
VALUES
  (101, 1, 'new',    FALSE, 'op1', 'pending',  'standard', 'USA',     '2025-05-20', 100, 10),
  (102, 2, 'active', TRUE,  'op2', 'shipped',  'express',  'Germany', '2025-05-22', 200, 20),
  (103, 3, 'closed', FALSE, 'op1', 'cancelled','standard', 'France',  '2025-05-23', 150, 15);

INSERT INTO order_details (order_id, client_name, phone_number, email, address, shipment_type_id)
VALUES
  (101, 'Иван Иванов', '+1234567890', 'ivan@example.com',  'ул. Пушкина, 1', 'standard'),
  (102, 'Мария Петрова','+0987654321','maria@example.de','ул. Лермонтова, 2','express');

-- удаление строк
DELETE FROM order_details WHERE order_id = 103;
DELETE FROM orders        WHERE order_id = 103;
DELETE FROM users         WHERE user_id  = 3;

-- изменение структуры таблицы
ALTER TABLE orders
  ADD COLUMN shipped_date DATE;

ALTER TABLE orders
  DROP COLUMN operator;

-- новые клиенты
SELECT * FROM users WHERE stage = 'new';

-- AND
SELECT order_id, user_id, total
FROM orders
WHERE country = 'USA' AND is_paid = TRUE;

-- OR
SELECT detail_id, order_id, client_name, shipment_type_id
FROM order_details
WHERE shipment_type_id = 'standard' OR shipment_type_id = 'express';
