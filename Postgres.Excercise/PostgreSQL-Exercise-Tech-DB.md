# УПРАЖНЕНИЯ ПО SQL - Tech Database
**Време за изпълнение: 2.5 часа**
**Инструмент: DBeaver + PostgreSQL**

## ЧАСТ 1: ОСНОВНИ SELECT ЗАЯВКИ (30 мин)

### 1.1 Простии SELECT заявки (10 мин)

**1. Покажете всички служители от таблицата employees_raw**

```sql
SELECT * FROM employees_raw;
```
**Обяснение:** Най-простата SQL заявка. `*` означава "всички колони".
**Подход:** Винаги започвайте с прост SELECT за да разберете структурата на данните.
**⚠️ Внимание:** В реални системи избягвайте `SELECT *` заради производителността.

---

**2. Покажете само имената и отделите на служителите**

```sql
SELECT emp_name, department_code FROM employees_raw;
```
**Обяснение:** Избиране на конкретни колони вместо всички.
**Подход:** Винаги посочвайте точно колоните които ви трябват.
**Учебна цел:** Разбиране на проекция в релационни бази данни.

---

**3. Покажете всички клиенти от София**

```sql
SELECT * FROM customers_raw
WHERE city = 'Sofia';
```
**Обяснение:** WHERE клауза филтрира редове по условие.
**⚠️ Внимание:** Стринговете в SQL се слагат в единични кавички `'Sofia'`, не в двойни!
**Подход:** Винаги използвайте точното име на града както е записано в базата.

---

**4. Покажете първите 3 продажби по дата**

```sql
SELECT * FROM sales_raw
ORDER BY order_date
LIMIT 3;
```
**Обяснение:** `ORDER BY` сортира, `LIMIT` ограничава броя резултати.
**Подход:** При работа с дати винаги сортирайте преди да ограничите резултатите.
**Учебна цел:** Разбиране на сортиране и ограничаване на резултати.

### 1.2 WHERE клаузи (20 мин)

**5. Намерете всички активни служители (is_active = true)**

```sql
SELECT * FROM employees_raw
WHERE is_active = true;
```
**Обяснение:** Филтриране по булева стойност.
**Подход:** В PostgreSQL можете да пишете `is_active = true` или просто `is_active`.
**Алтернатива:** `WHERE is_active` е същото като `WHERE is_active = true`.

---

**6. Покажете служителите от отдел 'SALES'**

```sql
SELECT * FROM employees_raw
WHERE department_code = 'SALES';
```
**Обяснение:** Филтриране по текстова стойност.
**⚠️ Внимание:** SQL е case-sensitive за данни! 'SALES' ≠ 'sales' ≠ 'Sales'.
**Подход:** Винаги проверявайте точния формат на данните в таблицата.

---

**7. Намерете всички продажби над 1000 лева**

```sql
SELECT * FROM sales_raw
WHERE amount > 1000;
```
**Обяснение:** Числови сравнения с оператори >, <, >=, <=.
**Подход:** При числови данни не слагайте кавички около стойностите.
**Учебна цел:** Разбиране на числови сравнения в SQL.

---

**8. Покажете клиентите от България И Германия**

```sql
SELECT * FROM customers_raw
WHERE country = 'Bulgaria' OR country = 'Germany';

-- Алтернативен начин:
SELECT * FROM customers_raw
WHERE country IN ('Bulgaria', 'Germany');
```
**Обяснение:** Логически оператори OR и IN за множество стойности.
**Подход:** `IN` е по-четлив при повече от 2 стойности.
**⚠️ Внимание:** AND означава "и двете условия", OR означава "едно или другото".

---

**9. Намерете служителите с заплата между 2000 и 3000 лева**

