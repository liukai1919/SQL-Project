Answer the following questions and provide the SQL queries used to find the answer.

    
**Question 1: Which cities and countries have the highest level of transaction revenues on the site?**


SQL Queries:
```SQL
WITH highlevel_transactions AS (
	SELECT
		Country,
		city,
		total_revenue,
		rank() OVER ( ORDER BY total_revenue DESC ) AS ranking 
	FROM
		(
		SELECT
			fullvisitorid,
			totaltransactionrevenue,
		CASE
				
				WHEN totaltransactionrevenue IS NULL THEN
				0 ELSE totaltransactionrevenue / 1000000 
			END AS total_revenue,
		CASE
				
				WHEN city IN ( '(not set)', 'not available in demo dataset' ) THEN
				NULL ELSE city 
			END AS city,
		CASE
				
				WHEN country IN ( '(not set)', 'not available in demo dataset' ) THEN
				NULL ELSE country 
			END AS country 
		FROM
			all_sessions 
		) 
	WHERE
		total_revenue != 0 
		AND city IS NOT NULL 
	) 
    
SELECT
	country,
	city,
	round( SUM ( total_revenue ), 2 ) AS combine_revenue 
FROM
	highlevel_transactions 
GROUP BY
	country,
	city 
ORDER BY
	SUM ( total_revenue ) DESC 
	LIMIT 5;
```
Answer:

result:
| #  | country        | city             | combine_revenue |
|----|----------------|------------------|-----------------|
| 1  | United States  | San Francisco     | 1564.32         |
| 2  | United States  | Sunnyvale         | 992.23          |
| 3  | United States  | Atlanta           | 854.44          |
| 4  | United States  | Palo Alto         | 608.00          |
| 5  | Israel         | Tel Aviv-Yafo     | 602.00          |

According to the result, the city with the highest transaction revenue is San Francisco.



**Question 2: What is the average number of products ordered from visitors in each city and country?**


SQL Queries:
```SQL

WITH avg_products AS (
	SELECT
		Country,
		city,
		productquantity
	FROM
		(
		SELECT
			fullvisitorid,
			productquantity,
		CASE
				
				WHEN city IN ( '(not set)', 'not available in demo dataset' ) THEN
				NULL ELSE city 
			END AS city,
		CASE
				
				WHEN country IN ( '(not set)', 'not available in demo dataset' ) THEN
				NULL ELSE country 
			END AS country 
		FROM
			all_sessions 
		) 
	WHERE
		productquantity != 0 
		AND city IS NOT NULL 
	) 

SELECT
	country,
	city,
	avg ( productquantity )AS avg_products 
FROM
	avg_products 
GROUP BY
	country,
	city 
ORDER BY
	avg ( productquantity ) DESC ;

```

Answer:

| #  | country        | city             | avg_products     |
|----|----------------|------------------|------------------|
| 1  | Spain          | Madrid           | 10.0000000000000 |
| 2  | United States  | Salem            | 8.0000000000000  |
| 3  | United States  | Atlanta          | 4.0000000000000  |
| 4  | United States  | Houston          | 2.0000000000000  |
| 5  | United States  | New York         | 1.1666666666667  |
| 6  | United States  | Dallas           | 1.0000000000000  |
| 7  | United States  | Detroit          | 1.0000000000000  |
| 8  | United States  | Los Angeles      | 1.0000000000000  |
| 9  | United States  | Mountain View    | 1.0000000000000  |
| 10 | United States  | Palo Alto        | 1.0000000000000  |
| 11 | United States  | San Francisco    | 1.0000000000000  |
| 12 | United States  | San Jose         | 1.0000000000000  |
| 13 | United States  | Seattle          | 1.0000000000000  |
| 14 | India          | Bengaluru        | 1.0000000000000  |
| 15 | United States  | Sunnyvale        | 1.0000000000000  |
| 16 | Ireland        | Dublin           | 1.0000000000000  |
| 17 | United States  | Ann Arbor        | 1.0000000000000  |
| 18 | United States  | Chicago          | 1.0000000000000  |
| 19 | United States  | Columbus         | 1.0000000000000  |





**Question 3: Is there any pattern in the types (product categories) of products ordered from visitors in each city and country?**


