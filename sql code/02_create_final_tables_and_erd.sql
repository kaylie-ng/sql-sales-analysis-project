-- 1. Create customers table

CREATE TABLE customers (
    customerid VARCHAR(255) PRIMARY KEY,
    customername VARCHAR(255) NOT NULL,
    segment VARCHAR(255) NOT NULL
);


-- 2. Create products table

CREATE TABLE products (
    productid VARCHAR(255) PRIMARY KEY,
    productname TEXT NOT NULL,
    category VARCHAR(255) NOT NULL,
    subcategory VARCHAR(255) NOT NULL
);


-- 3. Create orders table

CREATE TABLE orders (
    orderid VARCHAR(255) PRIMARY KEY,
    orderdate DATE NOT NULL,
    customerid VARCHAR(255) NOT NULL,
    FOREIGN KEY (customerid) REFERENCES customers(customerid)
);


-- 4. Create orderdetails table

CREATE TABLE orderdetails (
    orderdetailid SERIAL PRIMARY KEY,
    orderid VARCHAR(255) NOT NULL,
    productid VARCHAR(255) NOT NULL,
    quantity NUMERIC(10, 2) NOT NULL,
    sales NUMERIC(10, 2) NOT NULL,
    discount NUMERIC(5, 2) NOT NULL,
    profit NUMERIC(10, 2) NOT NULL,
    FOREIGN KEY (orderid) REFERENCES orders(orderid),
    FOREIGN KEY (productid) REFERENCES products(productid)
);


-- 5. Create shipments table

CREATE TABLE shipments (
    shipmentid SERIAL PRIMARY KEY,
    orderid VARCHAR(255) NOT NULL,
    shipmode VARCHAR(255) NOT NULL,
    shipdate DATE NOT NULL,
    country VARCHAR(255) NOT NULL,
    city VARCHAR(255) NOT NULL,
    state VARCHAR(255) NOT NULL,
    postalcode VARCHAR(255) NOT NULL,
    region VARCHAR(255) NOT NULL,
    FOREIGN KEY (orderid) REFERENCES orders(orderid)
);