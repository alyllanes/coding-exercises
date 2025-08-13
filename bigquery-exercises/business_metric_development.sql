/*
Business Metric Development
The business team wants to understand how effective their marketing campaigns are.
Define a business metric for conversion rate, where a conversion is a user who makes at least one purchase.
- Write a SQL query using bigquery-public-data.thelook_ecommerce.events and bigquery-public-data.thelook_ecommerce.orders that calculates this conversion rate. Your query should calculate the overall conversion rate, as well as the conversion rate broken down by traffic_source.
- Explain your transformation logic, including how you handle users who may have multiple orders.
*/

select * from `bigquery-public-data`.thelook_ecommerce.events order by rand() limit 10;
select * from `bigquery-public-data`.thelook_ecommerce.orders order by rand() limit 10;

with all_users_per_traffic_source as (
  select
    user_id,
    traffic_source
  from `bigquery-public-data`.thelook_ecommerce.events
  where user_id is not null
),

complete_order_per_user as (
  select
    user_id,
    1 as complete_order_flag
  from `bigquery-public-data`.thelook_ecommerce.orders
  where status = 'Complete'
),

joined as (
  select
    user_id,
    traffic_source,
    if(complete_order_flag is null, 0, complete_order_flag) as complete_order_flag
  from all_users_per_traffic_source
  left join complete_order_per_user using(user_id)
),

overall_conversion_rate as (
  select
    'Overall Conversion Rate' as conversion_rate_type,
    safe_divide(sum(complete_order_flag), count(user_id)) as conversion_rate
  from joined
),

conversion_rate_per_traffic_source as (
  select
    'Conversion Rate per Traffic Source' as conversion_rate_type,
    traffic_source,
    safe_divide(sum(complete_order_flag), count(user_id)) as conversion_rate
  from joined
  group by 2
)

select * from overall_conversion_rate;
select * from conversion_rate_per_traffic_source;
