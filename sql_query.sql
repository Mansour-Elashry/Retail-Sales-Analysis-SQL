-- Create the Sales database
CREATE DATABASE sales;


-- Create retail_sales table
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR(15),
    quantity INT,
    price_per_unit FLOAT,
    cogs FLOAT,
    total_sale FLOAT
);

-- Select all records from retail_sales
SELECT * FROM retail_sales;

-- Check total number of sales records
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Data Cleaning - Checking for NULL values
SELECT * FROM retail_sales
WHERE transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Delete rows with NULL values
DELETE FROM retail_sales
WHERE transaction_id IS NULL
    OR sale_date IS NULL
    OR sale_time IS NULL
    OR gender IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;

-- Data Exploration

-- Total sales count
SELECT COUNT(*) AS total_sales FROM retail_sales;

-- Count of unique customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers FROM retail_sales;

-- Unique categories
SELECT DISTINCT category FROM retail_sales;

-- Data Analysis & Business Key Questions

-- Q1: Retrieve all columns for sales made on '2022-11-05'
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2: Retrieve transactions for 'Clothing' with quantity > 4 in Nov 2022
SELECT * 
FROM retail_sales
WHERE category = 'Clothing'
    AND FORMAT(sale_date, 'yyyy-MM') = '2022-11'
    AND quantity > 4;

-- Q3: Total sales for each category
SELECT category,
    SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4: Average age of customers in the 'Beauty' category
SELECT ROUND(AVG(age), 2) AS avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5: Transactions where total_sale > 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6: Total transactions by gender for each category
SELECT category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;

-- Q7: Average sale per month, with best-selling month of each year
WITH MonthlySales AS (
    SELECT YEAR(sale_date) AS sale_year,
           MONTH(sale_date) AS sale_month,
           AVG(total_sale) AS avg_sale,
           RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS month_rank
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
)
SELECT sale_year, sale_month, avg_sale
FROM MonthlySales
WHERE month_rank = 1
ORDER BY sale_year;

-- Q8: Top 5 customers by highest total sales
SELECT TOP 5 customer_id,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC;

-- Q9: Unique customers count per category
SELECT category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10: Orders by time shift (Morning, Afternoon, Evening)
WITH ShiftOrders AS (
    SELECT *,
        CASE 
            WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
            WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT shift,
    COUNT(*) AS total_orders
FROM ShiftOrders
GROUP BY shift;

