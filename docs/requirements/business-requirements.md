# Business Requirements

## 1. Customer Management

- Customers must be identifiable and their basic contact/account information maintained.
- A customer may place multiple orders.
- A customer may exist without placing any orders.

## 2. Order Management

- Each order belongs to exactly one customer.
- An order must record when it was placed.
- An order must have a status.
- Supported order statuses include PLACED, SHIPPED, DELIVERED, and CANCELLED.
- An order must contain one or more products.
- An order must have a delivery address.

## 3. Products

- Products must have a name, description, and current selling price.
- Each product belongs to one category.
- A product may exist without ever being purchased.
- A product may appear in multiple orders.

## 4. Order Contents

- The quantity of each product purchased must be recorded.
- The price charged for each product must be recorded for the order.
- The same product may appear at most once within an order.

## 5. Addresses

- A customer may have multiple addresses.
- An order uses one delivery address.
- An address may be used for multiple orders.
- For this version, a customer can have at most one HOME address and one WORK address; additional addresses may be classified as OTHER.
- When a customer changes their address, existing address records used by historical orders must be preserved.

## 6. Payments

- An order may have zero or more payment transactions.
- Each payment records its amount, payment method, and status.
- Multiple payment attempts for the same order must be representable.

## 7. Data Integrity

- References between related business records must be valid.
- Invalid or inconsistent relationships should be prevented wherever the database can enforce them.
- Historical order information should remain intact when products or customer addresses change.

## 8. Scope Boundaries

The first version does not model:
- Inventory management
- Product pricing history
- Refund workflows
- Payment authorization/capture lifecycle
- Shipping/carrier management
- Customer accounts/authentication