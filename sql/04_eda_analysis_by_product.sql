-------------------------- 📊 EDA: PRODUCT PERFORMANCE --------------------------

-- 🔝 Top 5 Products by Revenue
WITH ranked_products AS (
    SELECT 
        p.product_name,
        SUM(o.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(o.sales_amount) DESC) AS rnk
    FROM orders o
    INNER JOIN products p
        ON o.product_key = p.product_key
    GROUP BY p.product_name
)
SELECT product_name, total_revenue
FROM ranked_products
WHERE rnk <= 5;

-- 🔻 Bottom 5 Products by Revenue
WITH ranked_products AS (
    SELECT 
        p.product_name,
        SUM(o.sales_amount) AS total_revenue,
        RANK() OVER (ORDER BY SUM(o.sales_amount)) AS rnk
    FROM orders o
    INNER JOIN products p
        ON o.product_key = p.product_key
    GROUP BY p.product_name
)
SELECT product_name, total_revenue
FROM ranked_products
WHERE rnk <= 5;


-------------------------- 💰 REVENUE ANALYSIS --------------------------

-- 📈 Revenue Contribution Percentage by Product
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS revenue,
    ROUND(100.0 * SUM(o.sales_amount) / SUM(SUM(o.sales_amount)) OVER (), 2) AS revenue_pct
FROM orders o
JOIN products p ON o.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 📅 Monthly Sales Trend
SELECT 
    DATE_TRUNC('month', order_date) AS month,
    SUM(sales_amount) AS monthly_sales
FROM orders
GROUP BY month
ORDER BY month;


-------------------------- 👥 CUSTOMER ANALYSIS --------------------------

-- 🏆 Top 5 Customers by Revenue
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(o.sales_amount) AS total_spent
FROM orders o
INNER JOIN customers c
    ON c.customer_key = o.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY total_spent DESC
LIMIT 5;

-- 🔁 Customer Purchase Frequency (Top 5)
SELECT 
    customer_key,
    COUNT(DISTINCT order_number) AS total_orders
FROM orders
GROUP BY customer_key
ORDER BY total_orders DESC
LIMIT 5;

-- 🔻 Customer Purchase Frequency (Lowest 5)
SELECT 
    customer_key,
    COUNT(DISTINCT order_number) AS total_orders
FROM orders
GROUP BY customer_key
ORDER BY total_orders 
LIMIT 5;


-------------------------- 📊 SALES BEHAVIOR --------------------------

-- 📉 Running Total of Sales
SELECT 
    order_date,
    SUM(sales_amount) AS daily_sales,
    SUM(SUM(sales_amount)) OVER (ORDER BY order_date DESC) AS running_total
FROM orders
GROUP BY order_date
ORDER BY order_date DESC;


-------------------------- 📦 PRODUCT INSIGHTS --------------------------

-- 🔝 Most Sold Products (by Quantity)
SELECT 
    p.product_name,
    SUM(o.quantity) AS total_quantity,
    o.price
FROM orders o
JOIN products p ON o.product_key = p.product_key
GROUP BY p.product_name, o.price
ORDER BY total_quantity DESC
LIMIT 5;

-- 🔻 Low Performing Products (by Revenue)
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS total_revenue,
    o.price
FROM orders o
JOIN products p ON o.product_key = p.product_key
GROUP BY p.product_name, o.price
ORDER BY total_revenue ASC
LIMIT 5;


-------------------------- 📊 REVENUE DISTRIBUTION --------------------------

-- 📌 Revenue per Product
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS total_revenue
FROM orders o
JOIN products p 
    ON o.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- 📌 Revenue Ranking (Descending)
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS revenue
FROM orders o
JOIN products p 
    ON o.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 📊 Running Revenue Calculation
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS revenue,
    SUM(SUM(o.sales_amount)) OVER (ORDER BY SUM(o.sales_amount) DESC) AS running_revenue
FROM orders o
JOIN products p 
    ON o.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 📊 Cumulative Revenue Percentage
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS revenue,
    ROUND(
        100.0 * SUM(SUM(o.sales_amount)) OVER (ORDER BY SUM(o.sales_amount) DESC) 
        / SUM(SUM(o.sales_amount)) OVER (), 
    2) AS cumulative_pct
FROM orders o
JOIN products p 
    ON o.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue DESC;

-- 🔻 Lowest Revenue Products
SELECT 
    p.product_name,
    SUM(o.sales_amount) AS revenue
FROM orders o
JOIN products p 
    ON o.product_key = p.product_key
GROUP BY p.product_name
ORDER BY revenue ASC;


-------------------------- 🧠 PRODUCT SEGMENTATION --------------------------

-- 📊 Product Segmentation (High / Average / Low)
WITH product_revenue AS (
    SELECT 
        p.product_name,
        SUM(o.sales_amount) AS revenue
    FROM orders o
    JOIN products p 
        ON o.product_key = p.product_key
    GROUP BY p.product_name
)
SELECT 
    product_name,
    revenue,
    CASE 
        WHEN revenue < (SELECT AVG(revenue) FROM product_revenue) THEN 'Low'
        WHEN revenue < (SELECT AVG(revenue) * 2 FROM product_revenue) THEN 'Average'
        ELSE 'High'
    END AS category
FROM product_revenue
ORDER BY revenue ASC;