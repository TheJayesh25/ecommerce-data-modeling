-- ============================================
-- E-commerce Data Modeling in Snowflake
-- Environment Setup
-- ============================================

USE ROLE ACCOUNTADMIN;

USE WAREHOUSE COMPUTE_WH;

CREATE DATABASE IF NOT EXISTS ECOMMERCE_DB;

CREATE SCHEMA IF NOT EXISTS ECOMMERCE_DB.ECOMMERCE;

USE DATABASE ECOMMERCE_DB;

USE SCHEMA ECOMMERCE_DB.ECOMMERCE;

-- ============================================
-- Verifying the setup
-- ============================================
SELECT CURRENT_ROLE();
SELECT CURRENT_WAREHOUSE();
SELECT CURRENT_DATABASE();
SELECT CURRENT_SCHEMA();