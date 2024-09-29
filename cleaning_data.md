What issues will you address by cleaning the data?
1. Remove the "(not set)" and "not available in demo dataset" values from the city and country columns.
2. Round the transaction revenue to 2 decimal places. 
3. There are some total_ordered values that are 0, I will remove them. 
4. Check if there are any total_ordered values that are negative, if there are, I will remove them. 
5. There are two productskus in sales_by_sku table that can not match products table, all_sessions table and sals_report table, I will remove it.
6. There are some some rows in all_sessions table and analytics table that that don't sold anything, I will filter them out.




Queries:
Below, provide the SQL queries you used to clean your data.
```SQL
1. select * fromm all_sessions where city in ('(not set)','not available in demo dataset');
2. select round(sum(productprice/1000000),2) as transactionrevenue from all_sessions;
3. select * from all_sessions where total_ordered = 0;
4. select * from all_sessions where total_ordered < 0;
5. select * from all_sessions where productsku in (
    select productsku from sales_by_sku where productsku not in (select DISTINCT sku from products) and total_ordered > 0
    )
    delete from sales_by_sku where productsku in (
        select productsku from sales_by_sku where productsku not in (select DISTINCT sku from products) and total_ordered > 0
    )
6. SELECT DISTINCT * FROM analytics WHERE units_sold != 0
```