# PostgreSQL Sales Data Cleaning & Analysis

## Objective

This project uses PostgreSQL to analyse a retail sales order dataset and uncover insights about sales performance, profitability, customer value, product performance, and shipping efficiency.

## Dataset

The dataset contains historical order records from a retail business, including customer information, product details, order dates, shipping details, sales, quantity, discount, and profit.

## Tools Used

- PostgreSQL
- SQL
- pgAdmin
- ERD / relational data modelling

## Project Workflow

1. Imported raw CSV data into a staging table.
2. Checked data quality issues, including date formats, numeric formats, discount range, and shipping date logic.
3. Designed a relational data model with 5 final tables:
    - `customers`
    - `products`
    - `orders`
    - `orderdetails`
    - `shipments`
4. Converted raw text fields into proper data types such as `DATE` and `NUMERIC`.
5. Inserted cleaned data into final tables.
6. Used SQL queries to answer business questions around sales, customers, products, and shipping.

## Key Analysis Areas

- Sales and profit performance over time
- Customer value and purchasing behavior
- Product, category, and seasonal demand performance
- Shipping method efficiency
- Customer and product segmentation using SQL ranking and window functions

## Key Findings

- Total sales reached approximately **2.30M**, with total profit of around **286.4K**. **2017** was the strongest year for both sales and profit.
- Sales and profit varied by month and year, showing that business performance was not evenly distributed over time.
- **Technology** was the strongest category in both sales and profit, while **Furniture** generated high sales but weaker profitability.
- Revenue was highly concentrated among top customers, with the top 25% contributing around **55% of total sales**.
- Some high-sales customers were not always high-profit customers, showing the need to analyze both revenue and profitability.
- **Standard Class** was the most used shipping method but had the longest average delivery time, while **Same Day** was the fastest but used less often.
- SQL window functions helped identify customer quartiles, product rankings within categories, and cumulative product demand over time.

## Repository Structure

```
sql-sales-analysis/
│
├── README.md
│
├── data/
│   └── orders.csv
│
├── sql/
│   ├── 01_create_raw_table.sql
│   ├── 02_create_final_tables_and_ERD.sql
│   ├── 03_data_quality_check.sql
│   ├── 04_clean_and_insert_data.sql
│   └── 05_sql_analysis_queries.sql
│
└── images/
    ├── erd.png
    └── workflow.png
```

## Skills Demonstrated

- SQL data cleaning and transformation
- Relational database modelling
- Primary key and foreign key relationships
- Data quality check
- Joins, aggregations, CTEs, subqueries, and window functions
- SQL queries to answer business questions
