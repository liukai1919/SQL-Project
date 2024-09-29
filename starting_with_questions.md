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
        country,
        city,
        units_sold
    FROM
        (
            SELECT
                units_sold,
                CASE
                    WHEN city IN ('(not set)', 'not available in demo dataset') THEN NULL
                    ELSE city
                END AS city,
                CASE
                    WHEN country IN ('(not set)', 'not available in demo dataset') THEN NULL
                    ELSE country
                END AS country
            FROM
                (SELECT DISTINCT * 
                 FROM analytics 
                 WHERE units_sold != 0) AS a
            JOIN all_sessions AS als 
                ON a.visitid = als.visitid 
                AND a.fullvisitorid = als.fullvisitorid
        ) AS subquery 
    WHERE
        city IS NOT NULL
)  -- Removed the extra comma here

SELECT
    country,
    city,
    round(AVG(units_sold),2) AS avg_products 
FROM
    avg_products 
GROUP BY
    country,
    city 
ORDER BY
    avg_products DESC;

```

Answer:

| #  | country        | city            | avg_products |
|----|----------------|-----------------|--------------|
| 1  | United States  | Chicago         | 6.15         |
| 2  | United States  | Pittsburgh      | 4.00         |
| 3  | Canada         | Toronto         | 3.00         |
| 4  | United States  | Houston         | 2.50         |
| 5  | United States  | Sunnyvale       | 2.34         |
| 6  | United States  | Mountain View   | 2.32         |
| 7  | United States  | San Francisco   | 1.52         |
| 8  | India          | Hyderabad       | 1.50         |
| 9  | United States  | Seattle         | 1.50         |
| 10 | United States  | New York        | 1.07         |
| 11 | Switzerland    | Zurich          | 1.00         |
| 12 | Thailand       | Bangkok         | 1.00         |
| 13 | United Kingdom | London          | 1.00         |
| 14 | United States  | Ann Arbor       | 1.00         |
| 15 | United States  | Atlanta         | 1.00         |
| 16 | United States  | Austin          | 1.00         |
| 17 | United States  | Dallas          | 1.00         |
| 18 | United States  | Detroit         | 1.00         |
| 19 | United States  | Kirkland        | 1.00         |
| 20 | United States  | Palo Alto       | 1.00         |
| 21 | United States  | San Bruno       | 1.00         |
| 22 | United States  | San Jose        | 1.00         |
| 23 | United States  | Washington      | 1.00         |
| 24 | Chile          | Santiago        | 1.00         |
| 25 | Colombia       | Bogota          | 1.00         |
| 26 | France         | Paris           | 1.00         |
| 27 | Germany        | Berlin          | 1.00         |
| 28 | Germany        | Munich          | 1.00         |
| 29 | Hong Kong      | Hong Kong       | 1.00         |
| 30 | Ireland        | Dublin          | 1.00         |
| 31 | Israel         | Tel Aviv-Yafo   | 1.00         |
| 32 | Singapore      | Singapore       | 1.00         |






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
        v2productcategory,
        units_sold,
        ROW_NUMBER() OVER (PARTITION BY country, city ORDER BY units_sold DESC) AS rank
    FROM  (select distinct * from analytics where units_sold !=0) as a join all_sessions as als on a.visitid = als.visitid and a.fullvisitorid = als.fullvisitorid 
    where city not in ('(not set)','not available in demo dataset') 
)
-- top selling product from each city/country
SELECT country, city,v2productname,v2productcategory,units_sold
FROM RankedProducts
WHERE rank = 1 
ORDER BY country, city;

```

Answer:
Most security cameras sold to California, which means the public safety in California is concerning. Also the spring sale is doing well, they sold 50 hightlighter pens.

