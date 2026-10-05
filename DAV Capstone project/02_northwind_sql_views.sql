CREATE OR REPLACE VIEW v_Product_Enriched AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    s.company_name AS supplier,
    p.unit_price
FROM products AS p
LEFT JOIN categories AS c
    ON p.category_id = c.category_id
LEFT JOIN suppliers AS s
    ON p.supplier_id = s.supplier_id; -- I use left join because some products may not have a category or supplier, and I want to include those products in the view as well.


-- view checks
SELECT *
FROM v_Product_Enriched
ORDER BY product_id;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products
FROM v_Product_Enriched;




CREATE OR REPLACE VIEW v_Order_Sales AS
SELECT
    o.order_id,
    o.customer_id,
    o.employee_id,
    o.order_date,
    o.required_date,
    o.shipped_date,
    o.ship_via,
    od.product_id,
    od.unit_price,
    od.quantity,
    od.discount,
    od.unit_price * od.quantity * (1 - od.discount) AS total_line_amount
FROM orders AS o
INNER JOIN order_details AS od
    ON o.order_id = od.order_id;

--- view checks
SELECT *
FROM v_Order_Sales
ORDER BY order_id, product_id
LIMIT 20;

SELECT COUNT(*)
FROM v_Order_Sales;

SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_line_amount) AS total_revenue
FROM v_Order_Sales;




CREATE OR REPLACE VIEW v_Customer_Geo AS
SELECT
    c.customer_id,
    c.company_name,
    c.city,
    c.country
FROM customers AS c
WHERE EXISTS (
    SELECT 1
    FROM orders AS o
    WHERE o.customer_id = c.customer_id
); -- I use EXISTS to filter customers that have at least one order, as I want to focus on active customers for the analysis.


--- view checks
SELECT *
FROM v_Customer_Geo
ORDER BY country, company_name;

SELECT COUNT(*)
FROM v_Customer_Geo;


-- final validation of the views
SELECT COUNT(*) AS products
FROM v_Product_Enriched
UNION ALL
SELECT COUNT(*) AS sales_lines
FROM v_Order_Sales
UNION ALL
SELECT COUNT(*) AS active_customers
FROM v_Customer_Geo;

SELECT
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(total_line_amount)::numeric, 2) AS revenue
FROM v_Order_Sales;

