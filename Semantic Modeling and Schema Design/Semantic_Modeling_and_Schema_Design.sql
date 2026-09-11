create or replace view vw_fct_returns as 
select
	return_id,
	order_id,
	employee_id,
	customer_id,
	return_date,
	reason
from 
	returns_raw;