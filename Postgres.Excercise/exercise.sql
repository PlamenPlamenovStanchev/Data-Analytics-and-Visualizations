SELECT * FROM employees_raw;

SELECT emp_name, department_code FROM employees_raw;

SELECT * FROM customers_raw
WHERE city = 'Sofia';

SELECT * FROM sales_raw
ORDER BY order_date
LIMIT 3;

SELECT * FROM employees_raw
WHERE is_active = true;

SELECT * FROM employees_raw
WHERE department_code = 'SALES';

SELECT * FROM sales_raw
WHERE amount > 1000;

SELECT * FROM customers_raw
WHERE country = 'Bulgaria' OR country = 'Germany';

SELECT * FROM customers_raw
WHERE country IN ('Bulgaria', 'Germany');

SELECT * FROM employees_raw
WHERE salary BETWEEN 2000 AND 3000;

SELECT * FROM employees_raw
WHERE salary >= 2000 AND salary <= 3000;

SELECT * FROM sales_raw
WHERE order_date >= '2023-10-01'
  AND order_date < '2023-11-01';


SELECT * FROM sales_raw
WHERE order_date BETWEEN '2023-10-01' AND '2023-10-31';

SELECT * FROM sales_raw
WHERE EXTRACT(YEAR FROM order_date) = 2023
  AND EXTRACT(MONTH FROM order_date) = 10;

SELECT SUM(amount) as total_sales FROM sales_raw;

SELECT COUNT(*) as total_customers FROM customers_raw;

SELECT COUNT(cust_id) as total_customers FROM customers_raw;

SELECT SUM(amount) as completed_sales
FROM sales_raw
WHERE status = 'Completed';

SELECT employee_id, COUNT(*) as sales_count
FROM sales_raw
GROUP BY employee_id
ORDER BY sales_count DESC;

SELECT AVG(salary) as average_salary FROM employees_raw;

SELECT ROUND(AVG(salary), 2) as average_salary FROM employees_raw;

SELECT
    MAX(amount) as highest_sale,
    MIN(amount) as lowest_sale
FROM sales_raw;

SELECT
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    AVG(amount) as monthly_average
FROM sales_raw
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

SELECT
    DATE_TRUNC('month', order_date) as month,
    AVG(amount) as monthly_average
FROM sales_raw
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;

SELECT
    department_code,
    AVG(salary) as avg_salary,
    COUNT(*) as employee_count
FROM employees_raw
WHERE is_active = true
GROUP BY department_code
ORDER BY avg_salary DESC;

SELECT
    department_code,
    AVG(salary) as avg_salary
FROM employees_raw
WHERE is_active = true
GROUP BY department_code
HAVING AVG(salary) > 2500;

SELECT
    employee_id,
    COUNT(*) as sales_count
FROM sales_raw
GROUP BY employee_id
HAVING COUNT(*) > 1;

SELECT
    e.emp_name,
    COUNT(s.order_id) as sales_count
FROM employees_raw e
INNER JOIN sales_raw s ON e.id = s.employee_id
GROUP BY e.emp_name
HAVING COUNT(s.order_id) > 1;

SELECT
    city,
    COUNT(*) as customer_count
FROM customers_raw
GROUP BY city
HAVING COUNT(*) > 1;

SELECT
    s.order_id,
    s.amount,
    s.order_date,
    e.emp_name
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id;

SELECT
    s.order_id,
    s.amount,
    s.order_date,
    e.emp_name as employee_name,
    c.company_name as customer_name
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
INNER JOIN customers_raw c ON s.customer_id = c.cust_id;

SELECT
    s.order_id,
    s.amount,
    e.emp_name,
    e.department_code
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
WHERE e.department_code = 'SALES';

SELECT
    r.return_id,
    r.return_date,
    r.reason,
    c.company_name
FROM returns_raw r
INNER JOIN customers_raw c ON r.customer_id = c.cust_id;

SELECT
    e.emp_name,
    s.order_id,
    s.amount
FROM employees_raw e
LEFT JOIN sales_raw s ON e.id = s.employee_id
ORDER BY e.emp_name;

SELECT
    c.company_name,
    s.order_id,
    s.amount
FROM customers_raw c
LEFT JOIN sales_raw s ON c.cust_id = s.customer_id
ORDER BY c.company_name;

SELECT
    e.emp_name,
    e.department_code