SQL Queries:
```SQL
-- channelgrouping each city
select channelgrouping,count(*) as num_groups, city from all_sessions 
where city not in ('(not set)','not available in demo dataset') and productquantity != 0 
group by city, channelgrouping
order by city,num_groups desc;
-- channelgrouping each country
select channelgrouping,count(*) as num_groups, country from all_sessions join products p 
on all_sessions.productsku = p.sku
where country not in ('(not set)','not available in demo dataset') and productquantity != 0 
group by  country, channelgrouping
order by country,num_groups desc;
-- productcategory each city
select  v2productcategory,count(*) as num_groups, city, round(avg(productprice/ 1000000),2) as avgprice from all_sessions 
where city not in ('(not set)','not available in demo dataset') and productquantity != 0 
group by city, v2productcategory
order by city, num_groups desc;
-- productcategory each country
select v2productcategory,count(*) as num_groups, country,round(avg(productprice/ 1000000),2) as avgprice from all_sessions 
where country not in ('(not set)','not available in demo dataset') and productquantity != 0 
group by  country, v2productcategory
order by country,num_groups desc;
```

Answer:
The US has the most orders with "Referral" channel, which means influencers' job worked. The US also paid more aveage price than other countries.




**Question 4: What is the top-selling product from each city/country? Can we find any pattern worthy of noting in the products sold?**


SQL Queries:
```SQL
WITH RankedProducts AS (
    SELECT
        country,
        city,
        v2productname,
        productquantity as num_products,
        ROW_NUMBER() OVER (PARTITION BY country, city ORDER BY productquantity DESC) AS rank
    FROM  all_sessions 
    where city not in ('(not set)','not available in demo dataset') and productquantity != 0 
)
-- top selling product from each city/country
SELECT country, city,v2productname,num_products
FROM RankedProducts
WHERE rank = 1 
ORDER BY country, city;

```

Answer:
| #  | country        | city             | v2productname                                      | num_products |
|----|----------------|------------------|----------------------------------------------------|------------|
| 1  | India          | Bengaluru        | Google Men's Vintage Badge Tee Black               | 1          |
| 2  | Ireland        | Dublin           | Google Laptop Backpack                             | 1          |
| 3  | Spain          | Madrid           | Waze Dress Socks                                   | 10         |
| 4  | United States  | Ann Arbor        | Google Men's Vintage Badge Tee Black               | 1          |
| 5  | United States  | Atlanta          | Reusable Shopping Bag                              | 4          |
| 6  | United States  | Chicago          | Google Sunglasses                                  | 1          |
| 7  | United States  | Columbus         | Google Men's Short Sleeve Badge Tee Charcoal       | 1          |
| 8  | United States  | Dallas           | YouTube Leatherette Notebook Combo                 | 1          |
| 9  | United States  | Detroit          | Google 22 oz Water Bottle                          | 1          |
| 10 | United States  | Houston          | Google Sunglasses                                  | 2          |
| 11 | United States  | Los Angeles      | Google Men's Pullover Hoodie Grey                  | 1          |
| 12 | United States  | Mountain View    | Google Women's Quilted Insulated Vest Black        | 1          |
| 13 | United States  | New York         | Nest® Protect Smoke + CO White Wired Alarm-USA     | 2          |
| 14 | United States  | Palo Alto        | Nest® Learning Thermostat 3rd Gen-USA - Stainless Steel | 1      |
| 15 | United States  | Salem            | Red Spiral Google Notebook                         | 8          |
| 16 | United States  | San Francisco    | Nest® Cam Outdoor Security Camera - USA            | 1          |
| 17 | United States  | San Jose         | Nest® Cam Indoor Security Camera - USA             | 1          |
| 18 | United States  | Seattle          | Nest® Cam Indoor Security Camera - USA             | 1          |
| 19 | United States  | Sunnyvale        | Nest® Cam Outdoor Security Camera - USA            | 1          |



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
According to the data, I believe that the factors that affects the revenue are location and imcome level, top 15 highest revenue are all from america(except Dublin). If we take a look on top 20 cities with highest revenue, we can find that They are most from developed countries, even though some few counties are not developed, their cities are all capital cities which means their imcome level is high.





