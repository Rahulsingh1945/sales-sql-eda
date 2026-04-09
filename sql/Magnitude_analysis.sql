-------------------------------------------------------------------------
-------------------------MAGNITUDE ANALYSIS------------------------------

--Find total customers by countries
SELECT 
country, COUNT(DISTINCT customer_id) AS  total_customers
FROM customers
GROUP BY country
ORDER BY total_customers DESC;

--Find the customers by gender
SELECT 
gender , COUNT(DISTINCT customer_id) AS  total_customers
FROM customers
GROUP BY gender
ORDER BY total_customers DESC;

--Find total products by category
SELECT 
category, COUNT(product_key) AS  total_products
FROM products
GROUP BY category
ORDER BY total_products DESC;

--what is the average costs in each category
SELECT 
category,
AVG(cost) AS avg_costs
FROM products
GROUP BY category
ORDER BY avg_costs DESC;

--what is the total revenue generated for each category
SELECT 
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM orders f
JOIN products p
    ON f.product_key = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC;

--Find total revenue is generate by each customer
SELECT 
c.customer_key,
c.first_name,
c.last_name,
SUM(o.sales_amount) AS total_revenue
FROM orders o
LEFT JOIN customers c
ON c.customer_key = o.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_revenue DESC;