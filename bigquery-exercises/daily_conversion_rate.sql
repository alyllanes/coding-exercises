-- Dataset: bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*
-- 💡 Prompt:
-- Calculate daily conversion rate: users who made a purchase / users who started a session per day.

select * from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` limit 10;

select distinct event_name,from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;

with count_user_start_session as (
  select 
    event_date, 
    count(distinct user_pseudo_id) as count_users_started_session 
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where event_name = 'session_start'
  group by 1
),

count_user_purchase as (
  select
    event_date,
    count(distinct user_pseudo_id) as count_users_purchased
  from `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  where event_name = 'purchase'
  group by 1
),

daily_conversion_rate as (
  select
    event_date,
    safe_divide(count_users_purchased, count_users_started_session) as daily_conversion_rate
  from count_user_start_session
  left join count_user_purchase using(event_date)
)

select * from daily_conversion_rate limit 10;

