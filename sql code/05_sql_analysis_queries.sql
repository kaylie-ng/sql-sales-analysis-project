-- A. Sales & Profit Performance
-- =====================================================

-- Monthly sales and profit by year

SELECT
    EXTRACT(YEAR FROM o.orderdate) AS year,
    EXTRACT(MONTH FROM o.orderdate) AS month,
    SUM(od.sales) AS total_sales,
    SUM(od.profit) AS total_profit
FROM orders o
JOIN orderdetails od 
    ON o.orderid = od.orderid
GROUP BY year, month
ORDER BY year, month;


-- Average profit per order

SELECT 
    AVG(total_profit_per_order) AS avg_profit_per_order
FROM (
    SELECT 
        orderid,
        SUM(profit) AS total_profit_per_order
    FROM orderdetails
    GROUP BY orderid
) AS order_profit;



-- =====================================================
-- B. Customer Analysis & Segmentation
-- =====================================================

-- Top 10 customers by number of orders

SELECT 
    c.customerid,
    c.customername,
    COUNT(o.orderid) AS order_count
FROM customers c
JOIN orders o 
    ON c.customerid = o.customerid
GROUP BY c.customerid, c.customername
ORDER BY order_count DESC
LIMIT 10;


-- Customers who have never purchased Furniture products

SELECT 
    c.customerid,
    c.customername
FROM customers c
WHERE NOT EXISTS (
    SELECT 1
    FROM orders o
    JOIN orderdetails od 
        ON o.orderid = od.orderid
    JOIN products p 
        ON p.productid = od.productid
    WHERE c.customerid = o.customerid
      AND p.category = 'Furniture'
);


-- Customers with more than 10 orders

SELECT 
    c.customerid,
    c.customername,
    COUNT(o.orderid) AS order_count
FROM customers c
JOIN orders o 
    ON o.customerid = c.customerid
GROUP BY c.customerid, c.customername
HAVING COUNT(o.orderid) > 10
ORDER BY order_count DESC;


-- Customer quartile based on total sales

SELECT
    c.customerid,
    c.customername,
    SUM(od.sales) AS total_sales,
    NTILE(4) OVER (
        ORDER BY SUM(od.sales) DESC
    ) AS sales_quartile
FROM customers c
JOIN orders o
    ON c.customerid = o.customerid
JOIN orderdetails od
    ON od.orderid = o.orderid
GROUP BY c.customerid, c.customername
ORDER BY sales_quartile, total_sales DESC;



-- =====================================================
-- C. Product Performance
-- =====================================================

-- Top 10 most purchased products in summer months

SELECT 
    p.productid,
    p.productname,
    SUM(od.quantity) AS total_quantity
FROM orderdetails od
JOIN orders o 
    ON o.orderid = od.orderid
JOIN products p 
    ON p.productid = od.productid
WHERE EXTRACT(MONTH FROM o.orderdate) IN (6, 7, 8)
GROUP BY p.productid, p.productname
ORDER BY total_quantity DESC
LIMIT 10;


-- Product profitability classification

SELECT 
    p.productid,
    p.productname,
    SUM(od.profit) AS total_profit,
    CASE
        WHEN SUM(od.profit) > 5000 THEN 'High'
        WHEN SUM(od.profit) > 1000 AND SUM(od.profit) <= 5000 THEN 'Medium'
        WHEN SUM(od.profit) > 0 AND SUM(od.profit) <= 1000 THEN 'Low'
        ELSE 'Loss'
    END AS profitability_group
FROM products p
LEFT JOIN orderdetails od 
    ON p.productid = od.productid
GROUP BY p.productid, p.productname
ORDER BY total_profit DESC;


-- Total quantity ordered for each product

SELECT 
    p.productid,
    p.productname,
    COALESCE(SUM(od.quantity), 0) AS total_quantity
FROM products p
LEFT JOIN orderdetails od 
    ON od.productid = p.productid
GROUP BY p.productid, p.productname
ORDER BY total_quantity DESC;


-- Top 5 Office Supplies products by total sales

SELECT 
    p.productid,
    p.productname,
    SUM(od.sales) AS total_sales
FROM products p
JOIN orderdetails od 
    ON p.productid = od.productid
WHERE p.category = 'Office Supplies'
GROUP BY p.productid, p.productname
ORDER BY total_sales DESC
LIMIT 5;


-- Product sales ranking within each category

SELECT
    p.productname,
    p.category,
    SUM(od.sales) AS total_sales,
    RANK() OVER (
        PARTITION BY p.category
        ORDER BY SUM(od.sales) DESC
    ) AS sales_rank
FROM products p
JOIN orderdetails od
    ON p.productid = od.productid
GROUP BY p.productname, p.category
ORDER BY p.category, sales_rank;


-- Cumulative quantity ordered by product over time

SELECT 
    p.productid,
    p.productname,
    o.orderdate,
    od.quantity,
    SUM(od.quantity) OVER (
        PARTITION BY p.productid 
        ORDER BY o.orderdate ASC, o.orderid ASC
    ) AS cumulative_quantity
FROM products p
JOIN orderdetails od 
    ON p.productid = od.productid
JOIN orders o 
    ON o.orderid = od.orderid
ORDER BY p.productid, o.orderdate;



-- =====================================================
-- D. Shipping Performance
-- =====================================================

-- Fastest shipping mode by average shipping time

SELECT 
    s.shipmode,
    AVG(s.shipdate - o.orderdate) AS avg_shipping_time
FROM shipments s
JOIN orders o 
    ON o.orderid = s.orderid
GROUP BY s.shipmode
ORDER BY avg_shipping_time ASC
LIMIT 1;



-- =====================================================
-- E. Filtering Orders
-- =====================================================

-- Technology orders in 2016 from Consumer or Home Office segments

SELECT * FROM orders o
JOIN customers c 
    ON o.customerid = c.customerid
JOIN orderdetails od 
    ON od.orderid = o.orderid
JOIN products p 
    ON p.productid = od.productid
WHERE c.segment IN ('Consumer', 'Home Office')
  AND p.category = 'Technology'
  AND EXTRACT(YEAR FROM o.orderdate) = 2016;