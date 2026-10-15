-- ============================================
-- E-commerce Data Modeling
-- Negative tests
-- ============================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;
USE SCHEMA ECOMMERCE;

-- =========================================================
-- 1. Invalid quantity
-- Expected: rejected by CHECK constraint
-- =========================================================

INSERT INTO OrderItem (
    order_id,
    product_id,
    quantity,
    price_per_unit
)
VALUES (
    'O101',
    'P103',
    0,
    5999.00
);


-- =========================================================
-- 2. Invalid order status
-- Expected: rejected by CHECK constraint
-- =========================================================

INSERT INTO Orders (
    order_id,
    customer_id,
    address_id,
    order_date,
    status
)
VALUES (
    'O106',
    'C101',
    'A101',
    '2026-10-15',
    'PROCESSING'
);


-- =========================================================
-- 3. Non-existent customer
-- Expected: FK metadata exists, but Snowflake standard-table
-- FK is not enforced like an OLTP database.
-- Our integrity test should catch this.
-- =========================================================

INSERT INTO Orders (
    order_id,
    customer_id,
    address_id,
    order_date,
    status
)
VALUES (
    'O107',
    'C999',
    'A101',
    '2026-10-15',
    'PLACED'
);


-- =========================================================
-- 4. Address belonging to another customer
-- Expected: DDL accepts it.
-- Business-rule test should catch it.
-- =========================================================

INSERT INTO Orders (
    order_id,
    customer_id,
    address_id,
    order_date,
    status
)
VALUES (
    'O108',
    'C101',
    'A103',
    '2026-10-15',
    'PLACED'
);


-- =========================================================
-- 5. Duplicate product within the same order
-- Expected: accepted by Snowflake because PRIMARY KEY
-- constraints are not enforced on standard Snowflake tables.
-- The duplicate should instead be detected by our
-- data-quality/business-rule tests.
-- =========================================================

INSERT INTO OrderItem (
    order_id,
    product_id,
    quantity,
    price_per_unit
)
VALUES (
    'O101',
    'P101',
    1,
    1299.00
);