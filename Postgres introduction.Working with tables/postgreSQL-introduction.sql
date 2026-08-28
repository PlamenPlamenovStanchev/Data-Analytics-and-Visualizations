create table test()

select * from sales_raw


select * 
from 
	sales_raw 
where 
	amount>=350


select 
	sum(amount) 
from 
	sales_raw 
where 
	customer_id = 1

	
select 
	avg(amount)
from 
	sales_raw
	
	

select 
	customer_id,
	max(amount) 
from 
	sales_raw 
group by 
	customer_id
	
	

select 
	customer_id,
	sum(amount) 
from 
	sales_raw 
group by 
	customer_id 
order by
	customer_id
	
	

select 
	customer_id,
	sum(amount) 
from 
	sales_raw 
group by
	customer_id 
having 
	sum(amount)<600 
order by
	customer_id
	
	
select 
	c.company_name,
	s.order_id,
	s.amount
from 
	customers_raw c
inner join 
	sales_raw s
on 
	c.cust_id = s.customer_id
	
	
select 
	c.company_name,
	s.order_id,
	s.amount
from 
	customers_raw c
left join 
	sales_raw s
on 
	c.cust_id = s.customer_id


	
select 
	c.company_name,
	s.order_id,
	s.amount
from 
	customers_raw c
right join 
	sales_raw s
on 
	c.cust_id = s.customer_id
	
	

	
select 
	c.company_name,
	s.order_id,
	s.amount
from 
	customers_raw c
full outer join 
	sales_raw s
on 
	c.cust_id = s.customer_id
	

	
select 
	c.company_name,
	s.order_id
from 
	customers_raw c
cross join
	sales_raw s


	