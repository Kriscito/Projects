/* 
Mexico Toy Store Data Exploration
Skills used: Joins, Aggregate Functions, SubQueries
*/

# Breaking Things Down By Performance Of Products

-- Products vs Items Sold
-- Displays the top five performing products from the all their stores

SELECT 
    Product_Name AS 'Best Selling Product',
    num_of_times AS 'Number of Units Sold'
FROM
    (SELECT 
        s.Product_ID, p.Product_Name, sum(units) AS num_of_times
    FROM
        sales s
    JOIN products p ON s.product_ID = p.product_ID
    GROUP BY 1 , 2) AS sub
ORDER BY 2 DESC
LIMIT 5;

-- Products vs Profits
-- Displays Items Grossing The Highest Profits Limited To The Top 10 Products

SELECT 
    product_name,
    SUM(units * product_price) AS 'Total Sales (USD)',
    (SUM(units * product_price) - SUM(units * product_cost)) AS 'Profit (USD)'
FROM
    sales s
        JOIN
    products p ON s.product_id = p.product_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

# Exploring The Dataset By Category

-- Categories Versus Sales Average
-- Displays The Categories Performing The Average Sales Of The Franchise

SELECT 
    p.product_category, COUNT(s.units)
FROM
    products p
        JOIN
    sales s ON p.product_id = s.Product_ID
GROUP BY 1
ORDER BY 2;

-- Category vs Product
-- Displays The Number Of Units Sold And Best Selling Per Category 

SELECT 
    p.product_category AS 'Category',
    sum(s.units) AS 'Total Number Of Units Sold',
    MAX(p.product_name) AS 'Best Selling Product'
FROM
    products p
        JOIN
    sales s ON p.product_id = s.Product_ID
GROUP BY 1
ORDER BY 2 DESC;

# Breaking Things Down By Store And Location

-- Store Vs Sales
-- Displays The Amount Of Items Sold And Profits Made Per Store

SELECT 
    st_store AS Store,
    sa_sales AS 'Units Sold',
    p_profit * sa_sales AS Profits
FROM
    (SELECT 
        st.Store_Name st_Store,
            SUM(sa.units) AS sa_sales,
            p.product_price - p.product_cost AS p_profit
    FROM
        stores st
    JOIN sales sa ON st.Store_ID = sa.Store_ID
    JOIN Products p ON sa.Product_ID = p.Product_ID
    GROUP BY 1 , 3) a
ORDER BY 3 DESC
LIMIT 10;

-- Sales vs Location
-- Analyses If There Is A Correlation Between Store Location And Total Sales

SELECT 
    st.store_location AS 'Store Location',
    SUM(sa.units) AS 'Total Units Sold',
    MAX(p.Product_name) AS 'Best Selling Product'
FROM
    stores st
        JOIN
    sales sa ON st.store_id = sa.store_id
        JOIN
    products p ON p.product_id = sa.product_id
GROUP BY 1
ORDER BY 2 DESC;

-- Sales Vs City
-- Displays Top 5 Cities Customers Visit The Most And The Most Popular Store In The City

SELECT 
    st.Store_city AS City,
    MAX(st.Store_Name) AS Store,
    SUM(sa.Units)
FROM
    stores st
        JOIN
    sales sa ON st.Store_ID = sa.Store_ID
GROUP BY 1
ORDER BY 3 desc
limit 5;

# Exploring The Store's Inventory

-- Product Vs Availability
-- Displays The 10 Most Products On Hand

SELECT 
    i.product_id, p.product_name Product, sum(i.stock_on_hand) as 'Stock On Hand'
FROM
    inventory i
        JOIN
    products p ON i.product_id = p.product_id
GROUP BY 1 , 2 
ORDER BY 3 DESC
LIMIT 10;

-- Store VS Stock On Hand
-- Displays 10 Stores With The 10 Highest Inventory

SELECT 
    s.Store_name as 'Store', s.Store_location as 'Store Location', SUM(i.stock_on_hand) as 'Stock On Hand'
FROM
    inventory i
        JOIN
    stores s ON s.store_id = i.store_id
GROUP BY 1 , 2
ORDER BY 3 DESC
LIMIT 10;

