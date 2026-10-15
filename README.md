# E-commerce Data Modeling

A hands-on e-commerce data modeling project covering conceptual, logical, and physical data modeling, normalization, keys, relationships, constraints, and data integrity.

Built in Snowflake to translate modeling decisions into a practical relational schema.

---

## Project Objective

The goal of this project was to strengthen practical relational data modeling fundamentals through a small but realistic e-commerce scenario.

The project follows the progression:

**Business Requirements → Conceptual Model → Logical Model → Physical Model → Implementation → Testing → Documentation**

The focus is on understanding **why** the model is designed a certain way, rather than simply creating tables that work.

---

## Scenario

The system represents a simplified e-commerce platform where customers can:

- Maintain multiple addresses.
- Place orders.
- Purchase multiple products within an order.
- Use different delivery addresses.
- Make payment attempts for orders.

Products belong to categories and can have a current selling price that changes over time.

The model therefore needs to preserve historical order information while maintaining clean relationships between customers, orders, products, addresses, categories, and payments.

---

## Business Requirements

The core requirements include:

- A customer can place multiple orders.
- Every order belongs to exactly one customer.
- A customer can maintain multiple addresses.
- Every order has exactly one delivery address.
- An order contains one or more products.
- A product can appear in many orders.
- Quantity and price charged must be recorded for each product within an order.
- Every product belongs to exactly one category.
- A category can contain multiple products or no products.
- An order can have zero or more payment transactions.
- Multiple payment attempts may exist for the same order.
- Historical order-item prices must remain independent of a product's current selling price.
- Invalid relationships and business-rule violations should be detectable through integrity testing.

Detailed business rules are documented in:

[`docs/constraints/business-rules.md`](docs/constraints/business-rules.md)

---

## Data Model

The final relational model contains seven entities:

| Entity | Purpose |
|---|---|
| `Customer` | Stores customer account information |
| `Address` | Stores customer delivery/contact addresses |
| `Orders` | Represents an individual customer order |
| `OrderItem` | Resolves the many-to-many relationship between orders and products |
| `Product` | Stores product information and current selling price |
| `Category` | Groups products into categories |
| `Payment` | Stores individual payment transactions or attempts |

### Key Relationships

```text
Customer 1 ──── N Orders
Customer 1 ──── N Address
Address  1 ──── N Orders
Category 1 ──── N Product
Orders   1 ──── N OrderItem
Product  1 ──── N OrderItem
Orders   1 ──── N Payment
```

`OrderItem` resolves the many-to-many relationship between `Orders` and `Product`.

### Important Grain Decisions

- **Orders:** one row per order.
- **OrderItem:** one row per product within an order.
- **Payment:** one row per payment transaction/attempt.
- **Address:** one row per customer address.

The composite key `(order_id, product_id)` is used for `OrderItem` because the current business rules allow a product to appear at most once within an order.

If that business rule changes in the future, the model could introduce a dedicated `order_item_id`.

---

## Key Design Decisions

### Historical Pricing

`OrderItem.price_per_unit` stores the price actually charged when the order was placed.

It is intentionally separate from:

```text
Product.current_selling_price
```

This prevents changes to the current product price from altering historical order values.

### Derived Order Totals

Order totals are not stored as an independent attribute.

They are derived from:

```text
SUM(quantity × price_per_unit)
```

This avoids storing redundant data that could become inconsistent with the underlying order items.

### Separate Customer and Address Relationships

`Orders` stores both:

```text
customer_id
address_id
```

These represent different business facts:

- `customer_id` identifies who owns the order.
- `address_id` identifies where the order is being delivered.

Keeping them separate also allows historical addresses to remain associated with previous orders.

### Address History

A customer's physical address is not overwritten to represent a different physical location after it has been used by an order.

A new address record is created instead.

### Multiple Payment Attempts

Payments are modeled as a one-to-many relationship from `Orders` because an order may have multiple payment attempts, including failed and successful transactions.

---

## Normalization

The model was designed with normalization principles through **Third Normal Form (3NF)**.

Key functional dependencies include:

```text
customer_id → customer attributes

address_id → address attributes

order_id → order attributes

(order_id, product_id) → quantity, price_per_unit

product_id → product attributes

category_id → category attributes

payment_id → payment attributes
```

The design aims to ensure:

- Atomic attributes and no repeating groups.
- No partial dependency on part of a composite key.
- No unnecessary transitive dependencies between non-key attributes.
- Business facts are stored at the appropriate entity grain.

Detailed modeling decisions and normalization reasoning are documented in:

[`docs/design-decisions/decisions.md`](docs/design-decisions/decisions.md)

---

## Implementation

The physical schema is implemented in Snowflake.

### Database Structure

```text
ECOMMERCE_DB
└── ECOMMERCE
    ├── Customer
    ├── Category
    ├── Product
    ├── Address
    ├── Orders
    ├── OrderItem
    └── Payment
```

