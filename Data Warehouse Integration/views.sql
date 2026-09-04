select * from customers_raw;

CREATE or replace view vw_dim_customers as
select
	cust_id,
	company_name,
	city,
	country
from customers_raw;

select * from vw_dim_customers;


select * from employees_raw;

create or replace view vw_dim_employees as
select
	id as employee_id,
	emp_name as "Full Name",
	department_code,
	joined_date
from employees_raw
where is_active = true;

select * from vw_dim_employees;

create or replace view vw_fct_sales as
select
	order_id,
	employee_id,
	customer_id,
	amount,
	order_date,
	status
from sales_raw
where status = 'Completed';

select * from vw_fct_sales;

create or replace view vw_fct_returns as
select
	return_id,
	order_id,
	return_date,
	reason
from returns_raw;

select * from vw_fct_returns;