-- ============================================
-- E-commerce Data Modeling
-- Relationship Integrity Tests
-- ============================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;
USE SCHEMA ECOMMERCE;


-- ============================================
-- 1. Orders -> Customer
-- ============================================

SELECT COUNT(*) AS orphan_orders
FROM Orders o
LEFT JOIN Customer c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;


-- ============================================
-- 2. Orders -> Address
-- ============================================

SELECT COUNT(*) AS orphan_order_addresses
FROM Orders o
LEFT JOIN Address a
    ON o.address_id = a.address_id
WHERE a.address_id IS NULL;


-- ============================================
-- 3. OrderItem -> Orders
-- ============================================

SELECT COUNT(*) AS orphan_order_items
FROM OrderItem oi
LEFT JOIN Orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;


-- ============================================
-- 4. OrderItem -> Product
-- ============================================

SELECT COUNT(*) AS orphan_order_products
FROM OrderItem oi
LEFT JOIN Product p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;


-- ============================================
-- 5. Product -> Category
-- ============================================

SELECT COUNT(*) AS orphan_products
FROM Product p
LEFT JOIN Category c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;


-- ============================================
-- 6. Payment -> Orders
-- ============================================

SELECT COUNT(*) AS orphan_payments
FROM Payment p
LEFT JOIN Orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;