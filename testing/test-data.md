# Test Data Design

## Purpose

The test dataset is intentionally small and designed to exercise the relationships, cardinalities, optionality, and business rules defined in the data model.

The goal is not to simulate a large e-commerce dataset, but to create enough variation to validate the model and deliberately test its boundaries.

## Customer Test Cases

| Customer | Purpose |
|---|---|
| C101 | Customer with multiple addresses and multiple orders |
| C102 | Customer with an address, order, and payment |
| C103 | Customer with multiple addresses and multiple orders |
| C104 | Customer with an address but no orders |

This demonstrates both customers with and without orders, as well as the one-to-many Customer → Address and Customer → Order relationships.

## Category Test Cases

| Category | Purpose |
|---|---|
| CAT01 | Category containing multiple products |
| CAT02 | Category containing a product |
| CAT03 | Category containing a product |
| CAT04 | Category containing a product |
| CAT05 | Category with no products |

`CAT05` deliberately tests the valid case where a category exists without any associated products.

## Product Test Cases

| Product | Purpose |
|---|---|
| P101 | Product appearing across multiple orders |
| P102 | Product appearing across multiple orders |
| P103 | Normal active product |
| P104 | Product appearing across multiple orders with historical pricing |
| P105 | Active product used in an order |
| P106 | Inactive product reserved for negative testing |

The dataset also demonstrates that a product's current selling price can differ from the historical price recorded on an order item.

## Address Test Cases

| Address | Purpose |
|---|---|
| A101 | HOME address for C101; used for an order |
| A102 | WORK address for C101; used for another order |
| A103 | HOME address for C102 |
| A104 | HOME address for C103; used for an order |
| A105 | OTHER address for C103; used for another order |
| A106 | HOME address for C104 |

This demonstrates multiple addresses per customer and the use of different customer addresses as delivery addresses for different orders.

## Order Test Cases

| Order | Purpose |
|---|---|
| O101 | Delivered order containing multiple products |
| O102 | Delivered order with multiple products and multiple payment attempts |
| O103 | Shipped order that has not yet been delivered |
| O104 | Newly placed order with no payment transaction |
| O105 | Cancelled order retaining its order items |

The different statuses and fulfillment dates provide variation for testing order lifecycle-related business rules without introducing a separate order status history model.

## Order Item Test Cases

| Order | Products | Purpose |
|---|---|---|
| O101 | P101, P102 | Multiple products in one order |
| O102 | P101, P103 | Product reuse across orders and historical pricing |
| O103 | P102, P104 | Multiple products and quantity greater than one |
| O104 | P105 | Product participation in a new order |
| O105 | P101, P104 | Cancelled order retaining order items and historical pricing |

The fixture also exercises the composite `(order_id, product_id)` key by ensuring that the same product does not appear more than once within an order.

## Payment Test Cases

| Payment | Order | Purpose |
|---|---|---|
| PAY101 | O101 | Successful payment for a delivered order |
| PAY102 | O102 | Failed payment attempt |
| PAY103 | O102 | Successful retry for the same order |
| PAY104 | O103 | Successful payment for a shipped order |
| PAY105 | O105 | Failed payment attempt for a cancelled order |

`O102` deliberately has multiple payment transactions, demonstrating why Payment is modeled as a one-to-many relationship from Order.

`O104` has no payment record, demonstrating the optional side of the Order → Payment relationship.

## Design Intent

The dataset is deliberately constructed to support later integrity and business-rule tests, including:

- Customers with zero, one, and multiple related records.
- Products that appear in multiple orders.
- Products with no purchases.
- Multiple products within a single order.
- Categories with and without products.
- Multiple addresses belonging to the same customer.
- Different customer addresses being used for different orders.
- Failed and successful payment attempts for the same order.
- Orders with no payment transaction.
- Historical order-item prices that differ from a product's current selling price.
- Inactive products reserved for negative testing.
- Cancelled orders that retain their historical order items.

## Test Data Principle

Each deliberately unusual record should have a reason for existing. If a row does not help validate a relationship, constraint, business rule, edge case, or query, it does not need to be in the dataset.

The baseline fixture contains valid data. Intentionally invalid scenarios, such as referencing a non-existent product or category, will be introduced separately during negative integrity testing rather than being stored in the baseline dataset.