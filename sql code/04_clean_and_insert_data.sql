-- 1. Clean customer data by removing duplicates, then insert into customers table

INSERT INTO customers (customerid, customername, segment)
SELECT DISTINCT
    customerid,
    customername,
    segment
FROM raw;


-- 2. Clean product data by removing duplicates, then insert into products table

INSERT INTO products (productid, productname, category, subcategory)
SELECT DISTINCT
    productid,
    productname,
    category,
    subcategory
FROM raw
ON CONFLICT (productid) DO NOTHING;


-- 3. Clean order data by converting orderdate from text to DATE, then insert into orders table

INSERT INTO orders (orderid, orderdate, customerid)
SELECT DISTINCT
    orderid,
    TO_DATE(orderdate, 'MM/DD/YYYY') AS orderdate,
    customerid
FROM raw;


-- 4. Clean order detail data by converting numeric fields, then insert into orderdetails table

INSERT INTO orderdetails (orderid, productid, quantity, sales, discount, profit)
SELECT DISTINCT
    orderid,
    productid,
    quantity::NUMERIC(10, 2) AS quantity,
    sales::NUMERIC(10, 2) AS sales,
    discount::NUMERIC(5, 2) AS discount,
    profit::NUMERIC(10, 2) AS profit
FROM raw;


-- 5. Clean shipment data by converting shipdate from text to DATE, then insert into shipments table

INSERT INTO shipments (
    orderid,
    shipmode,
    shipdate,
    country,
    city,
    state,
    postalcode,
    region
)
SELECT DISTINCT
    orderid,
    shipmode,
    TO_DATE(shipdate, 'MM/DD/YYYY') AS shipdate,
    country,
    city,
    state,
    postalcode,
    region
FROM raw;