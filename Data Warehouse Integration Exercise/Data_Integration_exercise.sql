select * from employees_raw  limit 5;


select select emp_name, is_active
from employees_raw 
where is_active = false;


select emp_name, is_active
from employees_raw 
where is_active;


select 
	count(*) as total_employees,
	count(*) filter (where is_active = true) as active_employees
from
	employees_raw;


select * from customers_raw limit 3;


create or replace view vm_dim_Employees as
select
	id as employee_id,
	emp_name as "Full Name",
	department_code,
	joined_date
from
	employees_raw
where 
	is_active = true;



select * from vm_dim_employees;




CREATE OR REPLACE VIEW vw_dim_Customers AS
SELECT 
	cust_id, company_name, city, country 
FROM 
	customers_raw;



select * from vw_dim_customers;



CREATE OR REPLACE VIEW vw_fct_Sales AS
SELECT
    order_id AS "Order ID",
    employee_id AS "Employee ID",
    customer_id AS "Customer ID",
    amount AS "Amount",
    order_date AS "Date",
    status AS "Status"
FROM sales_raw;



select * from vw_fct_sales;



INSERT INTO sales_raw (employee_id, customer_id, amount, order_date, status) 
VALUES (1, 1, 10000.00, CURRENT_DATE, 'Completed');


select * from sales_raw;