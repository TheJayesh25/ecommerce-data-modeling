-- ============================================
-- E-commerce Data Modeling
-- Schema Verification
-- ============================================

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE ECOMMERCE_DB;

USE SCHEMA ECOMMERCE;


-- Verify tables were created
SHOW TABLES;


-- Verify table row counts
SELECT
    table_name,
    row_count
FROM ECOMMERCE_DB.INFORMATION_SCHEMA.TABLES
WHERE table_schema = 'ECOMMERCE'
ORDER BY table_name;


-- Verify primary and foreign key constraints
SELECT
    table_name,
    constraint_name,
    constraint_type
FROM ECOMMERCE_DB.INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE table_schema = 'ECOMMERCE'
ORDER BY table_name, constraint_type, constraint_name;