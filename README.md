
# Amazon Sales Data Analysis

## Project Overview
This project demonstrates SQL skills by analyzing an Amazon Sales dataset. The dataset contains transactional data for a variety of products, customers, and sales performance metrics. This analysis addresses multiple business problems and provides actionable insights using SQL queries. The project is structured to showcase SQL concepts such as aggregation, filtering, window functions, Common Table Expressions (CTEs), and joins.

## Files
- **`Amazon_salesdata.csv`**: Contains the raw dataset.
- **`Business_Problems.txt`**: Lists all the business problems solved in this project.
- **`Amazon_Sales.sql`**: Contains the SQL queries used to solve the business problems.

## Dataset
**File Name:** `Amazon_salesdata.csv`  
**Description:** Contains raw transactional data with the following columns:
- **id**: Unique identifier for each transaction.
- **order_date**: Date of the transaction.
- **customer_name**: Name of the customer.
- **state**: State of the transaction.
- **category**: Product category.
- **sub_category**: Product sub-category.
- **product_name**: Name of the product.
- **sales**: Sales amount.
- **quantity**: Number of items sold.
- **profit**: Profit amount.

## Business Questions Addressed
The analysis is driven by the following business questions:
1. **Total sales by category**: Which categories generate the highest revenue?
2. **Top 5 profitable customers**: Who are the most profitable customers?
3. **Average quantity ordered per category**: What is the average quantity sold for each category?
4. **Top 5 products by revenue**: Which products generate the most revenue?
5. **Revenue decline analysis**: Which products experienced a decline in revenue compared to the previous year?
6. **Most profitable sub-category**: Which sub-category contributes the most profit?
7. **States with the highest orders**: Which states place the most orders?
8. **Month with the highest orders**: In which month are orders the highest?
9. **Profit margin percentage**: What is the profit margin for each transaction?
10. **Sub-category contribution to sales**: How much does each sub-category contribute to the total sales for 2023?
11. **Annual revenue and order trends**: What are the total orders and revenue for each year?
12. **Product ranking by revenue within categories**: How do products rank by revenue within their categories?
13. **Top-selling product by state**: What is the top-selling product in each state?

## Key Insights
- **Best-Selling Categories**: Identified the categories with the highest total sales.
- **Customer Profitability**: Highlighted the top 5 customers contributing the most profit.
- **Top Products**: Found the top-performing products by revenue and their trends over time.
- **Geographic Trends**: Determined states with the most orders and their best-selling products.
- **Seasonality**: Pinpointed the month with the highest number of orders.
- **Profit Margins**: Calculated profit margin percentages to evaluate transaction efficiency.

## How to Run the Project
1. **Setup**:
   - Import the dataset `Amazon_salesdata.csv` into your SQL database.
   - Use the provided `Amazon_Sales.sql` file to execute queries.

2. **Prerequisites**:
   - Any SQL database environment (PostgreSQL, MySQL, etc.).
   - Basic understanding of SQL syntax and database operations.

3. **Steps**:
   - Create the `amazon_sales` table using the SQL script.
   - Load the data into the table.
   - Execute the queries to derive insights.

## Conclusion
This project showcases essential SQL skills and techniques for analyzing sales data. It provides actionable insights into sales performance, customer profitability, and geographic trends, demonstrating a strong foundation for database querying and business problem-solving.

## Contributions and Feedback
Contributions and feedbacks to enhance this project are highly welcome! If you'd like to suggest improvements, add new features, or fix any issues, feel free to submit pull requests or raise issues.
