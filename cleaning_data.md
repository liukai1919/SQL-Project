What issues will you address by cleaning the data?
1. Remove the "(not set)" and "not available in demo dataset" values from the city and country columns.
2. Round the transaction revenue to 2 decimal places. 
3. There are some total_ordered values that are 0, I will remove them. 
4. Check if there are any total_ordered values that are negative, if there are, I will remove them. 



Queries:
Below, provide the SQL queries you used to clean your data.
```SQL
1. select * fromm all_sessions where city in ('(not set)','not available in demo dataset');
2. select round(sum(productprice/1000000),2) as transactionrevenue from all_sessions;
3. select * from all_sessions where total_ordered = 0;
4. select * from all_sessions where total_ordered < 0;
```