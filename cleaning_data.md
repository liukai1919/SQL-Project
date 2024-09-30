## Data Cleaning Issues to Address

1. **Remove Invalid City and Country Values**: Filter out rows where the `city` or `country` columns contain `"(not set)"` or `"not available in demo dataset"`.
2. **Round Transaction Revenue**: Ensure the `transaction_revenue` values are rounded to two decimal places for better readability and accuracy.
3. **Remove Zero `total_ordered` Values**: Rows where `total_ordered` is 0 represent no sales, and should be removed from the analysis.
4. **Remove Negative `total_ordered` Values**: Check for any negative values in `total_ordered` and remove them as they represent incorrect data.
5. **Remove Unmatched Product SKUs**: There are two SKUs in the `sales_by_sku` table that do not match any entries in the `products`, `all_sessions`, or `sales_report` tables, and these should be removed.
6. **Filter Out Rows with No Sales**: Some rows in the `all_sessions` and `analytics` tables represent sessions where no sales were made. These should be filtered out for relevant analysis.

## SQL Queries Used for Data Cleaning

```sql
-- 1. Remove rows with invalid city or country values
SELECT * FROM all_sessions 
WHERE city IN ('(not set)', 'not available in demo dataset') 
OR country IN ('(not set)', 'not available in demo dataset');

-- 2. Round transaction revenue to two decimal places
SELECT ROUND(SUM(productprice/1000000), 2) AS transactionrevenue 
FROM all_sessions;

-- 3. Identify rows where total_ordered is 0
SELECT * FROM all_sessions 
WHERE total_ordered = 0;

-- 4. Identify rows with negative total_ordered values
SELECT * FROM all_sessions 
WHERE total_ordered < 0;

-- 5. Identify and delete unmatched product SKUs from sales_by_sku table
-- First, find the unmatched SKUs
SELECT productsku 
FROM sales_by_sku 
WHERE productsku NOT IN (SELECT DISTINCT sku FROM products) 
AND total_ordered > 0;

-- Delete the unmatched SKUs from sales_by_sku table
DELETE FROM sales_by_sku 
WHERE productsku IN (
    SELECT productsku 
    FROM sales_by_sku 
    WHERE productsku NOT IN (SELECT DISTINCT sku FROM products) 
    AND total_ordered > 0
);

-- 6. Filter out rows where no units were sold from the analytics table
SELECT DISTINCT * 
FROM analytics 
WHERE units_sold != 0;

```