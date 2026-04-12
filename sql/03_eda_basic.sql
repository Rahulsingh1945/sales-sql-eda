--finding location of custumers
SELECT DISTINCT country FROM customers;

--finding details of catagory
SELECT DISTINCT category, subcategory, product_name FROM products
ORDER BY 1,2,3;

--HOW MANY YEARS OF SALES ARE AVAILABLE
SELECT 
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    AGE(MAX(order_date), MIN(order_date)) AS difference
FROM orders;

--finding customers age
SELECT 
    MAX(birthdate) AS youngest_customer,
    AGE(MAX(birthdate)) AS youngest_age,
    
    MIN(birthdate) AS oldest_customer,
    AGE(MIN(birthdate)) AS oldest_age
FROM customers;

--find the total sales
SELECT SUM(sales_amount) AS total_sales 
FROM orders;

--finding total quantity
SELECT SUM(quantity) AS total_quantity
FROM orders;

--finding avg pricing
SELECT ROUND(AVG(price::numeric), 2) AS average_price
FROM orders;

--total_number of order
SELECT COUNT(order_number) AS total_orders,
COUNT(DISTINCT order_number) AS total_distincta_orders
FROM orders;

--find the total number of product
SELECT COUNT(DISTINCT product_name) as total_product
FROM products;

--FIND THE TOTAL NUMBER OF CUSTOMER
SELECT COUNT(DISTINCT customer_number) AS total_customer
FROM customers;

--TOTAL NUMBER OF CUSTOMER WHO PLACED ORDER
SELECT COUNT(DISTINCT customer_key) AS total_customer
FROM customers;

SELECT 'total_sales' AS measure_name, SUM(quantity) AS measure_value
FROM orders
UNION ALL
SELECT 'total_sales', SUM(sales_amount) AS total_sales 
FROM orders
UNION ALL
SELECT 'average_price',ROUND(AVG(price::numeric), 2) AS average_price
FROM orders
UNION ALL
SELECT 'total_order',COUNT(DISTINCT order_number) AS total_distinct_orders
FROM orders
UNION ALL
SELECT 'total_customer', COUNT(DISTINCT customer_number) AS total_customer
FROM customers
UNION ALL
SELECT 'customer_key', COUNT(DISTINCT customer_key) AS total_customer
FROM customers;



-------------------------------------------------------------------------------------
--EXPLORATION OF BIG NUMBER--


--Find the total sales
SELECT SUM(sales_amount) AS total_sales FROM orders

--Find how many items are sold
SELECT SUM(quantity) AS total_sales FROM orders

--Find average selling price
SELECT AVG(price) AS avg_price FROM orders

--Find  total number of order
SELECT COUNT(order_number) AS total_orders FROM orders;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM orders;

--Find total number of products
SELECT COUNT(product_name) AS total_products FROM products;
SELECT COUNT(DISTINCT product_name) AS total_products FROM products;

--Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM customers;

--find the total number of customers that has placed order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM customers;



--Generate a report that shows all key matrics of the business 
SELECT 'Total Sales' as measure_name, SUM(sales_amount) AS measure_value FROM orders
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM orders
UNION ALL 
SELECT 'Average Price' , ROUND(AVG(price), 2)  FROM orders
UNION ALL
SELECT 'Total order', COUNT(DISTINCT order_number) FROM orders
UNION ALL
SELECT 'Total Products', COUNT(DISTINCT product_name) FROM products
UNION ALL
SELECT 'Total customer', COUNT(customer_key) FROM customers;