```sql
SELECT * FROM employees_raw
WHERE salary BETWEEN 2000 AND 3000;

-- Алтернативен начин:
SELECT * FROM employees_raw
WHERE salary >= 2000 AND salary <= 3000;
```
**Обяснение:** `BETWEEN` включва граничните стойности (2000 и 3000).
**Подход:** `BETWEEN` е по-четлив от комбинация от >= и <=.
**Учебна цел:** Разбиране на обхвати в SQL.

---

**10. Покажете продажбите от октомври 2023**

```sql
SELECT * FROM sales_raw
WHERE order_date >= '2023-10-01'
  AND order_date < '2023-11-01';

-- Алтернативни начини:
SELECT * FROM sales_raw
WHERE order_date BETWEEN '2023-10-01' AND '2023-10-31';

SELECT * FROM sales_raw
WHERE EXTRACT(YEAR FROM order_date) = 2023
  AND EXTRACT(MONTH FROM order_date) = 10;
```
**Обяснение:** Работа с дати - винаги използвайте формат 'YYYY-MM-DD'.
**⚠️ Внимание:** BETWEEN '2023-10-01' AND '2023-10-31' включва и часа 00:00:00 на 31-ви.
**Подход:** За месец е по-безопасно да използвате >= и < с първия ден от следващия месец.

## ЧАСТ 2: АГРЕГАТНИ ФУНКЦИИ (40 мин)

### 2.1 SUM и COUNT (15 мин)

**11. Пресметнете общата сума на всички продажби**

```sql
SELECT SUM(amount) as total_sales FROM sales_raw;
```
**Обяснение:** `SUM()` събира всички стойности от дадена колона.
**Подход:** Винаги давайте псевдоним (alias) на агрегатни резултати с `AS`.
**Учебна цел:** Въведение в агрегатни функции.

---

**12. Колко общо клиента има в базата данни?**

```sql
SELECT COUNT(*) as total_customers FROM customers_raw;

-- Алтернатива:
SELECT COUNT(cust_id) as total_customers FROM customers_raw;
```
**Обяснение:** `COUNT(*)` брои всички редове, `COUNT(колона)` игнорира NULL стойности.
**Подход:** За броене на редове използвайте `COUNT(*)`.
**⚠️ Внимание:** `COUNT(колона)` може да даде различен резултат ако има NULL стойности!

---

**13. Каква е общата сума на продажбите със статус 'Completed'?**

```sql
SELECT SUM(amount) as completed_sales
FROM sales_raw
WHERE status = 'Completed';
```
**Обяснение:** Комбиниране на WHERE филтър с агрегатна функция.
**Подход:** Първо филтрирайте данните, после прилагайте агрегацията.
**Учебна цел:** WHERE се изпълнява преди агрегатните функции.

---

**14. Колко продажби има всеки служител? (използвайте COUNT и GROUP BY)**

```sql
SELECT employee_id, COUNT(*) as sales_count
FROM sales_raw
GROUP BY employee_id
ORDER BY sales_count DESC;
```
**Обяснение:** `GROUP BY` групира редовете по стойности, след което прилага агрегация.
**⚠️ Внимание:** Всяка колона в SELECT (освен агрегатните) ТРЯБВА да е в GROUP BY!
**Подход:** Винаги сортирайте резултатите за по-добра четливост.

### 2.2 AVG, MIN, MAX (15 мин)

**15. Каква е средната заплата на служителите?**

```sql
SELECT AVG(salary) as average_salary FROM employees_raw;

-- По-четливо форматиране:
SELECT ROUND(AVG(salary), 2) as average_salary FROM employees_raw;
```
**Обяснение:** `AVG()` изчислява средната аритметична стойност.
**Подход:** Използвайте `ROUND()` за по-четливи резултати с пари.
**Учебна цел:** Агрегатните функции игнорират NULL стойности.

---

**16. Намерете най-голямата и най-малката продажба**

