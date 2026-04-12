----------------Cumulative Analysis---------------
--Calculate the total sales per month
--and the running total of sales over time

SELECT  
    month,
    year,
    monthly_sales,
    SUM(monthly_sales) OVER (
        PARTITION BY year 
        ORDER BY month
    ) AS running_total
FROM (
    SELECT  
        DATE_TRUNC('month', order_date) AS month,
        EXTRACT(YEAR FROM order_date) AS year,
        SUM(sales_amount) AS monthly_sales
    FROM orders
    GROUP BY month, year
) t
ORDER BY year, month;


--Performance analysis-
--analyze the yearly perfomance of products by comparing their sales
--to both the average sales performance of the product and the previous year's sales

WITH yearly_product_sales AS(
	SELECT 
	EXTRACT(YEAR FROM o.order_date) AS order_year,
	p.product_name,
	o.sales_amount,
	SUM(o.sales_amount) AS current_sales
	FROM orders o
	INNER JOIN products p
	ON o.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY 
	order_year,
	p.product_name,
	o.sales_amount
)
SELECT 
order_year,
product_name,
current_sales,
AVG(current_sales) OVER (PARTITION BY product_name) as avg_sales,
current_sales - AVG(current_sales) OVER (PARTITION BY product_name) as diff_avg,
CASE WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name)> 0 THEN 'above avg'
	WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name)< 0 THEN 'below avg'
	ELSE 'AVG'
END avg_change,
LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) py_sales,
current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS diff_py,
CASE WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)> 0 THEN 'increasing'
	WHEN current_sales -LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year)< 0 THEN 'decreasing'
	ELSE 'AVG'
END py_change
FROM yearly_product_sales
ORDER BY product_name, order_year


--which categories contribute the most to overall sales

WITH category_sales AS(
SELECT 
category,
SUM(sales_amount) total_sales
FROM orders o
INNER JOIN products p
ON o.product_key = p.product_key
GROUP BY category
)
SELECT
category,
total_sales,
SUM(total_sales) OVER() overall_sales,
ROUND((total_sales /SUM(total_sales) OVER())*100,2) || '%' AS percentage_of_total
FROM category_sales

--Segment products into cost ranges and count how many products fall into each segment
WITH product_segments AS (
SELECT
product_key,
product_name,
cost,
CASE WHEN cost <100 THEN 'BELOW 100'
	WHEN cost BETWEEN 100 AND 500 THEN '100-500'
	WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
	ELSE 'above 1000'
END cost_range
FROM products p
)
SELECT 
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC


--Group customers into 3 segments based on their spending behavior;
	--VIP:Customers with at least 12 months if history and spending more than 5000.
	--regular:Customers with at least 12 months of history but spending less than 5000
	-- New: Customers with a lifespan less than 12month
--and find the total number of customers by each group
WITH customer_spending AS (
SELECT
    c.customer_key,
    SUM(o.sales_amount) AS total_spending,
    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS last_order,
    DATE_PART('month', AGE(MAX(o.order_date), MIN(o.order_date))) 
    + 12 * DATE_PART('year', AGE(MAX(o.order_date), MIN(o.order_date))) 
    AS lifespan
FROM orders o
INNER JOIN customers c
    ON o.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT 
customer_segment,
COUNT(customer_key) total_customer
FROM(
	SELECT
	customer_key,
	CASE WHEN lifespan >= 12 AND total_spending >5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'NEW'
	END customer_segment
	FROM customer_spending
	) t
GROUP BY customer_segment
ORDER BY total_customer DESC




































