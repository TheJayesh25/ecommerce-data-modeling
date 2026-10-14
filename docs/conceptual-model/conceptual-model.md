## **Purpose**:

To identify core business entities in the e-commerce system and understand how they relate to each other at a high level before defining attributes, keys, constraints, and database-specific implementation details.


## Core Business Entities

- **Customer:** Entity representing a customer with their basic account and contact information.
- **Address:** Entity representing an address associated with a customer potentially used for order deliveries.
- **Order:** Entity representing an order placed by a customer.
- **Order Item:** Entity representing a specific product included in an order.
- **Product:** Entity representing a product that can be purchased by customers.
- **Category:** Entity representing a classification used to group products.
- **Payment:** Entity representing a payment transaction associated with an order.


## Relationships

- **Customer → Order:** A customer can place multiple orders, while each order belongs to exactly one customer.
- **Customer → Address:** A customer can have multiple addresses, while each address belongs to exactly one customer.
- **Order → Address:** Each order has exactly one delivery address, while an address can be used for multiple orders.
- **Order ↔ Product:** An order can contain multiple products, and a product can appear in multiple orders. This represents a many-to-many relationship, which is resolved through the **Order Item** entity.
- **Product → Category:** Each product belongs to one category, while a category can contain multiple products.
- **Order → Payment:** An order can have multiple payment transactions, while each payment transaction belongs to exactly one order.
- **Order → Order Item:** An order contains one or more order items, while each order item belongs to exactly one order.
- **Product → Order Item:** A product can appear in zero or more order items, while each order item references exactly one product.


## Cardinality and Optionality
| From | To | Relationship |
|---|---|---|
| Customer | Order | 1 : 0..N |
| Order | Customer | N : 1 |
| Customer | Address | 1 : 0..N |
| Address | Customer | N : 1 |
| Order | Address | N : 1 |
| Address | Order | 1 : 0..N |
| Order | Order Item | 1 : 1..N |
| Order Item | Order | N : 1 |
| Product | Order Item | 1 : 0..N |
| Order Item | Product | N : 1 |
| Category | Product | 1 : 0..N |
| Product | Category | N : 1 |
| Order | Payment | 1 : 0..N |
| Payment | Order | N : 1 |


## Conceptual Model Scope

This model focuses on the main business entities and their relationships within the e-commerce domain.

The conceptual model intentionally does not define:

- Entity attributes and data types
- Primary and foreign keys
- Normalization and functional dependencies
- Detailed business-rule enforcement
- Database constraints
- Physical database implementation

These decisions are addressed in the logical and physical modeling stages.