```sql
SELECT
    MAX(amount) as highest_sale,
    MIN(amount) as lowest_sale
FROM sales_raw;
```
**Обяснение:** Можете да комбинирате множество агрегатни функции в една заявка.
**Подход:** Винаги давайте смислени имена на колоните.
**Учебна цел:** Една заявка може да има много агрегатни функции.

---

**17. Каква е средната стойност на продажбите за всеки месец?**

```sql
SELECT
    EXTRACT(YEAR FROM order_date) as year,
    EXTRACT(MONTH FROM order_date) as month,
    AVG(amount) as monthly_average
FROM sales_raw
GROUP BY EXTRACT(YEAR FROM order_date), EXTRACT(MONTH FROM order_date)
ORDER BY year, month;

-- Алтернативен начин с DATE_TRUNC:
SELECT
    DATE_TRUNC('month', order_date) as month,
    AVG(amount) as monthly_average
FROM sales_raw
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY month;
```
**Обяснение:** Извличане на части от дати за групиране.
**⚠️ Внимание:** При групиране по дати, всички части които извличате трябва да са в GROUP BY.
**Подход:** `DATE_TRUNC` е по-елегантен начин за работа с периоди.

---

**18. Покажете средната заплата по отдели**

```sql
SELECT
    department_code,
    AVG(salary) as avg_salary,
    COUNT(*) as employee_count
FROM employees_raw
WHERE is_active = true
GROUP BY department_code
ORDER BY avg_salary DESC;
```
**Обяснение:** Групиране по отдел и показване на допълнителна статистика.
**Подход:** Добавете COUNT() за да видите колко записа има във всяка група.
**⚠️ Внимание:** Филтрирайте неактивните служители за точни резултати.

### 2.3 HAVING клауза (10 мин)

**19. Покажете отделите със средна заплата над 2500 лева**

```sql
SELECT
    department_code,
    AVG(salary) as avg_salary
FROM employees_raw
WHERE is_active = true
GROUP BY department_code
HAVING AVG(salary) > 2500;
```
**Обяснение:** `HAVING` филтрира резултати СЛЕД групирането, `WHERE` филтрира ПРЕДИ.
**⚠️ Внимание:** Не можете да използвате псевдоними в HAVING в PostgreSQL!
**Подход:** WHERE → GROUP BY → HAVING е правилната последователност.

---

**20. Намерете служителите с повече от 1 продажба**

```sql
SELECT
    employee_id,
    COUNT(*) as sales_count
FROM sales_raw
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- С имена на служителите:
SELECT
    e.emp_name,
    COUNT(s.order_id) as sales_count
FROM employees_raw e
INNER JOIN sales_raw s ON e.id = s.employee_id
GROUP BY e.emp_name
HAVING COUNT(s.order_id) > 1;
```
**Обяснение:** Филтриране на групи по брой записи.
**Подход:** Втората версия е по-информативна за потребителите.
**Учебна цел:** HAVING работи с резултати от агрегатни функции.

---

**21. Покажете градовете с повече от 1 клиент**

```sql
SELECT
    city,
    COUNT(*) as customer_count
FROM customers_raw
GROUP BY city
HAVING COUNT(*) > 1;
```
**Обяснение:** Намиране на градове с множество клиенти.
**Подход:** Използвайте този тип заявки за анализ на концентрация.
**Учебна цел:** Комбиниране на GROUP BY и HAVING за филтриране на групи.

## ЧАСТ 3: JOIN ЗАЯВКИ (60 мин)

### 3.1 INNER JOIN (20 мин)

**22. Покажете всички продажби с имената на служителите**

```sql
SELECT
    s.order_id,
    s.amount,
    s.order_date,
    e.emp_name
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id;
```
**Обяснение:** INNER JOIN свързва две таблици по обща колона.
**Подход:** Винаги използвайте псевдоними (aliases) за таблиците: `s` за sales, `e` за employees.
**⚠️ Внимание:** INNER JOIN показва само записи които имат съответствие в двете таблици!

---

