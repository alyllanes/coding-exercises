/*
Using: bigquery-public-data.thelook_ecommerce
Top N Per Category with Window Functions
The marketing team wants to analyze the best-selling products. Using the orders and order_items tables, write a single SQL query to find the top 3 products by total sales price for each product category over the last 90 days.
- The output should include product_category, product_id, total_sales, and rank_in_category.
- You will need to join bigquery-public-data.thelook_ecommerce.orders and bigquery-public-data.thelook_ecommerce.order_items. The order_items table contains the sale price.
- The orders table contains the created_at timestamp. Use this to filter for the last 90 days.
*/

select * from `bigquery-public-data`.thelook_ecommerce.orders order by rand() limit 10;
select * from `bigquery-public-data`.thelook_ecommerce.order_items order by rand() limit 10;
select * from `bigquery-public-data`.thelook_ecommerce.products order by rand() limit 10;

with completed_orders as (
  select 
    order_id,
    date(created_at) as created_date
  from `bigquery-public-data`.thelook_ecommerce.orders
  where status = 'Complete' and created_at >= timestamp_sub(current_timestamp(), interval 90 day)
),

order_items as (
  select
    order_id,
    b.id as order_item_id,
    product_id,
    category as product_category,
    created_date,
    sale_price
  from completed_orders a
  left join `bigquery-public-data`.thelook_ecommerce.order_items b using(order_id)
  left join `bigquery-public-data`.thelook_ecommerce.products c on b.product_id = c.id
),

total_sales_last_90_days as (
  select
    product_id,
    product_category,
    sum(sale_price) as total_sales
  from order_items
  group by 1,2
),

rank_per_category as (
  select
    product_category,
    product_id,
    total_sales,
    rank() over (partition by product_category order by total_sales desc) as rank_in_category
  from total_sales_last_90_days
)

select * from rank_per_category
where rank_in_category <= 3
order by product_category, rank_in_category;
