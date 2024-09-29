Answer the following questions and provide the SQL queries used to find the answer.

    
**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**


SQL Queries:
```SQL
SELECT city, 
       ROUND(SUM(productPrice/1000000 * total_ordered), 2) AS transactionrevenue 
FROM all_sessions join sales_report on all_sessions.productsku = sales_report.productsku
where city not in ('(not set)','not available in demo dataset') and transactionrevenue > 0
GROUP BY city
ORDER BY transactionrevenue DESC;

SELECT country, 
       ROUND(SUM(productPrice/1000000 * total_ordered), 2) AS transactionrevenue 
FROM all_sessions join sales_report on all_sessions.productsku = sales_report.productsku
where country not in ('(not set)','not available in demo dataset') and transactionrevenue > 0
GROUP BY country
ORDER BY transactionrevenue DESC;
```
Answer:
according to the data, the city with the highest transaction revenue is Mountain View, USA with a revenue of $1.24 million. The country with the highest transaction revenue is the USA with a revenue of $5.33 million. however, there are some products that total_ordered value is 0, I will remove them in my analysis. I also checked if there are any negative values in the total_ordered column, and there are none.



**Question 2: What is the average number of products ordered from visitors in each city and country?**


SQL Queries:
```SQL
-- avg number of products ordered from visitors in each city
select round(avg(total_ordered),0) as avg_total_ordered, city from sales_report
join all_sessions on sales_report.productsku = all_sessions.productsku
where city not in ('(not set)','not available in demo dataset') and total_ordered > 0
group by city
order by avg_total_ordered desc;
--or
select round(avg(total_ordered),0) as avg_total_ordered, city from sales_by_sku
join all_sessions on sales_by_sku.productsku = all_sessions.productsku
where city not in ('(not set)','not available in demo dataset') and total_ordered > 0
group by city, country
order by avg_total_ordered desc;

-- avg number of products ordered from visitors in each country
select round(avg(total_ordered),0) as avg_total_ordered, country from sales_report
join all_sessions on sales_report.productsku = all_sessions.productsku
where country not in ('(not set)','not available in demo dataset') and total_ordered > 0
group by country
order by avg_total_ordered desc;
--or
select round(avg(total_ordered),0) as avg_total_ordered, country from sales_by_sku
join all_sessions on sales_by_sku.productsku = all_sessions.productsku
where country not in ('(not set)','not available in demo dataset') and total_ordered > 0
group by country
order by avg_total_ordered desc;
```

Answer:
I found two solutions for this question, one for city and one for country, I can either use the sales_report table or the sales_by_sku table to join with the all_sessions table. 
the results are the same for both city and country.
results:
each city:
| #  | avg_total_ordered | city                    |      
|----|-------------------|-------------------------|
| 1  | 319               | Riyadh                  |
| 2  | 319               | Brno                    |
| 3  | 251               | Rexburg                 |
| 4  | 189               | Sacramento              |
| 5  | 189               | Lisbon                  |
| 6  | 146               | Sherbrooke              |
| 7  | 135               | Saint Petersburg        |
| 8  | 130               | Rome                    |
| 9  | 105               | Kalamazoo               |
| 10 | 100               | Avon                    |
each country:
| #  | avg_total_ordered | country           |
|----|-------------------|-------------------|
| 1  | 135               | Saudi Arabia      |
| 2  | 114               | Kuwait            |
| 3  | 112               | Honduras          |
| 4  | 85                | Ethiopia          |
| 5  | 85                | Oman              |
| 6  | 85                | Laos              |
| 7  | 58                | Papua New Guinea  |
| 8  | 58                | South Korea       |
| 9  | 57                | Croatia           |
| 10 | 50                | Albania           |



**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**


SQL Queries:
```SQL
-- channelgrouping each city
select channelgrouping,count(*) as num_groups, city from all_sessions 
where city not in ('(not set)','not available in demo dataset')
group by city, channelgrouping
order by city, country,num_groups desc;
-- channelgrouping each country
select channelgrouping,count(*) as num_groups, country from all_sessions join products p 
on all_sessions.productsku = p.sku
where country not in ('(not set)','not available in demo dataset')
group by  country, channelgrouping
order by country,num_groups desc;
-- productcategory each city
select  v2productcategory,count(*) as num_groups, city from all_sessions 
where city not in ('(not set)','not available in demo dataset')
group by city, v2productcategory
order by city, num_groups desc;
-- productcategory each country
select v2productcategory,count(*) as num_groups, country from all_sessions 
where country not in ('(not set)','not available in demo dataset')
group by  country, v2productcategory
order by country,num_groups desc;
```

Answer:
Most of the products are ordered from the USA, and the 2nd most ordered's channel is "Referral", orther countriy's "Referral" order is in 3rd place. the most popular channel is "Organic Search", and the most popular product category is "Shop by Brand" or "Apparel".



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
-- SELECT country, city, name, v2productname, v2productcategory, revenue, total_ordered
-- FROM RankedProducts
-- WHERE rank = 1 and revenue > 0
-- ORDER BY country, city;

select v2productcategory,count(*) as num_groups from RankedProducts
where rank = 1 and revenue > 0
group by v2productcategory
order by num_groups desc;
```

Answer:
As we can see from the results, the most popular top-selling product categories are "Shop by Brand", office,drinkware, apparel, bags and sercurity cameras. 



**Question 5: Can we summarize the impact of revenue generated from each city/country?**

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
WHERE rank = 1 and revenue > 0
ORDER BY revenue DESC;
```


Answer:
According to the data, I believe that the factor that affects the revenue is location, top 15 highest revenue are all from america(except Dublin). If we take a look on top 20 cities with highest revenue, we can find that They are most from developed countries, even though some few counties are not developed, their cities are all capital cities which means their imcome level is high.





