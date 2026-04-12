/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
===============================================================================
*/

-- =============================================================================
-- Create Report: report_customers
-- =============================================================================

CREATE VIEW report_customers AS
WITH base_query AS(
	SELECT 
		o.order_number,
		o.product_key,
		o.order_date,
		o.sales_amount,
		o.quantity,
		c.customer_key,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		DATE_PART('year', AGE(CURRENT_DATE, c.birthdate)) AS age
	FROM orders o
	INNER JOIN customers c
		ON c.customer_key = o.customer_key
	WHERE o.order_date IS NOT NULL
),
customer_aggregation AS (
	SELECT
		customer_key,
		customer_name,
		age,
		MAX(order_date) AS last_order,
		DATE_PART('year', AGE(MAX(order_date), MIN(order_date))) * 12 
		+ DATE_PART('month', AGE(MAX(order_date), MIN(order_date))) AS lifespan_months,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products
	FROM base_query
	GROUP BY 
		customer_key,
		customer_name,
		age
)
SELECT 
	customer_key,
	customer_name,
	age,
	lifespan_months,
	total_orders,
	total_sales,
	total_quantity,
	total_products,

	CASE 
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_group,

	CASE 
		WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,

	last_order,

	DATE_PART('year', AGE(CURRENT_DATE, last_order)) * 12 
	+ DATE_PART('month', AGE(CURRENT_DATE, last_order)) AS recency,

	total_sales / NULLIF(total_orders, 0)::numeric AS avg_order_value,
	total_sales / NULLIF(lifespan_months, 0)::numeric AS avg_monthly_spend

FROM customer_aggregation;

--customer_report--
COPY (
    SELECT * FROM report_customers
) 
TO 'C:\project list\retail_project\data\\customer_report.csv'
DELIMITER ','
CSV HEADER;



















