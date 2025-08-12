-- Dataset: bigquery-public-data.stackoverflow.posts_questions
-- 💡 Prompt:
-- Find the top 5 most common tags from questions posted in 2020.

with import_data as (
  select
    id,
    unnested_list
  from `bigquery-public-data`.stackoverflow.posts_questions,
  unnest(split(tags, '|')) as unnested_list
  where extract(YEAR from creation_date) = 2020
)

select 
  unnested_list, 
  count(id) as total_count
from import_data
group by 1
order by total_count desc
limit 5;