### SQL Structure

```text
sql/
├── 00_setup.sql
├── 01_create_tables.sql
├── 02_verify_schema.sql
└── 03_test_data.sql
```

The SQL is intentionally separated into setup, schema creation, verification, and test-data loading.

---

## Testing

Testing was treated as part of the modeling process rather than an afterthought.

The project validates:

- Baseline row counts.
- Referential integrity.
- Business rules.
- Derived order totals.
- Successful payment reconciliation.
- Historical pricing behavior.
- Invalid and edge-case scenarios.

Tests are located in:

```text
tests/
├── 01_row_counts.sql
├── 02_relationship_integrity.sql
├── 03_business_rules.sql
├── 04_derived_values.sql
└── 05_negative_tests.sql
```

The full testing methodology and findings are documented in:

[`docs/testing/testing.md`](docs/testing/testing.md)

---

## Snowflake Constraint Behavior

This project uses standard Snowflake tables.

Snowflake stores primary key, unique, and foreign key constraints as relational metadata, but these constraints are not enforced on standard tables in the same way they are in traditional OLTP databases such as SQL Server or PostgreSQL.

This became particularly visible during negative testing: Snowflake allowed a duplicate `(order_id, product_id)` value despite the logical composite primary key defined on `OrderItem`.

The duplicate was subsequently detected through an explicit data-quality test.

This provided an important implementation-level lesson:

> **The logical model defines the intended integrity rules, while the physical database platform determines which of those rules are automatically enforced.**

`NOT NULL` and `CHECK` constraints were enforced during testing.

More detail is documented in [`docs/testing/testing.md`](docs/testing/testing.md).

---

## Why Snowflake?

> **A quick note on Snowflake**
>
> This project is implemented in Snowflake, even though the model itself is primarily an OLTP-style relational model. Yes, I know — using a data warehouse to practice transactional data modeling is a little like bringing a forklift to move a coffee table.
>
> The reason is intentional: Snowflake is already part of my Data Engineering stack, so I wanted to use it to translate the conceptual and logical model into a physical implementation without introducing another platform solely for this exercise.
>
> The focus of this project is **relational data modeling**, not demonstrating Snowflake's analytical capabilities. In a production transactional application, a database such as PostgreSQL or SQL Server would likely be a more natural platform choice.
>
> The same logical model could also be adapted into a dimensional/analytical model if the objective were reporting and analytics.

---

## Repository Structure

```text
ecommerce-data-modeling/
├── README.md
├── docs/
│   ├── requirements/
│   │   └── business-requirements.md
│   ├── conceptual-model/
│   │   ├── conceptual-model.md
│   │   └── erd.png
│   ├── logical-model/
│   │   └── logical-model.md
│   ├── constraints/
│   │   └── business-rules.md
│   ├── design-decisions/
│   │   └── decisions.md
│   └── testing/
│       ├── test-data.md
│       └── testing.md
├── sql/
│   ├── 00_setup.sql
│   ├── 01_create_tables.sql
│   ├── 02_verify_schema.sql
│   └── 03_test_data.sql
└── tests/
    ├── 01_row_counts.sql
    ├── 02_relationship_integrity.sql
    ├── 03_business_rules.sql
    ├── 04_derived_values.sql
    └── 05_negative_tests.sql
```

---

## What I Learned

This project reinforced several practical data modeling concepts:

- Translating business requirements into entities and relationships.
- Thinking about **grain** before defining tables.
- Distinguishing one-to-many from many-to-many relationships.
- Resolving many-to-many relationships through junction entities.
- Choosing between surrogate and natural/business keys.
- Understanding composite keys and their relationship to entity grain.
- Applying normalization through 3NF.
- Separating current reference data from historical transactional facts.
- Distinguishing database constraints from broader business rules.
- Designing test data specifically to exercise relationships and edge cases.
- Understanding how physical database platform behavior can differ from the logical model.

One of the most useful lessons was that **a data model is not finished when the tables are created**. The model needs to be challenged with realistic and deliberately invalid data to determine whether its assumptions actually hold.

---

## Future Improvements

The model is intentionally scoped as a learning project rather than a production e-commerce platform.

Possible extensions include:

- Order status history rather than storing only the current status.
- More detailed payment states and refund handling.
- Product inventory and stock movements.
- Product variants such as size or color.
- Discounts, coupons, and promotions.
- Shipping and delivery tracking.
- Customer account authentication and lifecycle management.
- A dimensional model for analytical workloads.

These were intentionally excluded from the current scope to keep the project focused on core relational modeling fundamentals.

---

## Project Status

**Completed**

The project covers:

- Business requirements
- Conceptual modeling
- Logical modeling
- Physical implementation
- Normalization
- Keys and relationships
- Constraints
- Test-data design
- Integrity testing
- Negative testing
- Documentation

An ERD will be added to `docs/conceptual-model/` as the final visual representation of the model.