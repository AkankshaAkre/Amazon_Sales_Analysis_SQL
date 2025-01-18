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
---- Exploratory Data Analysis (EDA)
-----------------------------------------------------------------
-- Understanding the structure and columns of the dataset
SELECT 
	column_name,
	data_type,
	is_nullable 
FROM information_schema.columns
WHERE table_name = 'amazon_sales';

-- Reviewing the first 20 rows of the dataset
SELECT * 
FROM amazon_sales
LIMIT 20;

-- Counting total rows in the dataset
SELECT COUNT(*) 
FROM amazon_sales;

-- Checking for null values in the dataset
SELECT COUNT(*) 
FROM amazon_sales
WHERE id IS NULL
	OR order_date IS NULL
	OR customer_name IS NULL
	OR state IS NULL
	OR category IS NULL
	OR sub_category IS NULL
	OR product_name IS NULL
	OR sales IS NULL
	OR quantity IS NULL
	OR profit IS NULL;

-- Identifying duplicate records in the dataset
SELECT *, COUNT(*) as duplicate_count
FROM amazon_sales
GROUP BY id, order_date, customer_name, state, category, sub_category, product_name, sales, quantity, profit
HAVING COUNT(*)>1;

-- Retrieving the full details of duplicate rows
SELECT * 
FROM (
SELECT *, ROW_NUMBER() OVER(PARTITION BY id) RN
FROM amazon_sales) subquery
WHERE RN > 1;

-----------------------------------------------------------------
---- Data Summary & Insights
-----------------------------------------------------------------
-- High-level summary of total sales, orders and profits
SELECT 
	COUNT(id) AS total_orders,
	ROUND(SUM(sales)::numeric, 2) AS total_sales,
	ROUND(SUM(profit)::numeric, 2) AS total_profit
FROM amazon_sales;
-- Insight: The total number of orders placed amounts to 9989, overall sales stand at Rs. 22,95,818.87, with a total profit of Rs. 2,86,198.76.

-----------------------------------------------------------------
---- Category Analysis
-----------------------------------------------------------------
-- Analyzing total sales to identify high-revenue categories
SELECT 
	category, 
	ROUND(SUM(sales)::numeric, 2) AS total_sales
FROM amazon_sales
GROUP BY category
ORDER BY total_sales DESC;
-- Insight: "Technology" category garners the highest sales with Rs. 8,36,154 at Amazon

-- Calculating average quantity ordered per category
SELECT 
	category, 
	ROUND(AVG(quantity), 2) AS average_quantity
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC;
-- Insight: The "Office Supplies" category sees the highest average quantity ordered, suggesting frequent purchases in this category

-----------------------------------------------------------------
---- Customer Analysis
-----------------------------------------------------------------
-- Identifying the top 5 customers contributing the highest profits
SELECT 
	customer_name, 
	ROUND(SUM(profit)::numeric, 2) AS total_profit 
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
-- Insight: Customer "Aditi" contributes the most profit, with a total of Rs. 10,537

-----------------------------------------------------------------
---- Product Insights
-----------------------------------------------------------------
-- Highlighting top 5 products by revenue
SELECT 
	product_name, 
	ROUND(SUM(sales)::numeric, 2) AS total_revenue
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
-- Using DENSE_RANK() for handling ties if any
SELECT 
	product_name, 
	total_revenue
FROM (
  SELECT product_name, 
         ROUND(SUM(sales)::numeric, 2) AS total_revenue,
		 DENSE_RANK() OVER (ORDER BY SUM(sales) DESC) AS rank
  FROM amazon_sales
  GROUP BY product_name
) AS ranked_products
WHERE rank <= 5;
-- Insight: "Canon imageCLASS 2200 Advanced Copier" stands out as the top-selling product, generating Rs. 61,599 in sales.

-- Determining the most profitable sub-category 
SELECT 
	sub_category, 
	SUM(profit) total_profit
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;
-- Insight: The "Copiers" sub-category has emerged as the most profitable, generating a total profit of Rs. 55,617

-- Detecting products with decreased revenue compared to the previous year
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
SELECT 
	cy.product_name, 
	cy.revenue AS curr_revenue, 
	py.revenue AS prev_revenue,
	ROUND((py.revenue - cy.revenue)::numeric, 2) AS rev_decrease_amount,
	ROUND((cy.revenue / py.revenue)::numeric, 2) AS rev_decrease_ratio
FROM cy INNER JOIN py
ON cy.product_name = py.product_name
WHERE cy.revenue < py.revenue
ORDER BY rev_decrease_ratio DESC;
-- Insight: No products showed a decrease in revenue compared to the previous year, indicating stable or improved sales performance across the product range.

