Question 1: 
Will longer browsing time lead users to purchase products?

SQL Queries:
```SQL
SELECT
	timeonsite,
	units_sold,
	channelgrouping 
FROM
	( SELECT DISTINCT timeonsite, units_sold, channelgrouping FROM analytics where units_sold is not null ) 
WHERE
	timeonsite IS NOT NULL 
ORDER BY
	units_sold DESC
```
Answer: 
It seems that longer browsing time does not lead users to purchase products.

| #  | timeonsite | units_sold | channelgrouping  |
|----|------------|------------|------------------|
| 1  | 408        | 4324       | Organic Search   |
| 2  | 1630       | 1594       | Organic Search   |
| 3  | 69         | 1121       | Social           |
| 4  | 321        | 1111       | Affiliates       |
| 5  | 40         | 1002       | Social           |
| 6  | 576        | 1000       | Direct           |
| 7  | 517        | 880        | Social           |
| 8  | 3221       | 825        | Referral         |
| 9  | 412        | 825        | Referral         |
| 10 | 836        | 531        | Direct           |


Question 2:  how about the pageviews? 

SQL Queries:
```SQL
SELECT
	pageviews,
	SUM ( units_sold ) AS sum_solds 
FROM
	( SELECT DISTINCT pageviews, units_sold FROM analytics ) 
WHERE
	pageviews IS NOT NULL 
GROUP BY
	pageviews 
ORDER BY
	pageviews DESC
```

Answer:
It seems that the more pages users visited, can't make visitors purchase more products.

| #  | Pageviews | Sum of Sold Units |
|----|-----------|-------------------|
| 1  | 186       | 6                 |
| 2  | 175       | 10                |
| 3  | 169       | 35                |
| 4  | 168       | 1                 |
| 5  | 155       | null              |
| 6  | 145       | 3                 |
| 7  | 139       | 1                 |
| 8  | 136       | 1                 |
| 9  | 134       | 1                 |
| 10 | 132       | null              |


Question 3: What are the most viewed products that have not been purchased?

SQL Queries:
```SQL
SELECT
distinct v2productname as productname,
	ana.pageviews 
FROM
	all_sessions als join (select * from analytics where units_sold is null) as ana on als.fullvisitorid = ana.fullvisitorid and als.visitid = ana.visitid
WHERE
	ana.pageviews IS NOT NULL 
	AND productquantity IS NULL 
ORDER BY
	ana.pageviews DESC
```
Answer:

| #  | productname                                      | pageviews |
|----|--------------------------------------------------|-----------|
| 1  | SPF-15 Slim & Slender Lip Balm                   | 48        |
| 2  | Google Men's Vintage Badge Tee Sage              | 45        |
| 3  | Google Women's 1/4 Zip Performance Pullover Two-Tone Blue | 22        |
| 4  | Rubber Grip Ballpoint Pen 4 Pack                 | 22        |
| 5  | Electronics Accessory Pouch                     | 21        |
| 6  | 26 oz Double Wall Insulated Bottle               | 20        |
| 7  | Google Men's Airflow 1/4 Zip Pullover Lapis      | 20        |
| 8  | Google Women's Short Sleeve Hero Tee Sky Blue    | 20        |
| 9  | Google Women's Tee Grey                          | 20        |
| 10 | 22 oz YouTube Bottle Infuser                    | 19        |


