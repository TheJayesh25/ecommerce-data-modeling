# Testing

## Purpose

The testing phase validates whether the implemented schema behaves according to the business rules and relationships defined during the modeling process.

The tests are intentionally focused on data integrity rather than application-level testing. The objective is to identify invalid relationships, business-rule violations, inconsistent derived values, and edge cases in the relational model.

---

## Test Strategy

Testing was divided into four main areas:

1. **Structural validation** - confirm that the expected tables and baseline row counts exist.
2. **Referential integrity** - identify orphaned records across parent-child relationships.
3. **Business-rule validation** - validate rules that are not necessarily represented by simple table constraints.
4. **Derived-value and reconciliation testing** - validate calculated values and consistency between related facts.
5. **Negative testing** - deliberately introduce invalid data to understand which rules are enforced by the database and which require explicit data-quality checks.

The baseline dataset was restored after negative testing so that the repository contains a clean, valid fixture.

---

## 1. Row Count Validation

**SQL:** `tests/01_row_counts.sql`

The baseline dataset was expected to contain:

| Table | Expected Rows |
|---|---:|
| Customer | 4 |
| Category | 5 |
| Product | 6 |
| Address | 6 |
| Orders | 5 |
| OrderItem | 9 |
| Payment | 5 |

All expected row counts matched the baseline fixture.

This provides a simple sanity check that the test dataset was loaded completely and that subsequent tests are operating against the intended data.

---

## 2. Referential Integrity Testing

**SQL:** `tests/02_relationship_integrity.sql`

The following relationships were tested for orphaned child records:

- Orders → Customer
- Orders → Address
- OrderItem → Orders
- OrderItem → Product
- Product → Category
- Payment → Orders

All tests returned zero orphaned records.

These tests use `LEFT JOIN` logic to identify child records for which no corresponding parent record exists.

---

## 3. Business Rule Testing

**SQL:** `tests/03_business_rules.sql`

The following business rules were validated:

- Order item quantity must be greater than zero.
- Order item price must be non-negative.
- Product current selling price must be greater than zero.
- Every order must contain at least one order item.
- A product may appear at most once within an order.
- Every product must have a category.
- Inactive products must not be used in order items.
- An order's delivery address must belong to the same customer as the order.

All baseline tests returned zero violations.

### Important Modeling Observation

The final rule above is not enforced by the current `Orders` foreign keys.

The schema independently validates:

```text
Orders.customer_id → Customer.customer_id
Orders.address_id  → Address.address_id
```

However, those relationships do not guarantee:

```text
Orders.customer_id = Address.customer_id
```

Therefore, this is treated as a cross-table business rule and validated through an explicit data-quality query.

---

## 4. Derived Value and Reconciliation Testing

**SQL:** `tests/04_derived_values.sql`

Order totals were calculated from:

```text
quantity × price_per_unit
```

rather than being stored directly in `Orders` or `OrderItem`.

The resulting order totals were:

| Order | Calculated Total |
|---|---:|
| O101 | 6097 |
| O102 | 7198 |
| O103 | 5297 |
| O104 | 799 |
| O105 | 2148 |

Successful payment amounts were reconciled against calculated order totals. No mismatches were found for orders with successful payments.

Failed payment attempts were intentionally excluded from successful-payment reconciliation because a failed transaction does not represent money successfully collected.

The test data also demonstrated that historical order-item prices can differ from a product's current selling price. This validates the decision to store `price_per_unit` on `OrderItem`.

---

## 5. Negative Testing

**SQL:** `tests/05_negative_tests.sql`

The model was deliberately tested with invalid scenarios to distinguish between:

- rules enforced by database constraints, and
- rules that require explicit data-quality validation.

### Database-level constraint tests

The following invalid records were rejected:

- `OrderItem.quantity = 0`
- Invalid `Orders.status`
- Duplicate `(order_id, product_id)` when treated as a primary-key constraint by the database would normally be expected to fail in an OLTP database.

However, the Snowflake implementation exposed an important platform-specific behavior.

### Snowflake Constraint Behavior

This project uses standard Snowflake tables.

Snowflake stores primary key, unique, and foreign key constraints as relational metadata, but these constraints are not enforced on standard tables in the same way they are in traditional OLTP databases such as SQL Server or PostgreSQL.

This was demonstrated during negative testing:

- The composite `OrderItem` primary key defines the intended uniqueness of `(order_id, product_id)`.
- Snowflake nevertheless allowed a duplicate `(O101, P101)` row to be inserted.
- The duplicate was subsequently detected by the explicit business-rule/data-quality test.
- Similarly, foreign-key constraints should not be relied upon to reject invalid parent-child references in this implementation; these relationships are additionally validated through data-quality tests.

`NOT NULL` and `CHECK` constraints were enforced during testing.

This provided an important implementation-level learning from the project:

> **The logical model defines the intended integrity rules, while the physical database platform determines which of those rules are automatically enforced.**

The same logical model could therefore behave differently when implemented in a traditional OLTP database such as SQL Server or PostgreSQL.

---

## 6. Final Test Result

After negative testing, the baseline dataset was restored.

The final valid dataset passed:

- Row-count validation
- Referential integrity checks
- Business-rule checks
- Derived-value reconciliation
- Historical pricing validation

The negative tests also demonstrated which integrity rules require explicit data-quality validation in the Snowflake implementation.

---

## Key Testing Lessons

### 1. A valid schema does not guarantee valid business data

Some rules cannot be represented by a simple primary key, foreign key, `CHECK`, or `NOT NULL` constraint.

### 2. Constraints and data-quality tests serve different purposes

Database constraints can prevent or restrict certain invalid states, while explicit SQL tests can validate more complex business conditions.

### 3. Platform behavior matters

The logical model should not be assumed to behave identically across database platforms. Snowflake's treatment of standard-table PK, UNIQUE, and FK constraints differs from traditional OLTP databases.

### 4. Historical facts should be tested independently of current reference data

The historical price stored on an order item must remain valid even when the product's current selling price changes.

### 5. Test data should have deliberate purpose

Each unusual record in the fixture exists to exercise a relationship, business rule, optionality condition, historical scenario, or negative test.