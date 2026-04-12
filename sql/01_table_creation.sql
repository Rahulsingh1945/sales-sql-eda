CREATE TABLE customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(20),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(20),
    gender VARCHAR(10),
    birthdate DATE,
    create_date DATE
);

copy customers
FROM 'C:/project list/csv_file/dim_customers.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(100),
    category_id VARCHAR(20),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(10),
    cost NUMERIC,
    product_line VARCHAR(50),
    start_date DATE
);

copy products
FROM 'C:/project list/csv_file/dim_products.csv'
DELIMITER ','
CSV HEADER;

CREATE TABLE orders (
    order_number VARCHAR(20),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount NUMERIC,
    quantity INT,
    price NUMERIC
);

copy orders
FROM 'C:/project list/csv_file/fact_sales.csv'
DELIMITER ','
CSV HEADER;
