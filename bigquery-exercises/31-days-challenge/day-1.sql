-- Retrieve the top 5 most popular names in the US during the years 2010 and 2019 using the publicly available table  `bigquery-public-data.usa_names.usa_1910_current`.
select 
  name, 
  sum(number) as total_number
from `bigquery-public-data`.usa_names.usa_1910_current 
where year between 2010 and 2019
group by 1 
order by total_number desc
limit 5; 
