# Test Data Design

## Purpose

The test dataset is intentionally small and designed to exercise the relationships, cardinalities, optionality, and business rules defined in the data model.

The goal is not to simulate a large e-commerce dataset, but to create enough variation to validate the model and deliberately test its boundaries.

## Customer Test Cases

| Customer | Purpose |
|---|---|
| C101 | Main customer with multiple addresses and multiple orders |
| C102 | Customer used for multiple orders and payment scenarios |
| C103 | Customer with multiple addresses |
| C104 | Customer with no orders |

This allows the model to demonstrate both customers with and without orders, as well as the one-to-many Customer → Address relationship.

## Category Test Cases

| Category | Purpose |
|---|---|
| CAT01 | Category containing multiple products |
| CAT02 | Category containing a product |
| CAT03 | Category containing a product |
| CAT04 | Category containing a product |
| CAT05 | Category with no products, testing the valid case where a category exists without any associated products |

The dataset intentionally includes `CAT05` with no products to test the optional side of the Category → Product relationship.

## Product Test Cases

| Product | Purpose |
|---|---|
| P101 | Frequently purchased product; used to test repeated use across orders |
| P102 | Product appearing in multiple orders |
| P103 | Normal active product |
| P104 | Normal active product |
| P105 | Active product that has not been purchased |
| P106 | Inactive product used to test the inactive-product business rule |

## Design Intent

The dataset is deliberately constructed to support later integrity and business-rule tests, including:

- Customers with zero, one, and multiple related records.
- Products that have never been purchased.
- Products that appear in multiple orders.
- Multiple products within a single order.
- Categories with and without products.
- Multiple addresses belonging to the same customer.
- Failed and successful payment attempts for the same order.
- Historical order-item prices that differ from a product's current selling price.
- Inactive products and validation that they cannot be used for new orders.

The test data therefore acts as a **test fixture for the model**, rather than simply sample data.

## Test Data Principle

Each deliberately unusual record should have a reason for existing. If a row does not help validate a relationship, constraint, business rule, edge case, or query, it does not need to be in the dataset.