FROM employees_raw e
LEFT JOIN sales_raw s ON e.id = s.employee_id
WHERE s.employee_id IS NULL;

SELECT
    e.emp_name,
    SUM(s.amount) as total_sales
FROM employees_raw e
INNER JOIN sales_raw s ON e.id = s.employee_id
GROUP BY e.emp_name
ORDER BY total_sales DESC
LIMIT 3;

SELECT
    c.company_name,
    COUNT(s.order_id) as order_count
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
GROUP BY c.company_name
ORDER BY order_count DESC;

SELECT
    c.company_name,
    COUNT(s.order_id) as order_count
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
GROUP BY c.company_name
HAVING COUNT(s.order_id) = (
    SELECT MAX(order_count) FROM (
        SELECT COUNT(s2.order_id) as order_count
        FROM customers_raw c2
        INNER JOIN sales_raw s2 ON c2.cust_id = s2.customer_id
        GROUP BY c2.company_name
    ) max_orders
);

SELECT
    e.department_code,
    DATE_TRUNC('month', s.order_date) as month,
    SUM(s.amount) as monthly_sales
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
GROUP BY e.department_code, DATE_TRUNC('month', s.order_date)
ORDER BY month, e.department_code;

SELECT
    r.return_date,
    r.order_id as original_order,
    c.company_name as customer,
    r.reason,
    s.amount as original_amount
FROM returns_raw r
INNER JOIN customers_raw c ON r.customer_id = c.cust_id
INNER JOIN sales_raw s ON r.order_id = s.order_id;

SELECT
    emp_name,
    salary
FROM employees_raw
WHERE salary > (SELECT AVG(salary) FROM employees_raw)
ORDER BY salary DESC;

SELECT DISTINCT
    c.company_name,
    c.city
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
WHERE s.amount > (SELECT AVG(amount) FROM sales_raw);

SELECT
    s.order_id,
    s.amount,
    s.order_date,
    e.emp_name,
    e.salary
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
WHERE e.salary = (SELECT MAX(salary) FROM employees_raw);


SELECT
    c.city,
    COUNT(s.order_id) as total_orders,
    SUM(s.amount) as total_sales,
    AVG(s.amount) as avg_order_value
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
GROUP BY c.city
ORDER BY total_sales DESC;


SELECT
    e.department_code,
    SUM(s.amount) as total_sales
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
GROUP BY e.department_code
ORDER BY total_sales DESC
LIMIT 1;

SELECT
    e.department_code,
    SUM(s.amount) as total_sales
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
GROUP BY e.department_code
HAVING SUM(s.amount) = (
    SELECT MAX(dept_sales) FROM (
        SELECT SUM(s2.amount) as dept_sales
        FROM sales_raw s2
        INNER JOIN employees_raw e2 ON s2.employee_id = e2.id
        GROUP BY e2.department_code
    ) department_totals
);

SELECT
    e.department_code,
    COUNT(DISTINCT e.id) as employee_count,
    AVG(e.salary) as avg_salary,
    COALESCE(SUM(s.amount), 0) as total_sales
FROM employees_raw e
LEFT JOIN sales_raw s ON e.id = s.employee_id
WHERE e.is_active = true
GROUP BY e.department_code
ORDER BY total_sales DESC;

SELECT
    order_date,
    COUNT(*) as daily_orders,
    SUM(amount) as daily_sales
FROM sales_raw
WHERE order_date >= '2023-10-01'
  AND order_date < '2023-11-01'
GROUP BY order_date
ORDER BY order_date;

WITH date_series AS (
    SELECT generate_series(
        '2023-10-01'::date,
        '2023-10-31'::date,
        '1 day'::interval
    )::date as date_value
)
SELECT ds.date_value as missing_date
FROM date_series ds
LEFT JOIN sales_raw s ON ds.date_value = s.order_date
WHERE s.order_date IS NULL;

SELECT
    current_date - interval '1 day' * s.day_offset as missing_date
FROM generate_series(0, 30) s(day_offset)
WHERE (current_date - interval '1 day' * s.day_offset) NOT IN (
    SELECT DISTINCT order_date FROM sales_raw
    WHERE order_date >= '2023-10-01' AND order_date <= '2023-10-31'
);

SELECT
    dates.date_value,
    COALESCE(s.daily_sales, 0) as sales,
    COALESCE(r.daily_returns, 0) as returns,
    COALESCE(s.daily_sales, 0) - COALESCE(r.daily_returns, 0) as net_sales
