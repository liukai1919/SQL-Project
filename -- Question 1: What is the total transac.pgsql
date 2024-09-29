-- Question 1: What is the total transaction revenue for each city and country?
SELECT city, 
       ROUND(SUM(productPrice/1000000 * total_ordered), 2) AS transactionrevenue 
FROM all_sessions join sales_report on all_sessions.productsku = sales_report.productsku
where city not in ('(not set)','not available in demo dataset')
GROUP BY city
ORDER BY transactionrevenue DESC;

SELECT country, 
       ROUND(SUM(productPrice/1000000 * total_ordered), 2) AS transactionrevenue 
FROM all_sessions join sales_report on all_sessions.productsku = sales_report.productsku
where country not in ('(not set)','not available in demo dataset')
GROUP BY country
ORDER BY transactionrevenue DESC;

-- Question 2: What is the average number of products ordered per transaction for each city and country?
select round(avg(total_ordered),0) as avg_total_ordered, city, country from sales_report
join all_sessions on sales_report.productsku = all_sessions.productsku
where city not in ('(not set)','not available in demo dataset')
group by city, country
order by avg_total_ordered desc;

select round(avg(total_ordered),0) as avg_total_ordered, city, country from sales_by_sku
join all_sessions on sales_by_sku.productsku = all_sessions.productsku
where city not in ('(not set)','not available in demo dataset')
group by city, country
order by avg_total_ordered desc;

-- Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?
select channelgrouping,count(*) as num_groups, city,country from all_sessions join products p 
on all_sessions.productsku = p.sku
where city not in ('(not set)','not available in demo dataset')
group by city, country, channelgrouping
order by city, country,num_groups desc;

select channelgrouping,count(*) as num_groups, country from all_sessions join products p 
on all_sessions.productsku = p.sku
group by  country, channelgrouping
order by country,num_groups desc;

select v2productcategory,count(*) as num_groups, city,country from all_sessions join products p 
on all_sessions.productsku = p.sku
where city not in ('(not set)','not available in demo dataset')
group by city, country, v2productcategory
order by city, country,num_groups desc;

select v2productcategory,count(*) as num_groups, country from all_sessions join products p 
on all_sessions.productsku = p.sku
where country not in ('(not set)','not available in demo dataset')
group by  country, v2productcategory
order by country,num_groups desc;
-- Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?
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



-- Question 5: Can we summarize the impact of revenue generated from each city/country?
