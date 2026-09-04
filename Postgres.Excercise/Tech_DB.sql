-- 1. CLEANUP (Започваме на чисто - трием всичко в правилния ред)
DROP VIEW IF EXISTS vw_dim_employees;
DROP VIEW IF EXISTS vw_dim_customers;
DROP VIEW IF EXISTS vw_fct_sales;
DROP VIEW IF EXISTS vw_fct_returns;

DROP TABLE IF EXISTS sales_raw;
DROP TABLE IF EXISTS returns_raw;
DROP TABLE IF EXISTS employees_raw;
DROP TABLE IF EXISTS customers_raw;

-- ========================================================
-- 2. CREATE TABLES (The "Messy" Raw Layer)
-- ========================================================

-- TABLE 1: EMPLOYEES (Dimension)
-- Problems to fix in PBI/Views:
-- 1. 'emp_name' needs renaming to 'Full Name'.
-- 2. 'salary' & 'ssn' are SENSITIVE (Hide them!).
-- 3. 'is_active' needs filtering (Remove inactive).
CREATE TABLE employees_raw (
    id SERIAL PRIMARY KEY,
    emp_name VARCHAR(100),       
    department_code VARCHAR(50), 
    salary DECIMAL(10,2),        -- ⚠️ SENSITIVE
    ssn VARCHAR(20),             -- ⚠️ SENSITIVE
    is_active BOOLEAN,           -- Filter Logic
    joined_date DATE
);

-- TABLE 2: CUSTOMERS (Dimension)
-- Problems to fix:
-- 1. 'contact_email' is GDPR sensitive (Hide in View).
-- 2. 'city' is used for Geography filtering.
CREATE TABLE customers_raw (
    cust_id SERIAL PRIMARY KEY,
    company_name VARCHAR(100),
    contact_email VARCHAR(100),  -- ⚠️ GDPR
    city VARCHAR(50),
    country VARCHAR(50)
);

-- TABLE 3: SALES (Fact Table 1)
-- Transactional data. Connects to Emp and Cust.
CREATE TABLE sales_raw (
    order_id SERIAL PRIMARY KEY,
    employee_id INT, -- Foreign Key to Employees
    customer_id INT, -- Foreign Key to Customers
    amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20) -- 'Completed', 'Refunded'
);

-- TABLE 4: RETURNS (Fact Table 2) - **NEW for Lecture 3**
-- Shows how two Fact tables share the same Dimensions.
CREATE TABLE returns_raw (
    return_id SERIAL PRIMARY KEY,
    order_id INT,    -- Link to original order
    employee_id INT, -- Who processed it
    customer_id INT, -- Who returned it
    return_date DATE,
    reason VARCHAR(50) -- 'Defect', 'Wrong Item'
);

-- ========================================================
-- 3. INSERT DATA (Dummy Data Generation)
-- ========================================================

-- Employees
INSERT INTO employees_raw (emp_name, department_code, salary, ssn, is_active, joined_date) VALUES 
('Ivan Ivanov', 'SALES', 2500.00, '8801011234', true, '2020-01-15'),
('Maria Petrova', 'IT', 4800.00, '9205059876', true, '2021-03-10'),
('Georgi Georgiev', 'HR', 1800.00, '8502025555', false, '2019-05-20'), -- Inactive User
('Elena Stoyanova', 'SALES', 2700.00, '9503031111', true, '2022-08-01'),
('Peter Dimitrov', 'IT', 1500.00, '0001012222', true, '2023-11-05');

-- Customers
INSERT INTO customers_raw (company_name, contact_email, city, country) VALUES
('Tech Solutions Ltd', 'contact@techsol.bg', 'Sofia', 'Bulgaria'),
('Global Trade Corp', 'info@globaltrade.com', 'Plovdiv', 'Bulgaria'),
('StartUp Hub', 'admin@startup.io', 'Varna', 'Bulgaria'),
('Berlin Motors', 'hans@berlin-motors.de', 'Berlin', 'Germany');

-- Sales
INSERT INTO sales_raw (employee_id, customer_id, amount, order_date, status) VALUES 
(1, 1, 1200.50, '2023-10-01', 'Completed'), -- Ivan sold to Tech Solutions
(1, 2, 350.00, '2023-10-05', 'Completed'),  -- Ivan sold to Global Trade
(2, 1, 5000.00, '2023-10-06', 'Completed'), -- Maria sold to Tech Solutions
(4, 3, 250.00, '2023-10-07', 'Refunded'),   -- Elena sold to StartUp Hub (Will be returned)
(1, 4, 100.00, '2023-10-08', 'Completed');  -- Ivan sold to Berlin

-- Returns (Linked to dimensions)
INSERT INTO returns_raw (order_id, employee_id, customer_id, return_date, reason) VALUES
(4, 4, 3, '2023-10-09', 'Defect'),      -- Return for the Refunded order above
(2, 1, 2, '2023-10-10', 'Wrong Item');  -- Partial return for order 2

-- ========================================================
-- 4. VERIFY CONTENT
-- ========================================================
SELECT 'Employees' as table_name, count(*) as rows FROM employees_raw
UNION ALL
SELECT 'Customers', count(*) FROM customers_raw
UNION ALL
SELECT 'Sales', count(*) FROM sales_raw
UNION ALL
SELECT 'Returns', count(*) FROM returns_raw;