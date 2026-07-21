-- Week 3: SQL & Data Querying
-- Dataset: sales Database 
-- Tool: PostgreSQL + pgAdmin
-- Objective: Extract, transform, and analyze data using SQL
-- 1. Core SQL Queries
-- 1.1 SELECT: Retrieve sales information
SELECT
    order_number,
    product_line,
    sales,
    status
FROM sales_data
LIMIT 10;

-- 1.2 WHERE: Shipped orders

SELECT
    order_number,
    product_line,
    sales
FROM sales_data
WHERE status = 'Shipped';

-- 1.3 ORDER BY: Highest sales first

SELECT
    order_number,
    product_line,
    sales
FROM sales_data
ORDER BY sales DESC;

-- 1.4 COUNT: Total orders

SELECT COUNT(*) AS total_orders
FROM sales_data;

-- 2. Aggregate Functions
-- 2.1 SUM: Total revenue

SELECT
    ROUND(SUM(sales),2) AS total_revenue
FROM sales_data;

-- 2.2 AVG: Average sale value

SELECT
    ROUND(AVG(sales),2) AS average_sale
FROM sales_data;

-- 2.3 GROUP BY: Revenue by Product Line
SELECT
    product_line,
    ROUND(SUM(sales),2) AS total_revenue
FROM sales_data
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 2.4 HAVING: Product lines with revenue above $100,000

SELECT
    product_line,
    ROUND(SUM(sales),2) AS total_revenue
FROM sales_data
GROUP BY product_line
HAVING SUM(sales) > 100000
ORDER BY total_revenue DESC;

-- 3. Advanced SQL
-- 3.1 Self Analysis (No joins needed)

SELECT
    order_number,
    product_line,
    sales
FROM sales_data
ORDER BY sales DESC
LIMIT 10;

-- 3.2 Subquery

SELECT
    order_number,
    product_line,
    sales
FROM sales_data
WHERE sales >
(
    SELECT AVG(sales)
    FROM sales_data
);

-- 4. Window Functions
-- Rank orders by sales

SELECT
    order_number,
    product_line,
    sales,
    RANK() OVER
    (
        ORDER BY sales DESC
    ) AS sales_rank
FROM sales_data;

-- Rank products within each product line

SELECT
    product_line,
    order_number,
    sales,
    RANK() OVER
    (
        PARTITION BY product_line
        ORDER BY sales DESC
    ) AS product_rank
FROM sales_data;

-- 5. Business Problem Solving
-- 5.1 Top-Performing Product Lines

SELECT
    product_line,
    ROUND(SUM(sales),2) AS total_revenue
FROM sales_data
GROUP BY product_line
ORDER BY total_revenue DESC;

-- 5.2 Revenue Trends Over Time

SELECT
    year_id,
    month_id,
    ROUND(SUM(sales),2) AS monthly_revenue
FROM sales_data
GROUP BY year_id, month_id
ORDER BY year_id, month_id;

-- 5.3 Customer Purchasing Behavior (Order Analysis)

SELECT
    order_number,
    COUNT(*) AS products_ordered,
    ROUND(SUM(sales),2) AS total_order_value
FROM sales_data
GROUP BY order_number
ORDER BY total_order_value DESC;

-- 6. Query Optimization

EXPLAIN ANALYZE

SELECT
    order_number,
    product_line,
    sales
FROM sales_data
WHERE product_line = 'Classic Cars';

-- Calculate total revenue for each product line

SELECT
    product_line,
    ROUND(SUM(sales),2) AS total_revenue
FROM sales_data
GROUP BY product_line
ORDER BY total_revenue DESC;