-- ============================================
-- E-commerce Data Modeling
-- Derived values/ reconciliation tests
-- ============================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;
USE SCHEMA ECOMMERCE;

-- =========================================================
-- 1. Calculate the total value of each order from OrderItem
-- =========================================================

SELECT
    order_id,
    SUM(quantity * price_per_unit) AS order_total
FROM OrderItem
GROUP BY order_id
ORDER BY order_id;


-- =========================================================
-- 2. Verify successful payments match the order total
-- =========================================================

WITH order_totals AS (
    SELECT
        order_id,
        SUM(quantity * price_per_unit) AS order_total
    FROM OrderItem
    GROUP BY order_id
),
successful_payments AS (
    SELECT
        order_id,
        SUM(amount) AS successful_payment_total
    FROM Payment
    WHERE status = 'successful'
    GROUP BY order_id
)
SELECT
    ot.order_id,
    ot.order_total,
    sp.successful_payment_total
FROM order_totals ot
JOIN successful_payments sp
    ON ot.order_id = sp.order_id
WHERE ot.order_total <> sp.successful_payment_total;


-- =========================================================
-- 3. Find orders with a successful payment but no order items
-- =========================================================

SELECT
    p.order_id,
    SUM(p.amount) AS successful_payment_total
FROM Payment p
LEFT JOIN OrderItem oi
    ON p.order_id = oi.order_id
WHERE p.status = 'successful'
GROUP BY p.order_id
HAVING COUNT(oi.product_id) = 0;


-- =========================================================
-- 4. Identify historical prices that differ from
--    the product's current selling price
-- =========================================================

SELECT
    oi.order_id,
    oi.product_id,
    oi.price_per_unit AS historical_price,
    p.current_selling_price AS current_price
FROM OrderItem oi
JOIN Product p
    ON oi.product_id = p.product_id
WHERE oi.price_per_unit <> p.current_selling_price
ORDER BY oi.order_id, oi.product_id;