**23. Покажете продажбите с имената на клиентите и служителите**

```sql
SELECT
    s.order_id,
    s.amount,
    s.order_date,
    e.emp_name as employee_name,
    c.company_name as customer_name
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
INNER JOIN customers_raw c ON s.customer_id = c.cust_id;
```
**Обяснение:** Множествени JOIN-ове за свързване на повече от 2 таблици.
**Подход:** Започнете с основната таблица (sales) и добавяйте JOIN-ове към свързаните.
**Учебна цел:** Можете да правите неограничен брой JOIN-ове в една заявка.

---

**24. Намерете всички продажби на служители от отдел 'SALES'**

```sql
SELECT
    s.order_id,
    s.amount,
    e.emp_name,
    e.department_code
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
WHERE e.department_code = 'SALES';
```
**Обяснение:** Комбиниране на JOIN с WHERE филтър.
**Подход:** WHERE филтърът се прилага СЛЕД JOIN операцията.
**⚠️ Внимание:** Уточнете от коя таблица е колоната: `e.department_code`.

---

**25. Покажете връщанията с причината и името на клиента**

```sql
SELECT
    r.return_id,
    r.return_date,
    r.reason,
    c.company_name
FROM returns_raw r
INNER JOIN customers_raw c ON r.customer_id = c.cust_id;
```
**Обяснение:** JOIN между таблицата за връщания и клиенти.
**Подход:** Винаги започвайте с главната таблица (returns в този случай).
**Учебна цел:** Същите JOIN принципи се прилагат за всички таблици в базата.

### 3.2 LEFT JOIN (15 мин)

**26. Покажете всички служители и техните продажби (включително тези без продажби)**

```sql
SELECT
    e.emp_name,
    s.order_id,
    s.amount
FROM employees_raw e
LEFT JOIN sales_raw s ON e.id = s.employee_id
ORDER BY e.emp_name;
```
**Обяснение:** LEFT JOIN показва всички записи от лявата таблица, дори без съответствие в дясната.
**⚠️ Внимание:** Записите без съответствие ще имат NULL стойности за колоните от дясната таблица.
**Подход:** Използвайте LEFT JOIN когато искате да видите всички записи от основната таблица.

---

**27. Покажете всички клиенти и техните поръчки (включително без поръчки)**

```sql
SELECT
    c.company_name,
    s.order_id,
    s.amount
FROM customers_raw c
LEFT JOIN sales_raw s ON c.cust_id = s.customer_id
ORDER BY c.company_name;
```
**Обяснение:** Намиране на клиенти които не са правили поръчки.
**Подход:** Клиентите без поръчки ще имат NULL в order_id и amount колоните.
**Учебна цел:** LEFT JOIN е полезен за анализ на липсващи връзки.

---

**28. Намерете служителите, които нямат продажби**

```sql
SELECT
    e.emp_name,
    e.department_code
FROM employees_raw e
LEFT JOIN sales_raw s ON e.id = s.employee_id
WHERE s.employee_id IS NULL;
```
**Обяснение:** Използване на LEFT JOIN + WHERE IS NULL за намиране на записи без връзки.
**⚠️ Внимание:** Използвайте `IS NULL`, не `= NULL`!
**Подход:** Този pattern е много често използван в реални системи.

### 3.3 Комплексни JOIN заявки (25 мин)

**29. Покажете топ 3 служители по общ размер на продажбите**

```sql
SELECT
    e.emp_name,
    SUM(s.amount) as total_sales
FROM employees_raw e
INNER JOIN sales_raw s ON e.id = s.employee_id
GROUP BY e.emp_name
ORDER BY total_sales DESC
LIMIT 3;
```
**Обяснение:** Комбиниране на JOIN, GROUP BY, агрегатни функции и LIMIT.
**Подход:** Групирайте по името за да получите сума за всеки служител.
**Учебна цел:** Реални бизнес заявки често комбинират много SQL концепции.