| #  | country        | city            | v2productname                                         | v2productcategory                                 | units_sold |
|----|----------------|-----------------|-------------------------------------------------------|---------------------------------------------------|------------|
| 1  | Canada         | Toronto         | Android Stretch Fit Hat Black                         | Home/Apparel/Headgear/                            | 5          |
| 2  | Chile          | Santiago        | Sport Bag                                             | Home/Bags/                                        | 1          |
| 3  | Colombia       | Bogota          | YouTube Men's 3/4 Sleeve Henley                       | Home/Apparel/Men's/Men's-T-Shirts/                | 1          |
| 4  | France         | Paris           | Android Lunch Kit                                     | Home/Shop by Brand/Android/                       | 1          |
| 5  | Germany        | Berlin          | Google Doodle Decal                                   | Home/Office/                                      | 1          |
| 6  | Germany        | Munich          | Google Twill Cap                                      | Home/Apparel/Headgear/                            | 1          |
| 7  | Hong Kong      | Hong Kong       | Android Men's Long Sleeve Badge Crew Tee Heather      | Home/Apparel/Men's/Men's-T-Shirts/                | 1          |
| 8  | India          | Hyderabad       | Keyboard DOT Sticker                                  | Home/Accessories/Stickers/                        | 2          |
| 9  | Ireland        | Dublin          | Google Laptop Backpack                                | Home/Bags/                                        | 1          |
| 10 | Israel         | Tel Aviv-Yafo   | Google Men's Vintage Tank                             | Home/Apparel/Men's/Men's-T-Shirts/                | 1          |
| 11 | Singapore      | Singapore       | Google Men's Short Sleeve Performance Badge Tee Navy  | (not set)                                         | 1          |
| 12 | Switzerland    | Zurich          | YouTube Men's 3/4 Sleeve Henley                       | Home/Apparel/Men's/Men's-T-Shirts/                | 1          |
| 13 | Thailand       | Bangkok         | 26 oz Double Wall Insulated Bottle                    | Home/Drinkware/                                   | 1          |
| 14 | United Kingdom | London          | Android Sticker Sheet Ultra Removable                 | (not set)                                         | 1          |
| 15 | United States  | Ann Arbor       | Google Men's Vintage Badge Tee Black                  | Home/Apparel/Men's/Men's-T-Shirts/                | 1          |
| 16 | United States  | Atlanta         | Android Men's Vintage Henley                          | Home/Apparel/Men's/Men's-T-Shirts/                | 1          |
| 17 | United States  | Austin          | Google Men's Airflow 1/4 Zip Pullover Black           | Home/Apparel/Men's/Men's-Performance Wear/        | 1          |
| 18 | United States  | Chicago         | Google Alpine Style Backpack                          | Home/Shop by Brand/                               | 30         |
| 19 | United States  | Dallas          | YouTube Leatherette Notebook Combo                    | Home/Shop by Brand/YouTube/                       | 1          |
| 20 | United States  | Detroit         | Google 22 oz Water Bottle                             | Drinkware                                         | 1          |
| 21 | United States  | Houston         | Google Sunglasses                                     | ${escCatTitle}                                    | 3          |
| 22 | United States  | Kirkland        | Android Sticker Sheet Ultra Removable                 | Home/Office/                                      | 1          |
| 23 | United States  | Mountain View   | Grip Highlighter Pen 3 Pack                           | Home/Spring Sale!/                                | 50         |
| 24 | United States  | New York        | Nest® Protect Smoke + CO White Wired Alarm-USA        | Home/Nest/Nest-USA/                               | 2          |
| 25 | United States  | Palo Alto       | Nest® Learning Thermostat 3rd Gen-USA - White         | Nest-USA                                          | 1          |
| 26 | United States  | Pittsburgh      | YouTube Hard Cover Journal                            | Home/Office/Notebooks & Journals/                 | 4          |
| 27 | United States  | San Bruno       | Large Zipper Top Tote Bag                             | Home/Bags/                                        | 1          |
| 28 | United States  | San Francisco   | Google Women's Scoop Neck Tee White                   | Home/Apparel/Women's/Women's-T-Shirts/            | 4          |
| 29 | United States  | San Jose        | Google Women's Short Sleeve Hero Tee White            | (not set)                                         | 1          |
| 30 | United States  | Seattle         | Nest® Cam Indoor Security Camera - USA                | Home/Nest/Nest-USA/                               | 2          |
| 31 | United States  | Sunnyvale       | SPF-15 Slim & Slender Lip Balm                        | Housewares                                        | 6          |
| 32 | United States  | Washington      | Google Bib White                                      | Home/Apparel/Kid's/Kid's-Infant/                  | 1          |




**Question 5: Can we summarize the impact of revenue generated from each city/country?**

SQL Queries:
```SQL
WITH RankedProducts AS (
    SELECT
        country,
        city,
        v2productname,
        v2productcategory,
        round(productPrice/1000000 * units_sold,2) as revenue,
        units_sold,
        ROW_NUMBER() OVER (PARTITION BY country, city ORDER BY units_sold DESC) AS rank
    FROM (select distinct * from analytics where units_sold !=0) as a join all_sessions as als on a.visitid = als.visitid and a.fullvisitorid = als.fullvisitorid
    where city not in ('(not set)','not available in demo dataset')
)
SELECT country, city, v2productname,v2productcategory,revenue, units_sold
FROM RankedProducts
WHERE rank = 1 and revenue > 0
ORDER BY revenue DESC;
```


Answer:
According to the data, I believe that the factors that affects the revenue are location and imcome level, top 15 highest revenue are mostly from america. If we take a look on top 20 cities with highest revenue, we can find that They are most from developed countries, even though some few counties are not developed, their cities are all capital cities which means their imcome level is high.





