DROP VIEW IF EXISTS vw_fct_sales; 


CREATE OR REPLACE VIEW vw_fct_sales AS
SELECT
    order_id,
    employee_id,
    customer_id,
    amount,
    amount * 0.8 AS "Total Cost",
    order_date,
    status
FROM sales_raw
WHERE status = 'Completed';