---

**30. Намерете клиентите с най-много поръчки**

```sql
SELECT
    c.company_name,
    COUNT(s.order_id) as order_count
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
GROUP BY c.company_name
ORDER BY order_count DESC;

-- Само топ клиентите:
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
```
**Обяснение:** Първата заявка показва всички клиенти сортирани, втората - само с максимален брой.
**Подход:** Започнете с простата версия, после добавете сложната логика.
**⚠️ Внимание:** Субзаявките могат да са бавни на големи данни.

---

**31. Покажете месечните продажби по отдели**

```sql
SELECT
    e.department_code,
    DATE_TRUNC('month', s.order_date) as month,
    SUM(s.amount) as monthly_sales
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
GROUP BY e.department_code, DATE_TRUNC('month', s.order_date)
ORDER BY month, e.department_code;
```
**Обяснение:** Комплексно групиране по отдел И месец.
**⚠️ Внимание:** И двете колони за групиране трябва да са в GROUP BY клаузата.
**Подход:** Използвайте DATE_TRUNC за по-лесно групиране по времеви периоди.

---

**32. Създайте справка за връщанията: дата на връщане, оригинална поръчка, клиент, причина**

```sql
SELECT
    r.return_date,
    r.order_id as original_order,
    c.company_name as customer,
    r.reason,
    s.amount as original_amount
FROM returns_raw r
INNER JOIN customers_raw c ON r.customer_id = c.cust_id
INNER JOIN sales_raw s ON r.order_id = s.order_id;
```
**Обяснение:** JOIN на 3 таблици за пълна информация за връщанията.
**Подход:** Започнете с основната таблица (returns) и добавяйте връзките.
**Учебна цел:** Реални справки често изискват данни от множество таблици.

## ЧАСТ 4: СЛОЖНИ КОМБИНАЦИИ (40 мин)

### 4.1 Субзаявки (15 мин)

**33. Намерете служителите с заплата над средната**

```sql
SELECT
    emp_name,
    salary
FROM employees_raw
WHERE salary > (SELECT AVG(salary) FROM employees_raw)
ORDER BY salary DESC;
```
**Обяснение:** Субзаявка в WHERE клауза за динамично сравнение.
**Подход:** Субзаявката се изпълнява първо и връща една стойност.
**⚠️ Внимание:** Субзаявката трябва да връща точно една стойност за сравнение!

---

**34. Покажете клиентите с продажби над средната стойност**

```sql
SELECT DISTINCT
    c.company_name,
    c.city
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
WHERE s.amount > (SELECT AVG(amount) FROM sales_raw);

-- С обща стойност на продажбите за клиента:
SELECT
    c.company_name,
    SUM(s.amount) as total_purchases
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
GROUP BY c.company_name
HAVING SUM(s.amount) > (SELECT AVG(amount) FROM sales_raw);
```
**Обяснение:** Две интерпретации - клиенти с поне една продажба над средната, или с обща сума над средната.
**Подход:** Винаги уточнете какво точно означава задачата.
**⚠️ Внимание:** DISTINCT елиминира дублиращи се клиенти във първата заявка.

---

**35. Намерете продажбите на най-добре платения служител**

```sql
SELECT
    s.order_id,
    s.amount,
    s.order_date,
    e.emp_name,
    e.salary
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
WHERE e.salary = (SELECT MAX(salary) FROM employees_raw);
```
**Обяснение:** Субзаявка за намиране на максималната заплата.
**Подход:** Първо намерете максималната стойност, после филтрирайте по нея.
**⚠️ Внимание:** Ако има повече от един служител с максимална заплата, ще се покажат всички техни продажби.

### 4.2 Анализ по отдели и градове (15 мин)

**36. Покажете общите продажби по градове на клиентите**

