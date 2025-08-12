-- https://www.hackerrank.com/challenges/the-pads/problem
select
    concat(name, '(', upper(left(occupation, 1)), ')')
from occupations
order by name;

select 
    concat('There are a total of ', occupation_count, ' ', occupation, 's.') 
from (
    select
        lower(occupation) as occupation,
        count(Name) as occupation_count
    from occupations
    group by 1
    ) a
order by occupation_count, occupation;
