-- 1. Check total number of rows

SELECT COUNT(*) AS total_rows FROM raw;


-- 2. Preview raw data

SELECT * FROM raw LIMIT 10;


-- 3. Check missing values in key columns

SELECT *
FROM raw
WHERE orderid IS NULL OR orderid = ''
   OR orderdate IS NULL OR orderdate = ''
   OR shipdate IS NULL OR shipdate = ''
   OR customerid IS NULL OR customerid = ''
   OR productid IS NULL OR productid = '';


-- 4. Check duplicate row IDs

SELECT 
    rowid,
    COUNT(*) AS duplicate_count
FROM raw
GROUP BY rowid
HAVING COUNT(*) > 1;


-- 5. Check duplicate order-product rows

SELECT 
    orderid,
    productid,
    COUNT(*) AS duplicate_count
FROM raw
GROUP BY orderid, productid
HAVING COUNT(*) > 1;


-- 6. Check date format for orderdate and shipdate
-- Expected format: MM/DD/YYYY

SELECT *
FROM raw
WHERE orderdate !~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$'
   OR shipdate !~ '^[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}$';


-- 7. Check if ship date is earlier than order date

SELECT 
    orderid,
    orderdate,
    shipdate
FROM raw
WHERE TO_DATE(shipdate, 'MM/DD/YYYY') < TO_DATE(orderdate, 'MM/DD/YYYY');


-- 8. Check numeric format for quantity, sales, discount, and profit

SELECT *
FROM raw
WHERE quantity !~ '^-?[0-9]+(\.[0-9]+)?$'
   OR sales !~ '^-?[0-9]+(\.[0-9]+)?$'
   OR discount !~ '^-?[0-9]+(\.[0-9]+)?$'
   OR profit !~ '^-?[0-9]+(\.[0-9]+)?$';


-- 9. Check if discount is outside valid range 0 to 1

SELECT *
FROM raw
WHERE discount ~ '^-?[0-9]+(\.[0-9]+)?$'
  AND (
      discount::NUMERIC < 0
      OR discount::NUMERIC > 1
  );


-- 10. Check invalid quantity values

SELECT *
FROM raw
WHERE quantity ~ '^-?[0-9]+(\.[0-9]+)?$'
  AND quantity::NUMERIC <= 0;


-- 11. Check negative sales values

SELECT *
FROM raw
WHERE sales ~ '^-?[0-9]+(\.[0-9]+)?$'
  AND sales::NUMERIC < 0;


-- 12. Check customer ID consistency
-- One customerid should not have multiple customer names or segments

SELECT 
    customerid,
    COUNT(DISTINCT customername) AS customername_count,
    COUNT(DISTINCT segment) AS segment_count
FROM raw
GROUP BY customerid
HAVING COUNT(DISTINCT customername) > 1
    OR COUNT(DISTINCT segment) > 1;


-- 13. Check product ID consistency
-- One productid should not have multiple product names, categories, or subcategories

SELECT 
    productid,
    COUNT(DISTINCT productname) AS productname_count,
    COUNT(DISTINCT category) AS category_count,
    COUNT(DISTINCT subcategory) AS subcategory_count
FROM raw
GROUP BY productid
HAVING COUNT(DISTINCT productname) > 1
    OR COUNT(DISTINCT category) > 1
    OR COUNT(DISTINCT subcategory) > 1;


-- 14. Check shipment consistency by order
-- One orderid should normally have one shipment date and ship mode

SELECT 
    orderid,
    COUNT(DISTINCT shipdate) AS shipdate_count,
    COUNT(DISTINCT shipmode) AS shipmode_count
FROM raw
GROUP BY orderid
HAVING COUNT(DISTINCT shipdate) > 1
    OR COUNT(DISTINCT shipmode) > 1;