```sql
SELECT
    c.city,
    COUNT(s.order_id) as total_orders,
    SUM(s.amount) as total_sales,
    AVG(s.amount) as avg_order_value
FROM customers_raw c
INNER JOIN sales_raw s ON c.cust_id = s.customer_id
GROUP BY c.city
ORDER BY total_sales DESC;
```
**Обяснение:** Географски анализ на продажбите.
**Подход:** Добавете допълнителни метрики за по-пълна картина.
**Учебна цел:** Бизнес анализът често изисква групиране по географски критерии.

---

**37. Намерете отдела с най-големи продажби**

```sql
SELECT
    e.department_code,
    SUM(s.amount) as total_sales
FROM sales_raw s
INNER JOIN employees_raw e ON s.employee_id = e.id
GROUP BY e.department_code
ORDER BY total_sales DESC
LIMIT 1;

-- Алтернативен начин с субзаявка:
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
```
**Обяснение:** Две подхода - прост с LIMIT или точен с субзаявка.
**⚠️ Внимание:** LIMIT 1 показва само един отдел дори ако има равенство. Субзаявката показва всички с максимална стойност.
**Подход:** Изберете подхода според бизнес изискванията.

---

**38. Създайте справка: отдел, брой служители, средна заплата, общи продажби**

```sql
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
```
**Обяснение:** Комплексна справка комбинираща HR и продажбени данни.
**⚠️ Внимание:** Използвайте LEFT JOIN за да включите отдели без продажби.
**Подход:** `COALESCE` замества NULL с 0 за по-четливи резултати.
**Учебна цел:** `COUNT(DISTINCT)` е важно когато JOIN създава дублиращи се редове.

### 4.3 Времеви анализ (10 мин)

**39. Покажете дневните продажби за октомври 2023**

```sql
SELECT
    order_date,
    COUNT(*) as daily_orders,
    SUM(amount) as daily_sales
FROM sales_raw
WHERE order_date >= '2023-10-01'
  AND order_date < '2023-11-01'
GROUP BY order_date
ORDER BY order_date;
```
**Обяснение:** Времеви анализ с групиране по дни.
**Подход:** Използвайте >= и < за точно дефиниране на периода.
**Учебна цел:** Дневните справки са основа за dashboard-ове и отчети.

---

**40. Намерете дните без продажби**

```sql
-- Генериране на всички дни в периода:
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

-- Опростен вариант за данните в базата:
SELECT
    current_date - interval '1 day' * s.day_offset as missing_date
FROM generate_series(0, 30) s(day_offset)
WHERE (current_date - interval '1 day' * s.day_offset) NOT IN (
    SELECT DISTINCT order_date FROM sales_raw
    WHERE order_date >= '2023-10-01' AND order_date <= '2023-10-31'
);
```
**Обяснение:** Намиране на дати без записи чрез генериране на дати и LEFT JOIN.
**⚠️ Внимание:** PostgreSQL специфични функции като `generate_series`.
**Подход:** CTE (Common Table Expressions) прави заявката по-четлива.

---

**41. Сравнете продажбите и връщанията по дати**

```sql
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
```
**Обяснение:** Комплексно сравнение използващо множествени подзаявки и UNION.
**Подход:** Разделете на части: дати, продажби, връщания, после ги обединете.
**Учебна цел:** Реални анализи често изискват сложни комбинации от данни.

## БОНУС ЗАДАЧИ (за напреднали студенти)

**42. Създайте "dashboard" заявка която показва:**
- Общо служители по отдели
- Общи продажби по отдели
- Процент на връщанията
- Топ 3 клиента по стойност

```sql
-- Комплексен dashboard с множество CTE:
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
```
**Обяснение:** Използване на CTE (Common Table Expressions) за организиране на сложни заявки.
**Подход:** Разделете сложните задачи на по-малки, управляеми части.
**⚠️ Внимание:** `NULLIF` предотвратява делене на нула. `STRING_AGG` е PostgreSQL специфична функция.

---

