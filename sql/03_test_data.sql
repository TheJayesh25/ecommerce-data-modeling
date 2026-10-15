-- ============================================
-- E-commerce Data Modeling
-- Test Data
-- ============================================

USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ECOMMERCE_DB;
USE SCHEMA ECOMMERCE;

-- ============================================
-- Reset existing test data
-- ============================================

TRUNCATE TABLE Payment;
TRUNCATE TABLE OrderItem;
TRUNCATE TABLE Orders;
TRUNCATE TABLE Address;
TRUNCATE TABLE Product;
TRUNCATE TABLE Category;
TRUNCATE TABLE Customer;

-- ============================================
-- 1. Customer
-- ============================================

-- Insert customer test data here

INSERT INTO Customer (
    customer_id,
    name,
    birth_date,
    mobile_no,
    email_address
)
VALUES
    ('C101', 'Aarav Mehta', '1998-04-12', '+91-90000-10101', 'aarav.mehta@example.com'),
    ('C102', 'Priya Sharma', '1995-09-27', '+91-90000-10102', 'priya.sharma@example.com'),
    ('C103', 'Rohan Kapoor', '2001-01-18', '+91-90000-10103', 'rohan.kapoor@example.com'),
    ('C104', 'Neha Iyer', '1999-07-05', '+91-90000-10104', 'neha.iyer@example.com');


-- ============================================
-- 2. Category
-- ============================================

-- Insert category test data here

INSERT INTO Category (
    category_id,
    name
)
VALUES
    ('CAT01', 'Electronics'),
    ('CAT02', 'Home Appliances'),
    ('CAT03', 'Books'),
    ('CAT04', 'Fitness'),
    ('CAT05', 'Pet Supplies');

-- ============================================
-- 3. Product
-- ============================================

-- Insert product test data here

INSERT INTO Product (
    product_id,
    name,
    description,
    current_selling_price,
    category_id,
    is_active
)
VALUES
    ('P101', 'Wireless Mouse', 'Ergonomic wireless mouse', 1299.00, 'CAT01', 'active'),
    ('P102', 'Mechanical Keyboard', 'Compact mechanical keyboard', 3499.00, 'CAT01', 'active'),
    ('P103', 'Air Fryer', 'Digital air fryer', 5999.00, 'CAT02', 'active'),
    ('P104', 'Data Engineering Fundamentals', 'Beginner data engineering book', 899.00, 'CAT03', 'active'),
    ('P105', 'Yoga Mat', 'Non-slip exercise mat', 799.00, 'CAT04', 'active'),
    ('P106', 'Wired Headphones', 'Over-ear wired headphones', 1599.00, 'CAT01', 'inactive');

-- ============================================
-- 4. Address
-- ============================================

-- Insert address test data here

INSERT INTO Address (
    address_id,
    customer_id,
    address_type,
    address_line1,
    address_line2,
    pincode,
    city,
    state,
    country
)
VALUES 
    ('A101', 'C101', 'HOME', '12 Lake View Road', 'Andheri West', '400053', 'Mumbai', 'Maharashtra', 'India'),
    ('A102', 'C101', 'WORK', '45 Business Park', 'Andheri East', '400069', 'Mumbai', 'Maharashtra', 'India'),
    ('A103', 'C102', 'HOME', '21 Green Avenue', 'Powai', '400076', 'Mumbai', 'Maharashtra', 'India'),
    ('A104', 'C103', 'HOME', '8 Station Road', 'Thane West', '400601', 'Thane', 'Maharashtra', 'India'),
    ('A105', 'C103', 'OTHER', '17 Market Street', 'Thane East', '400603', 'Thane', 'Maharashtra', 'India'),
    ('A106', 'C104', 'HOME', '33 Sunrise Lane', 'Vashi', '400703', 'Navi Mumbai', 'Maharashtra', 'India');

-- ============================================
-- 5. Orders
-- ============================================

-- Insert order test data here

INSERT INTO Orders (
    order_id,
    customer_id, 
    address_id,
    order_date,
    shipping_date,
    delivery_date,
    status
)
VALUES
    ('O101', 'C101', 'A101', '2026-10-01', '2026-10-02', '2026-10-04', 'DELIVERED'),
    ('O102', 'C101', 'A102', '2026-10-08', '2026-10-09', '2026-10-11', 'DELIVERED'),
    ('O103', 'C102', 'A103', '2026-10-10', '2026-10-11', NULL, 'SHIPPED'),
    ('O104', 'C103', 'A104', '2026-10-12', NULL, NULL, 'PLACED'),
    ('O105', 'C103', 'A105', '2026-10-13', NULL, NULL, 'CANCELLED');

-- ============================================
-- 6. OrderItem
-- ============================================

-- Insert order item test data here

INSERT INTO OrderItem (
    order_id,
    product_id,
    quantity,
    price_per_unit
)
VALUES 
    ('O101', 'P101', 2, 1299.00),
    ('O101', 'P102', 1, 3499.00),
    ('O102', 'P101', 1, 1199.00),
    ('O102', 'P103', 1, 5999.00),
    ('O103', 'P102', 1, 3499.00),
    ('O103', 'P104', 2, 899.00),
    ('O104', 'P105', 1, 799.00),
    ('O105', 'P101', 1, 1299.00),
    ('O105', 'P104', 1, 849.00);

-- ============================================
-- 7. Payment
-- ============================================

-- Insert payment test data here

INSERT INTO Payment (
    payment_id,	
    order_id,	
    amount,	
    status,	
    payment_method
)
VALUES
    ('PAY101', 'O101', 6097.00, 'successful', 'card'),
    ('PAY102', 'O102', 7198.00, 'failed', 'upi'),
    ('PAY103', 'O102', 7198.00, 'successful', 'upi'),
    ('PAY104', 'O103', 5297.00, 'successful', 'card'),
    ('PAY105', 'O105', 2148.00, 'failed', 'card');