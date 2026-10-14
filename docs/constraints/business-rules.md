# Business Rules

## 1. Customer Rules

- A customer must have a unique identifier.
- A customer must have a name.
- A customer may exist without placing an order.
- A customer may have multiple addresses.

## 2. Address Rules

- Every address must belong to exactly one customer.
- A customer may have multiple addresses.
- A customer can have at most one `HOME` address.
- A customer can have at most one `WORK` address.
- A customer may have multiple `OTHER` addresses.
- Once an address has been used for an order, its physical address details should not be overwritten to represent a different physical location.
- If a customer changes their address, a new address record should be used rather than modifying the historical physical address associated with previous orders.

## 3. Order Rules

- Every order must belong to exactly one customer.
- Every order must have exactly one delivery address.
- An order must contain at least one product.
- An order must have a valid order status.
- Supported order statuses are `PLACED`, `SHIPPED`, `DELIVERED`, and `CANCELLED`.
- An order may exist without a payment transaction.

## 4. Order Item Rules

- Every order item must reference an existing order.
- Every order item must reference an existing product.
- Quantity must be greater than zero.
- Price charged per unit must be greater than or equal to zero.
- The same product may appear at most once within an order.
- Total item price is derived as `quantity × price_per_unit` and should not be stored as an independent value.

## 5. Product and Category Rules

- Every product must belong to exactly one category.
- A category may contain zero or more products.
- A product may exist without ever being purchased.
- A product that has been referenced by historical orders must not be physically deleted.
- Inactive products must not be used for new orders.
- A product's current selling price may change without changing the historical price recorded on existing order items.

## 6. Payment Rules

- Every payment transaction must belong to exactly one order.
- An order may have zero or more payment transactions.
- Multiple payment transactions may exist for the same order, including failed and successful attempts.
- Payment amount must be greater than or equal to zero.
- Every payment must have a valid payment status.
- Every payment must have a payment method.

## 7. Referential Integrity Rules

- An order cannot reference a non-existent customer.
- An order cannot reference a non-existent address.
- An order item cannot reference a non-existent order or product.
- A product cannot reference a non-existent category.
- A payment cannot reference a non-existent order.