-- ===========================================================
-- DDL Scripts for creating Entities of the Data Model (Table)
-- Customer
-- ===========================================================

CREATE TABLE Customer (
    customer_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    birth_date DATE,
    mobile_no VARCHAR(20),
    email_address VARCHAR(254)
);

-- ============================================
-- Category
-- ============================================

CREATE TABLE Category (
    category_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- ============================================
-- Product
-- ============================================

CREATE TABLE Product (
    product_id VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(500),
    current_selling_price NUMBER(10,2) NOT NULL
        CHECK (current_selling_price > 0),
    category_id VARCHAR(20) NOT NULL,
    is_active VARCHAR(10)
        CHECK (is_active IN ('active', 'inactive')),
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES Category(category_id)
);

-- ============================================
-- Address
-- ============================================

CREATE TABLE Address (
    address_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    address_type VARCHAR(10) 
        CHECK (address_type IN ('HOME','WORK','OTHER')),
    address_line1 VARCHAR(150) NOT NULL,
    address_line2 VARCHAR(150),
    pincode	VARCHAR(20) NOT NULL,
    city VARCHAR(20) NOT NULL,
    state VARCHAR(20) NOT NULL,
    country	VARCHAR(20) NOT NULL,
    CONSTRAINT fk_address_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
);

-- ============================================
-- Orders
-- ============================================

CREATE TABLE Orders (
    order_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20) NOT NULL,
    address_id VARCHAR(20) NOT NULL,
    order_date DATE NOT NULL,
    shipping_date DATE,
    delivery_date DATE,
    status VARCHAR(20) NOT NULL
        CHECK (status in ('PLACED', 'SHIPPED', 'DELIVERED', 'CANCELLED')),

    CONSTRAINT fk_orders_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id),

    CONSTRAINT fk_orders_address
        FOREIGN KEY (address_id)
        REFERENCES Address(address_id)
);

-- ============================================
-- Orderitem
-- ============================================

CREATE TABLE OrderItem (
    order_id VARCHAR(20) NOT NULL,
    product_id VARCHAR(20) NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity>0),
    price_per_unit NUMBER(10, 2) NOT NULL CHECK (price_per_unit >= 0),
    
    PRIMARY KEY (order_id, product_id),

    CONSTRAINT fk_orderitem_orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id),

    CONSTRAINT fk_orderitem_product
        FOREIGN KEY (product_id)
        REFERENCES Product(product_id)
);

-- ============================================
-- Payment
-- ============================================

CREATE TABLE Payment(
    payment_id VARCHAR(20) PRIMARY KEY,
    order_id VARCHAR(20) NOT NULL,
    amount NUMBER(10,2)	NOT NULL CHECK (amount>=0),
    status VARCHAR(20) NOT NULL CHECK (status in ('successful', 'failed')),
    payment_method VARCHAR(20) NOT NULL CHECK (payment_method in ('upi', 'card', 'netbanking', 'cod')),

    CONSTRAINT fk_payment_orders
        FOREIGN KEY (order_id)
        REFERENCES Orders(order_id)
);