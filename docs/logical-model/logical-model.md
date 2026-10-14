# Logical Model

## Purpose

The logical model defines the attributes, keys, and relationships of the entities identified during conceptual modeling. It represents the relational structure without tying the model to database-specific data types or implementation details.

## Entities and Attributes

| Entity | Attribute | Key / Relationship |
|---|---|---|
| **Customer** | `customer_id` | PK |
| | `name` | |
| | `birth_date` | |
| | `mobile_no` | |
| | `email_address` | |
| **Address** | `address_id` | PK |
| | `customer_id` | FK → Customer |
| | `address_type` | |
| | `address_line1` | |
| | `address_line2` | |
| | `pincode` | |
| | `city` | |
| | `state` | |
| | `country` | |
| **Orders** | `order_id` | PK |
| | `customer_id` | FK → Customer |
| | `address_id` | FK → Address |
| | `order_date` | |
| | `shipping_date` | |
| | `delivery_date` | |
| | `status` | |
| **OrderItem** | `order_id` | PK, FK → Orders |
| | `product_id` | PK, FK → Product |
| | `quantity` | |
| | `price_per_unit` | |
| **Product** | `product_id` | PK |
| | `name` | |
| | `description` | |
| | `current_selling_price` | |
| | `category_id` | FK → Category |
| | `is_active` | |
| **Category** | `category_id` | PK |
| | `name` | |
| **Payment** | `payment_id` | PK |
| | `order_id` | FK → Orders |
| | `amount` | |
| | `status` | |
| | `payment_method` | |

## Key Relationships

- `Address.customer_id` references `Customer.customer_id`.
- `Orders.customer_id` references `Customer.customer_id`.
- `Orders.address_id` references `Address.address_id`.
- `OrderItem.order_id` references `Orders.order_id`.
- `OrderItem.product_id` references `Product.product_id`.
- `Product.category_id` references `Category.category_id`.
- `Payment.order_id` references `Orders.order_id`.

## Key Design Notes

- `OrderItem` uses a composite primary key of `(order_id, product_id)`, based on the rule that the same product can appear at most once within an order.
- `OrderItem.price_per_unit` records the price actually charged at the time of purchase, while `Product.current_selling_price` represents the current product price.
- `OrderItem.total_price` is derived from `quantity × price_per_unit` and is not stored.
- `is_active` allows products to be deactivated without removing products referenced by historical orders.
- `Orders.customer_id` is retained separately from `Orders.address_id` because the customer placing the order and the delivery address represent distinct business relationships.