-- Revenue ranking of products within each category
SELECT 
	category,
	product_name,
	SUM(sales) total_revenue,
	RANK() OVER(PARTITION BY category ORDER BY SUM(sales) DESC) AS revenue_rank
FROM amazon_sales
GROUP BY category, product_name;
-- Insight: The top performing product in the "Furniture" category is "HON 5400 Series Task Chairs for Big and Tall" with Rs. 21,870 in sales,
-- while in the "Office Supplies" category, "Fellowes PB500 Electric Punch Plastic Comb Binding Machine with Manual Bind" leads with Rs. 27,453 in sales,
-- and in the "Technology" category, "Canon imageCLASS 2200 Advanced Copier" dominates with Rs. 61,599 in sales.

-----------------------------------------------------------------
---- Geographic Insights
-----------------------------------------------------------------
-- Identifying states with the highest total orders
SELECT 
	state, 
	COUNT(id) AS total_orders
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC;
-- Insight: "Andhra Pradesh" & "Tamil Nadu" lead in total orders with 403 & 402 purchases respectively, making key markets for Amazon's operation.

-- Highlighting the top-selling product within each state
SELECT 
	state,
	product_name,
	total_sales
FROM (
SELECT 
	state, 
	product_name,
	SUM(sales) total_sales,
	RANK() OVER(PARTITION BY state ORDER BY SUM(sales) DESC) AS rank
FROM amazon_sales
GROUP BY state, product_name
) subquery
WHERE rank = 1
ORDER BY total_sales DESC;
-- Insight: "Canon imageCLASS 2200 Advanced Copier" is the top selling product across multiple states, with the highest sales of 25,199 in Assam.

-----------------------------------------------------------------
---- Time-based Insights
-----------------------------------------------------------------
-- Determining the month with the highest number of orders.
SELECT 
	TO_CHAR(order_date, 'Month') AS month_name, 
	COUNT(id) AS total_orders
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC;
-- Insight: "January" experiences the highest volume of orders with a total of 979 orders.

-- If we want data by month and year as well
SELECT 
	(TO_CHAR(order_date, 'Mon') || '-' || EXTRACT(YEAR FROM order_date)) AS month_name,
	COUNT(id) AS total_orders
FROM amazon_sales
GROUP BY 1
ORDER BY 2 DESC
-- Insight: The month of August 2023 recorded 239 orders, marking a peak in sales activity for that specific period.

-- Analyzing yearly trends for total orders and revenue
SELECT 
	EXTRACT(YEAR FROM order_date) AS year, 
	COUNT(id) AS total_orders,
	ROUND(SUM(sales)::numeric, 2) AS total_revenue
FROM amazon_sales
GROUP BY 1
ORDER BY 1;
-- Insight: 2023 showed a strong rebound with 2,502 orders and a total revenue of Rs. 620,888.70, reflecting a healthy sales growth compared to earlier years.
-- As of February 15, 2024, the dataset includes 299 orders and Rs. 84,981.35 in revenue, reflecting a promising start to the year.

-----------------------------------------------------------------
---- Profitability Analysis
-----------------------------------------------------------------
-- Calculating profit margin percentage for each sale
SELECT 
	product_name,
	ROUND((profit/ NULLIF(sales, 0)*100)::numeric, 2) AS profit_margin_percentage 
FROM amazon_sales;
-- Insight: The profit margin for each sale varies across products, with some items showing significantly higher margins compared to others.
-- The products with the highest profit margin percentage have a remarkable 50.02% margin, indicating highly profitable items.
-- However, there are some products showing negative profit margins, with one as low as -275.93%, suggesting significant losses on those items. 

-- Calculating sub-category contribution to total sales (for 2023)
WITH subcategory_sales AS (
	SELECT sub_category, SUM(sales) total_sales
	FROM amazon_sales
	WHERE EXTRACT(YEAR FROM order_date) = 2023
	GROUP BY sub_category
),
total_sales AS (
	SELECT SUM(sales) total_sales_2023
	FROM amazon_sales
	WHERE EXTRACT(YEAR FROM order_date) = 2023
)
SELECT 
	sc.sub_category, 
	sc.total_sales,
	tc.total_sales_2023, 
	ROUND((sc.total_sales/tc.total_sales_2023*100)::numeric, 2) AS percentage_contribution
FROM subcategory_sales sc 
CROSS JOIN total_sales tc
ORDER BY percentage_contribution DESC;
-- Insight: In 2023, the top three sub-categories contributing the most to total sales are "Machines" (14.54%), "Chairs" (13.48%), and "Phones" (12.71%). 
-- On the other hand, sub-categories like "Fasteners", "Labels" and "Envelopes" contribute less than 1% each.
