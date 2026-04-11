---------------Analysis pattern over time------------

--sale per year
SELECT  
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM orders
WHERE order_date IS NOT NULL
GROUP BY order_month
ORDER BY order_month;

SELECT  
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) as total_customers,
	SUM(quantity) as total_quantity
FROM orders
WHERE order_date IS NOT NULL
GROUP BY order_year
ORDER BY order_year;


SELECT  
    TO_CHAR(order_date, 'Day') AS day_name,
    SUM(sales_amount) AS total_sales
FROM orders
GROUP BY day_name
ORDER BY total_sales DESC;


