**43. Намерете служителите които имат както продажби, така и обработени връщания**

```sql
SELECT
    e.emp_name,
    COUNT(DISTINCT s.order_id) as sales_count,
    COUNT(DISTINCT r.return_id) as returns_processed
FROM employees_raw e
INNER JOIN sales_raw s ON e.id = s.employee_id
INNER JOIN returns_raw r ON e.id = r.employee_id
GROUP BY e.emp_name
ORDER BY sales_count DESC, returns_processed DESC;

-- Алтернативен начин с EXISTS:
SELECT
    e.emp_name,
    (SELECT COUNT(*) FROM sales_raw s WHERE s.employee_id = e.id) as sales_count,
    (SELECT COUNT(*) FROM returns_raw r WHERE r.employee_id = e.id) as returns_count
FROM employees_raw e
WHERE EXISTS (SELECT 1 FROM sales_raw s WHERE s.employee_id = e.id)
  AND EXISTS (SELECT 1 FROM returns_raw r WHERE r.employee_id = e.id);
```
**Обяснение:** Намиране на служители участващи и в двете процеса.
**⚠️ Внимание:** INNER JOIN автоматично филтрира само служителите с и двата типа записи.
**Подход:** EXISTS е по-четлив но може да е по-бавен на големи данни.

---

**44. Създайте справка за "проблемни" клиенти (с връщания) и техните данни за контакт**

```sql
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
```
**Обяснение:** Комплексен анализ на клиенти с връщания включващ процент на връщания и причини.
**Подход:** LEFT JOIN позволява да видим всички продажби, дори без връщания.
**⚠️ Внимание:** GROUP BY трябва да включва всички неагрегатни колони от SELECT.
**Учебна цел:** Реални бизнес заявки често комбинират множество метрики и анализи.

## РАЗПРЕДЕЛЕНИЕ НА ВРЕМЕТО:

- **Част 1 (30 мин)**: Базови SELECT и WHERE - загряване
- **Част 2 (40 мин)**: SUM, AVG, COUNT, HAVING - агрегация
- **Част 3 (60 мин)**: JOIN операции - основната част
- **Част 4 (40 мин)**: Комплексни заявки и анализ

**Общо: 170 мин (2 часа 50 мин)** - това дава малко гъвкавост за обяснения и въпроси.

## КЛЮЧОВИ УЧЕБНИ МОМЕНТИ:

### 🎯 Последователност на SQL клаузите:
```sql
SELECT колони
FROM таблица
WHERE условие_за_редове
GROUP BY колони_за_групиране
HAVING условие_за_групи
ORDER BY колони_за_сортиране
LIMIT брой_записи
```

### ⚠️ Често срещани грешки:
1. **Кавички**: Използвайте `'` за стрингове, не `"`
2. **NULL сравнения**: `IS NULL` / `IS NOT NULL`, не `= NULL`
3. **GROUP BY**: Всяка неагрегатна колона в SELECT трябва да е в GROUP BY
4. **HAVING vs WHERE**: WHERE филтрира преди групиране, HAVING - след групиране
5. **JOIN типове**: INNER показва само съвпадения, LEFT показва всички от лявата таблица

### 💡 Най-добри практики:
1. **Винаги използвайте псевдоними за таблици в JOIN-ове**
2. **Давайте смислени имена на колоните с AS**
3. **Сортирайте резултатите за по-добра четливост**
4. **Избягвайте SELECT * в производствени системи**
5. **Тествайте заявките стъпка по стъпка при сложни JOIN-ове**

### 📊 Полезни PostgreSQL функции:
- `DATE_TRUNC('month', date)` - за групиране по периоди
- `EXTRACT(MONTH FROM date)` - за извличане на части от дати
- `COALESCE(value, 0)` - за заместване на NULL стойности
- `generate_series()` - за генериране на числови или датови редици
- `STRING_AGG()` - за обединяване на стрингове
