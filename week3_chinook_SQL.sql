-- Week 3: SQL & Data Querying
-- Dataset: Chinook Database (Music Store)
-- Tool: PostgreSQL + pgAdmin
-- Objective: Extract, transform, and analyze data using SQL
-- 1. CORE SQL QUERIES
-- 1.1 SELECT: Retrieve customer information
SELECT
first_name,
last_name,
email
FROM customer;
-- 1.2 WHERE: Customers from Brazil
SELECT
first_name,
last_name,
country
FROM customer
WHERE country = 'Brazil';
-- 1.3 ORDER: Customers alphabetically by last name.
SELECT
first_name,
last_name
FROM customer
ORDER BY last_name ASC;
-- 1.4 COUNT: Total of customers.
SELECT COUNT(*) AS total_customers
FROM customer;
-- 2. Aggregate functions
-- 2.1 SUM: What is the total revenue?
SELECT SUM(total) AS total_revenue
FROM invoice;
-- 2.2 AVG: What is the average invoice value?
SELECT AVG(total) AS average_invoice
FROM invoice;
-- 2.3 GROUP BY : How many customers are in each country?
SELECT
country,
COUNT(*) AS number_of_customers
FROM customer
GROUP BY country;
-- 2.4 HAVING : countries with more than 5 customers.
SELECT
country,
COUNT(*) AS number_of_customers
FROM customer
GROUP BY country
HAVING COUNT(*) > 5;
-- 3. Advanced SQL : 3.1 JOINS
-- INNER JOIN: Customer purchase history
SELECT
customer.customer_id,
customer.first_name,
customer.last_name,
invoice.invoice_id,
invoice.total
FROM customer
INNER JOIN invoice
ON customer.customer_id = invoice.customer_id;
-- LEFT JOIN: Customers and their invoices

SELECT
customer.first_name,
customer.last_name,
invoice.total
FROM customer
LEFT JOIN invoice
ON customer.customer_id = invoice.customer_id;

-- 3.2 Subquery
SELECT *
FROM invoice
WHERE total >
(
SELECT AVG(total)
FROM invoice
);
-- 4 Window Functions
-- Rank customers based on total spending

SELECT
customer_id,
SUM(total) AS total_spent,
RANK() OVER(
ORDER BY SUM(total) DESC
) AS customer_rank
FROM invoice
GROUP BY customer_id;
-- Rank invoices within each customer

SELECT
customer_id,
invoice_id,
total,
RANK() OVER(
PARTITION BY customer_id
ORDER BY total DESC
) AS customer_invoice_rank
FROM invoice;
-- 5. Business Problem Solving
-- 5.1 Top-Performing Customers (Highest Revenue)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(i.total),2) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 10;
-- 5.2 Top-Selling Music Genres
SELECT
    g.name AS genre,
    COUNT(il.invoice_line_id) AS total_sales
FROM invoice_line il
JOIN track t
ON il.track_id = t.track_id
JOIN genre g
ON t.genre_id = g.genre_id
GROUP BY g.name
ORDER BY total_sales DESC;
-- 5.3 Revenue Trends Over Time
 SELECT
    DATE_TRUNC('month', invoice_date) AS month,
    ROUND(SUM(total),2) AS revenue
FROM invoice
GROUP BY month
ORDER BY month;
-- 5.4 Customer Purchasing Behavior
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    COUNT(i.invoice_id) AS number_of_orders,
    ROUND(AVG(i.total),2) AS average_purchase
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY number_of_orders DESC;

 -- 6. Query Optimization


 EXPLAIN ANALYZE

SELECT
    c.first_name,
    c.last_name,
    i.total
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
WHERE c.country = 'USA';

-- Top 10 customers by total spending

SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    ROUND(SUM(i.total),2) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name
ORDER BY total_spent DESC
LIMIT 10;
