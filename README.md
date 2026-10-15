# ecommerce-data-modelinh
A hands-on e-commerce data modeling project covering conceptual, logical, and physical data modeling, normalization, keys, relationships, constraints, and data integrity. Built in Snowflake to translate modeling decisions into a practical relational schema.

> **A quick note on Snowflake**
>
> This project is implemented in Snowflake, even though the model itself is primarily an OLTP-style relational model. Yes, I know using a data warehouse to practice transactional data modeling is a little like bringing a forklift to move a coffee table.
>
> The reason is intentional: Snowflake is already part of my Data Engineering stack, so I wanted to use it to translate the conceptual and logical model into a physical implementation without introducing another platform solely for this exercise.
>
> The focus of this project is **relational data modeling**, not demonstrating Snowflake's analytical capabilities. In a production transactional application, a database such as PostgreSQL or SQL Server would likely be a more natural platform choice. The same model could also be adapted into a dimensional/analytical model if the objective were reporting and analytics.