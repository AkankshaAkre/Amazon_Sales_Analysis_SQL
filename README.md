
# Amazon Sales Data Analysis

## Project Overview
This project demonstrates SQL skills by analyzing an Amazon Sales dataset. The dataset contains transactional data for a variety of products, customers, and sales performance metrics. The analysis focuses on deriving actionable insights from the dataset using SQL queries. It showcases SQL concepts such as aggregation, filtering, window functions, Common Table Expressions (CTEs), and joins.

## Files
- **`Amazon_salesdata.csv`**: Contains the raw dataset.
- **`Amazon_Sales.sql`**: Contains the SQL queries used for analysis and deriving insights.

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

## Key Insights
**Revenue and Profit Analysis:**
- Identified top-performing categories, sub-categories, and products in terms of sales and profit.
- Highlighted the top customers and their contribution to overall profitability.
  
**Geographic Trends:**
- Determined states with the highest number of orders and revenue contributions.
- Pinpointed state-wise best-selling products.
  
**Seasonal and Temporal Insights:**
- Analyzed monthly and yearly trends to uncover peak sales periods and annual growth.
  
**Profitability and Contribution:**
- Evaluated sub-category contributions to total sales.
- Calculated profit margins to evaluate the profitability of transactions.
  
**Declining Performance:**
- Identified products experiencing a revenue decline compared to the previous year.

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
