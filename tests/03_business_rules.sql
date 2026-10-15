-- ============================================
-- E-commerce Data Modeling
-- Business Rule Tests
-- ============================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;
USE SCHEMA ECOMMERCE;


-- ============================================
-- 1. Order Item Quantity
-- Rule: Quantity must be greater than zero
-- Expected: 0 rows
-- ============================================

SELECT *
FROM OrderItem
WHERE quantity <= 0;


-- ============================================
-- 2. Order Item Price
-- Rule: Price charged per unit must be >= 0
-- Expected: 0 rows
-- ============================================

SELECT *
FROM OrderItem
WHERE price_per_unit < 0;


-- ============================================
-- 3. Product Price
-- Rule: Current selling price must be > 0
-- Expected: 0 rows
-- ============================================

SELECT *
FROM Product
WHERE current_selling_price <= 0;


-- ============================================
-- 4. Orders Must Contain Products
-- Rule: Every order must contain at least one product
-- Expected: 0 rows
-- ============================================

SELECT
    o.order_id
FROM Orders o
LEFT JOIN OrderItem oi
    ON o.order_id = oi.order_id
WHERE oi.order_id IS NULL;


-- ============================================
-- 5. Duplicate Product Within Order
-- Rule: Same product may appear at most once
-- within an order
-- Expected: 0 rows
-- ============================================

SELECT
    order_id,
    product_id,
    COUNT(*) AS occurrence_count
FROM OrderItem
GROUP BY order_id, product_id
HAVING COUNT(*) > 1;


-- ============================================
-- 6. Product Category
-- Rule: Every product must belong to a category
-- Expected: 0 rows
-- ============================================

SELECT *
FROM Product
WHERE category_id IS NULL;


-- ============================================
-- 7. Inactive Products in Orders
-- Rule: Inactive products must not be used
-- for new orders
-- Expected: 0 rows
-- ============================================

SELECT
    oi.order_id,
    oi.product_id,
    p.is_active
FROM OrderItem oi
JOIN Product p
    ON oi.product_id = p.product_id
WHERE p.is_active = 'inactive';


-- ============================================
-- 8. Order Customer and Delivery Address
-- Rule: The delivery address must belong to
-- the same customer as the order
-- Expected: 0 rows
-- ============================================

SELECT
    o.order_id,
    o.customer_id,
    o.address_id,
    a.customer_id AS address_customer_id
FROM Orders o
JOIN Address a
    ON o.address_id = a.address_id
WHERE o.customer_id <> a.customer_id;