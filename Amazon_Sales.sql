-- Creating table & importing the data

CREATE TABLE amazon_sales (
	id int PRIMARY KEY,
	order_date date,
	customer_name VARCHAR(25),
	state VARCHAR(25),
	category VARCHAR(25),
	sub_category VARCHAR(25),
	product_name VARCHAR(255),
	sales FLOAT,
	quantity INT,
	profit FLOAT
);

-----------------------------------------------------------------
---- Exploratory Data Analysis
-----------------------------------------------------------------
-- Exploring column details of the table
SELECT column_name, data_type, is_nullable FROM information_schema.columns
WHERE table_name = 'amazon_sales';

-- Exploring the first 20 rows
SELECT * FROM amazon_sales
LIMIT 20;

-- Total row count
SELECT COUNT(*) FROM amazon_sales;

-- Checking for null values
SELECT COUNT(*) FROM amazon_sales
WHERE id IS NULL
or order_date IS NULL
or customer_name IS NULL
or state IS NULL
or category IS NULL
or sub_category IS NULL
or product_name IS NULL
or sales IS NULL
or quantity IS NULL
or profit IS NULL;

-- Checking for duplicate values
-- Counting duplicates
SELECT *, COUNT(*) as duplicate_count
FROM amazon_sales
GROUP BY id, order_date, customer_name, state, category, sub_category, product_name, sales, quantity, profit
HAVING COUNT(*)>1;
-- Retrive the entire set of duplicate rows 
SELECT * FROM
(SELECT *, 
ROW_NUMBER() OVER(PARTITION BY id) RN
FROM amazon_sales) subquery
WHERE RN > 1;

-----------------------------------------------------------------
---- BUSINESS PROBLEMS
-----------------------------------------------------------------
-- Q.1] Find the total sales for each category
SELECT category, ROUND(SUM(sales)::numeric, 2) as total_sales
FROM amazon_sales
GROUP BY category
ORDER BY total_sales DESC;

-- Q.2] Find the top 5 customers who made the highest profits?
SELECT customer_name, ROUND(SUM(profit)::numeric, 2) as total_profit 
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.3] Find the average quantity ordered per category 
SELECT category, ROUND(AVG(quantity)::numeric, 2) as average_quantity
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC;

-- Q.4] Top 5 products that has generated highest revenue 
SELECT product_name, ROUND(SUM(sales)::numeric, 2) total_revenue
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
-- Using ROW_NUMBER() for handling ties if any
SELECT product_name, total_revenue
FROM (
  SELECT product_name, 
         ROUND(SUM(sales)::numeric, 2) AS total_revenue,
         ROW_NUMBER() OVER (ORDER BY SUM(sales) DESC) AS rank
  FROM amazon_sales
  GROUP BY product_name
) AS ranked_products
WHERE rank <= 5;

-- Q.5] Top 5 products whose revenue has decreased in comparison to previous year?
WITH cy AS (
SELECT product_name, SUM(sales) revenue
FROM amazon_sales
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY product_name
),
py AS (
SELECT product_name, SUM(sales) revenue
FROM amazon_sales
WHERE EXTRACT(YEAR FROM order_date) = EXTRACT(YEAR FROM CURRENT_DATE)-1
GROUP BY product_name
)
SELECT cy.product_name, 
cy.revenue as curr_revenue, 
py.revenue as prev_revenue,
ROUND((py.revenue - cy.revenue)::numeric, 2) as rev_decrease_amount,
ROUND((cy.revenue / py.revenue)::numeric, 2) as rev_decrease_ratio
FROM cy INNER JOIN py
ON cy.product_name = py.product_name
WHERE cy.revenue < py.revenue
ORDER BY rev_decrease_ratio DESC
LIMIT 5;

-- Q.6] Highest profitable sub category ?
SELECT sub_category, SUM(profit) total_profit
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Q.7] Find out states with highest total orders?
SELECT state, count(id) total_orders
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC;

-- Q.8] Determine the month with the highest number of orders.
-- Below query to be used when we want data only by month
SELECT to_char(order_date, 'Month') as month_name, count(id)
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
-- Below query to be used when we want data by month and year as well
SELECT (to_char(order_date, 'Mon') || '-' || EXTRACT(YEAR FROM order_date)) as month_name,
count(id) FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC

-- Q.9] Calculate the profit margin percentage for each sale (Profit divided by Sales).
SELECT id, product_name, ROUND((profit/ NULLIF(sales, 0)*100)::numeric, 2) profit_margin_percentage 
FROM amazon_sales

-- Q.10] Calculate the percentage contribution of each sub-category to the total sales amount for the year 2023.
WITH subcategory_sales as (
SELECT sub_category, SUM(sales) total_sales
FROM amazon_sales
WHERE EXTRACT(YEAR FROM order_date) = 2023
GROUP BY sub_category
),
total_sales as (
SELECT SUM(sales) total_sales_2023
FROM amazon_sales
WHERE EXTRACT(YEAR FROM order_date) = 2023
)
SELECT sc.sub_category, sc.total_sales, tc.total_sales_2023, 
ROUND((sc.total_sales/tc.total_sales_2023*100)::numeric, 2) as percentage_contribution
FROM subcategory_sales sc 
CROSS JOIN total_sales tc
ORDER BY percentage_contribution DESC;

-- Q.11] Find the total orders and total revenue for each year.
SELECT EXTRACT(YEAR FROM order_date) as year, 
COUNT(id) as total_orders,
ROUND(SUM(sales)::numeric, 2) as total_revenue
FROM amazon_sales
GROUP BY 1
ORDER BY 1;

-- Q.12] Rank products based on their revenue within each category.
SELECT category, product_name, SUM(sales) as total_revenue,
RANK() OVER(PARTITION BY category ORDER BY SUM(sales) DESC) as revenue_rank
FROM amazon_sales
GROUP BY category, product_name

-- Q.13] Identify the top-selling product in each state.
SELECT * FROM
(SELECT state, product_name, SUM(sales) total_sales,
RANK() OVER(PARTITION BY state ORDER BY SUM(sales) DESC) as rank
FROM amazon_sales
GROUP BY state, product_name) subquery
WHERE rank = 1