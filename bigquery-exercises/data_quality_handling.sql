/*
Data Quality Handling
The events table contains customer clickstream data. You've noticed that for some sessions, a single user_id and session_id combination has multiple entries for the same event_type that occurred at slightly different timestamps. The correct record is the one with the earliest timestamp.
- Write a query on the bigquery-public-data.thelook_ecommerce.events table to return a clean dataset. For each unique combination of user_id, session_id, and event_type, keep only the row with the minimum created_at timestamp.
- Return a dataset that includes user_id, session_id, event_type, created_at, and traffic_source.
*/

select * from `bigquery-public-data`.thelook_ecommerce.events order by rand() limit 10;

select
  user_id,
  session_id,
  event_type,
  created_at, 
  traffic_source
from `bigquery-public-data`.thelook_ecommerce.events
qualify 1=row_number() over (partition by user_id, session_id, event_type order by created_at);
-- did not filter null users just incase there are also anonymous sessions that will be analyzed
-- but if ever, an additional WHERE clause can be added to remove the null user IDs 
