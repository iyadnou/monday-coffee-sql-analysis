-- Activity1
CREATE DATABASE IF NOT EXISTS monday_coffee;
USE monday_coffee;

CREATE TABLE IF NOT EXISTS city (
    city_id INT PRIMARY KEY,
    city_name VARCHAR(100),
    population INT,
    estimated_rent DECIMAL(10,2),
    city_rank INT
);

CREATE TABLE IF NOT EXISTS customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    city_id INT,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE IF NOT EXISTS products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    price DECIMAL(10,2)
    );

CREATE TABLE IF NOT EXISTS sales (
    sale_id INT PRIMARY KEY,
    sale_date DATE,
    product_id INT,
    quantity INT,
    customer_id INT,
    total_amount DECIMAL(10,2),
    rating DECIMAL(3,2),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);
-- Activity 2
-- 2.1 Identify NULL values
-- 2.1.1 city
SELECT
    'city' AS table_name,
    SUM(city_id IS NULL) AS city_id_nulls,
    SUM(city_name IS NULL) AS city_name_nulls,
    SUM(population IS NULL) AS population_nulls,
    SUM(estimated_rent IS NULL) AS estimated_rent_nulls,
    SUM(city_rank IS NULL) AS city_rank_nulls
FROM city;

-- 2.1.2 customers
SELECT
    'customers' AS table_name,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(customer_name IS NULL) AS customer_name_nulls,
    SUM(city_id IS NULL) AS city_id_nulls
FROM customers;

-- 2.1.3 products
SELECT
    'products' AS table_name,
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(product_name IS NULL) AS product_name_nulls,
    SUM(price IS NULL) AS price_nulls
FROM products;

-- 2.1.4 sales
SELECT
    'sales' AS table_name,
    SUM(sale_id IS NULL) AS sale_id_nulls,
    SUM(sale_date IS NULL) AS sale_date_nulls,
    SUM(product_id IS NULL) AS product_id_nulls,
    SUM(quantity IS NULL) AS quantity_nulls,
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(total_amount IS NULL) AS total_amount_nulls,
    SUM(rating IS NULL) AS rating_nulls
FROM sales;

-- 2.2 Check for duplicate customers
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- 2.3 Check for mismatches between total_amount and price * quantity
SELECT
    s.sale_id,
    s.product_id,
    s.quantity,
    p.price,
    s.total_amount,
    (p.price * s.quantity) AS calculated_amount
FROM sales s
JOIN products p
    ON s.product_id = p.product_id
WHERE s.total_amount <> (p.price * s.quantity);

-- 2.3.1 clean the data
UPDATE sales s
JOIN products p
    ON s.product_id = p.product_id
SET s.total_amount = p.price * s.quantity
WHERE s.sale_id IN (484, 1493, 1799);

-- Activity 3
-- Activity 3: Data Transformation & Integration
-- Create a comprehensive sales report with customer and product details

SELECT
    s.sale_id,
    s.sale_date,
    c.customer_id,
    c.customer_name,
    ci.city_name,
    p.product_id,
    p.product_name,
    p.price,
    s.quantity,
    s.total_amount,
    s.rating
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
JOIN products p
    ON s.product_id = p.product_id;

 
-- Activity 4: Data Analysis & Aggregation
-- (a) Total Sales per City

SELECT
    ci.city_name,
    SUM(s.total_amount) AS total_sales
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name;


-- (b) Total Transactions per City

SELECT
    ci.city_name,
    COUNT(s.sale_id) AS total_transactions
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name;

-- (c) Unique Customers per City
SELECT
    ci.city_name,
    COUNT(DISTINCT c.customer_id) AS unique_customers
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name;


-- (d) Average Order Value per City
SELECT
    ci.city_name,
    AVG(s.total_amount) AS average_order_value
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name;

-- (e) Product Demand per City
SELECT
    ci.city_name,
    p.product_name,
    SUM(s.quantity) AS total_quantity_sold
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
JOIN products p
    ON s.product_id = p.product_id
GROUP BY ci.city_id, ci.city_name, p.product_id, p.product_name
ORDER BY ci.city_name, total_quantity_sold DESC;


-- (f) Monthly Sales Trend
SELECT
    DATE_FORMAT(sale_date, '%Y-%m') AS month,
    SUM(total_amount) AS monthly_sales
FROM sales
GROUP BY DATE_FORMAT(sale_date, '%Y-%m');


-- (g) Customer Rating Analysis
SELECT
    ci.city_name,
    AVG(s.rating) AS average_rating
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name;

-- Activity 5: Decision-Making & Recommendations
-- (a) Top 3 Cities Selection


SELECT
    ci.city_name,
    SUM(s.total_amount) AS total_sales,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    COUNT(s.sale_id) AS order_count
FROM sales s
JOIN customers c
    ON s.customer_id = c.customer_id
JOIN city ci
    ON c.city_id = ci.city_id
GROUP BY ci.city_id, ci.city_name
ORDER BY
    total_sales DESC,
    unique_customers DESC,
    order_count DESC
LIMIT 3;

