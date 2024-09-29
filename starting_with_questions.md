Answer the following questions and provide the SQL queries used to find the answer.

    
**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**


SQL Queries:
```SQL
SELECT city, country, 
       ROUND(SUM(productPrice/1000000), 2) AS transactionrevenue 
FROM all_sessions
where city not in ('(not set)','not available in demo dataset')
GROUP BY city, country
ORDER BY transactionrevenue DESC;
```
Answer:




**Question 2: What is the average number of products ordered from visitors in each city and country?**

```SQL
SQL Queries:
select round(avg(total_ordered),0) as avg_total_ordered, city, country from sales_report
join all_sessions on sales_report.productsku = all_sessions.productsku
where city not in ('(not set)','not available in demo dataset')
group by city, country
order by avg_total_ordered desc;

or
select round(avg(total_ordered),0) as avg_total_ordered, city, country from sales_by_sku
join all_sessions on sales_by_sku.productsku = all_sessions.productsku
where city not in ('(not set)','not available in demo dataset')
group by city, country
order by avg_total_ordered desc;
```

Answer:





**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**


SQL Queries:
```SQL
select channelgrouping,count(*) as num_groups, city,country from all_sessions join products p 
on all_sessions.productsku = p.sku
where city not in ('(not set)','not available in demo dataset')
group by city, country, channelgrouping
order by city, country,num_groups desc;

select channelgrouping,count(*) as num_groups, country from all_sessions join products p 
on all_sessions.productsku = p.sku
where city not in ('(not set)','not available in demo dataset')
group by  country, channelgrouping
order by country,num_groups desc;
```



Answer:





**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**


SQL Queries:
```SQL
WITH RankedProducts AS (
    SELECT
        country,
        city,
        name,
        v2productname,
        v2productcategory,
        round(productPrice/1000000 * total_ordered,2) as revenue,
        total_ordered,
        ROW_NUMBER() OVER (PARTITION BY country, city ORDER BY total_ordered DESC) AS rank
    FROM sales_report join all_sessions on sales_report.productsku = all_sessions.productsku
    where city not in ('(not set)','not available in demo dataset')
)
SELECT country, city, name, v2productname,v2productcategory,revenue, total_ordered
FROM RankedProducts
WHERE rank = 1
ORDER BY country, city;
```

Answer:





**Question 5: Can we summarize the impact of revenue generated from each city/country?**

SQL Queries:



Answer:







