/*
Dimensional Modeling
Design a dimensional model for the e-commerce sales data using the thelook_ecommerce dataset.
- Identify the central fact table and a minimum of three dimension tables.
- Provide the dbt models code (just the SQL, not the full project structure) for one of your dimension tables. The model should include a primary key, use a surrogate key if appropriate, and contain relevant attributes.
- Explain your choice of key and the benefits of this dimensional design for analytics and reporting.
*/

-- fact tables since it contains the sales data and each transaction
-- fct_orders
select * from `bigquery-public-data`.thelook_ecommerce.orders order by rand() limit 10;
select * from `bigquery-public-data`.thelook_ecommerce.order_items order by rand() limit 10; 

-- dimension models
-- dim_products, dim_users, and dim_inventory_items
select * from `bigquery-public-data`.thelook_ecommerce.products order by rand() limit 10; 
select * from `bigquery-public-data`.thelook_ecommerce.users order by rand() limit 10;
select * from `bigquery-public-data`.thelook_ecommerce.inventory_items order by rand() limit 10;

-- dimension model sample code
with import_source as (
  select * from `bigquery-public-data`.thelook_ecommerce.products
),

add_surrogate_key as (
  select
    sha256(cast(id as string)) as surrogate_key,
    id as product_id, -- natural key
    cost,
    category,
    name,
    brand,
    retail_price,
    department,
    sku,
    distribution_center_id
  from import_source
)

select * from add_surrogate_key
;