FROM (
    SELECT DISTINCT order_date as date_value FROM sales_raw
    UNION
    SELECT DISTINCT return_date FROM returns_raw
) dates
LEFT JOIN (
    SELECT order_date, COUNT(*) as order_count, SUM(amount) as daily_sales
    FROM sales_raw
    GROUP BY order_date
) s ON dates.date_value = s.order_date
LEFT JOIN (
    SELECT return_date, COUNT(*) as return_count,
           SUM((SELECT amount FROM sales_raw WHERE order_id = returns_raw.order_id)) as daily_returns
    FROM returns_raw
    GROUP BY return_date
) r ON dates.date_value = r.return_date
ORDER BY dates.date_value;

WITH department_stats AS (
    SELECT
        e.department_code,
        COUNT(DISTINCT e.id) as employee_count,
        COALESCE(SUM(s.amount), 0) as total_sales
    FROM employees_raw e
    LEFT JOIN sales_raw s ON e.id = s.employee_id
    WHERE e.is_active = true
    GROUP BY e.department_code
),
return_stats AS (
    SELECT
        e.department_code,
        COUNT(r.return_id) as return_count,
        SUM(s.amount) as returned_amount
    FROM returns_raw r
    INNER JOIN sales_raw s ON r.order_id = s.order_id
    INNER JOIN employees_raw e ON r.employee_id = e.id
    GROUP BY e.department_code
),
top_customers AS (
    SELECT
        c.company_name,
        SUM(s.amount) as total_spent,
        ROW_NUMBER() OVER (ORDER BY SUM(s.amount) DESC) as rank
    FROM customers_raw c
    INNER JOIN sales_raw s ON c.cust_id = s.customer_id
    GROUP BY c.company_name
)
SELECT
    ds.department_code,
    ds.employee_count,
    ds.total_sales,
    ROUND(
        COALESCE(rs.return_count::numeric / NULLIF(
            (SELECT COUNT(*) FROM sales_raw s2
             INNER JOIN employees_raw e2 ON s2.employee_id = e2.id
             WHERE e2.department_code = ds.department_code), 0
        ) * 100, 0), 2
    ) as return_percentage,
    (SELECT STRING_AGG(company_name || ' (' || total_spent || ')', ', ')
     FROM top_customers WHERE rank <= 3) as top_3_customers
FROM department_stats ds
LEFT JOIN return_stats rs ON ds.department_code = rs.department_code
ORDER BY ds.total_sales DESC;

SELECT
    e.emp_name,
    COUNT(DISTINCT s.order_id) as sales_count,
    COUNT(DISTINCT r.return_id) as returns_processed
FROM employees_raw e
INNER JOIN sales_raw s ON e.id = s.employee_id
INNER JOIN returns_raw r ON e.id = r.employee_id
GROUP BY e.emp_name
ORDER BY sales_count DESC, returns_processed DESC;

SELECT
    e.emp_name,
    (SELECT COUNT(*) FROM sales_raw s WHERE s.employee_id = e.id) as sales_count,
    (SELECT COUNT(*) FROM returns_raw r WHERE r.employee_id = e.id) as returns_count
FROM employees_raw e
WHERE EXISTS (SELECT 1 FROM sales_raw s WHERE s.employee_id = e.id)
  AND EXISTS (SELECT 1 FROM returns_raw r WHERE r.employee_id = e.id);

SELECT
    c.company_name,
    c.city,
    c.contact_email,
    COUNT(DISTINCT s.order_id) as total_orders,
    COUNT(DISTINCT r.return_id) as total_returns,
    ROUND(
        COUNT(DISTINCT r.return_id)::numeric /
        COUNT(DISTINCT s.order_id) * 100, 2
    ) as return_rate_percent,
    SUM(s.amount) as total_spent,
    SUM(CASE WHEN r.return_id IS NOT NULL THEN s.amount ELSE 0 END) as returned_amount,
    STRING_AGG(DISTINCT r.reason, ', ') as return_reasons
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
LEFT JOIN returns_raw r ON s.order_id = r.order_id
GROUP BY c.cust_id, c.company_name, c.city, c.contact_email
HAVING COUNT(DISTINCT r.return_id) > 0
ORDER BY return_rate_percent DESC, total_returns DESC;



