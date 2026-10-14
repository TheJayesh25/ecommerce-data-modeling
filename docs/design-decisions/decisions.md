# Design Decisions

## 1. Address as a Separate Entity

Addresses are modeled separately from Customer because a customer may have multiple addresses and the same address may be used for multiple orders.

Historical orders retain their reference to the address used for delivery. Physical address details should therefore not be overwritten to represent a different location.

## 2. Order Item Resolves the Order–Product Many-to-Many Relationship

An order can contain multiple products, and a product can appear in multiple orders. The many-to-many relationship is therefore resolved through the `OrderItem` entity.

`OrderItem` represents the grain of one product within one order.

This also provides a place to store attributes that belong to the relationship itself, such as `quantity` and `price_per_unit`.

## 3. Composite Key for Order Item

`OrderItem` uses `(order_id, product_id)` as its composite primary key.

This is based on the business rule that the same product can appear at most once within a single order.

If the business requirement changes to allow the same product to appear multiple times within an order, a separate `order_item_id` would be required to uniquely identify each row.

## 4. Historical Product Price

`Product.current_selling_price` represents the product's current price, while `OrderItem.price_per_unit` represents the price actually charged for that order.

The historical transaction price is therefore preserved even when the product's current selling price changes.

## 5. Derived Order Item Total

`total_price` is not stored in `OrderItem`.

It can be calculated as:

`quantity × price_per_unit`

Storing it independently would introduce another value that could become inconsistent with the quantity and unit price.

## 6. Customer Reference on Orders

`Orders.customer_id` is retained even though the customer could technically be reached through `Orders.address_id → Address.customer_id`.

The two relationships represent different business facts:

- `customer_id` identifies who placed the order.
- `address_id` identifies where the order should be delivered.

Keeping both relationships also makes the order's ownership explicit.

## 7. Payment Transaction Grain

A Payment represents one payment transaction or attempt.

An order may therefore have multiple payment records, including failed and successful attempts. A separate payment-attempt counter is not required because the individual payment records already represent those attempts.

Refunds and more detailed payment lifecycle events are outside the scope of this version.

## 8. Product Deactivation Instead of Deletion

Products referenced by historical orders should not be physically deleted.

The model therefore uses `is_active` to distinguish products that are available for new purchases from products that have been deactivated, while preserving historical references.

## 9. Surrogate Keys and Business Keys

Most entities use surrogate identifiers as their primary keys.

`OrderItem` is the exception in the current model because `(order_id, product_id)` naturally identifies the relationship under the current business rule.

The choice of a primary key is treated separately from business uniqueness constraints. A future change in business rules may require a surrogate `order_item_id` while still retaining a uniqueness constraint where appropriate.

## 10. Scope of the Current Model

The model intentionally does not cover:

- Inventory management
- Product variants
- Promotions and discounts
- Refund workflows
- Payment authorization/capture lifecycle
- Shipping providers or shipment tracking
- Order status history
- Customer accounts/login credentials
- Advanced address history/versioning

These can be introduced in future iterations if the business requirements require them.