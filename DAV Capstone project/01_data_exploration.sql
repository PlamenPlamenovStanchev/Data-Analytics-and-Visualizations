-- Initial exploration of the database tables

SELECT * FROM orders LIMIT 10;

SELECT * FROM order_details LIMIT 10;

SELECT * FROM products LIMIT 10;

SELECT * FROM categories LIMIT 10;

SELECT * FROM customers LIMIT 10;

SELECT * FROM employees LIMIT 10;

SELECT * FROM shippers LIMIT 10;

SELECT * FROM suppliers LIMIT 10;


-- Advanced exploration of the database tables

-- 1. Order date range
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date
FROM orders;


-- 2. Orders that have not been shipped
SELECT
    COUNT(*) AS orders_without_shipping_date
FROM orders
WHERE shipped_date IS NULL;


-- 3. Number of customers that actually have orders
SELECT
    COUNT(DISTINCT customer_id) AS active_customers
FROM orders;


-- 4. Customer countries
SELECT
    country,
    COUNT(*) AS customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC, country;


-- 5. Check discounts in order_details
SELECT
    discount,
    COUNT(*) AS rows_count
FROM order_details
GROUP BY discount
ORDER BY discount;


-- 6. Basic sales sanity check
SELECT
    SUM(unit_price * quantity * (1 - discount)) AS total_revenue
FROM order_details;


-- 7. Orders and their number of line items
SELECT
    order_id,
    COUNT(*) AS line_items
FROM order_details
GROUP BY order_id
ORDER BY line_items DESC
LIMIT 10;


-- 8. Product/category/supplier relationship
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
    ON p.supplier_id = s.supplier_id
ORDER BY p.product_id
LIMIT 20;