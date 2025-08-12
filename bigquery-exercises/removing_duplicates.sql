-- Dataset: bigquery-public-data.cms_medicare.inpatient_charges_2011
-- 💡 Prompt:
-- Identify and remove duplicate records based on:
--  provider_id, drg_definition, total_discharges.
-- Only keep the row with the highest average total payments

select * from `bigquery-public-data.cms_medicare.inpatient_charges_2011` limit 10;

select * from `bigquery-public-data.cms_medicare.inpatient_charges_2011`
qualify 1=row_number() over (partition by provider_id, drg_definition, total_discharges order by average_total_payments desc);
