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


select sales_report.* from all_sessions join sales_report on all_sessions.productsku = sales_report.productsku where total_ordered < 0


select sales_by_sku.* from all_sessions join sales_by_sku on all_sessions.productsku = sales_by_sku.productsku where city = 'Beijing'

select * from all_sessions where productsku in (
    select productsku from sales_by_sku where productsku not in (select DISTINCT sku from products) 
)

select * from sales_report where productsku in (
    select productsku from sales_by_sku where productsku not in (select DISTINCT sku from products) 
)

    delete from sales_by_sku where productsku in (
        select productsku from sales_by_sku where productsku not in (select DISTINCT sku from products) and total_ordered > 0
    )

select * from sales_report where productsku in(select distinct productsku from all_sessions where productprice <=0) and total_ordered = 0

select * from sales_by_sku where productsku in(select distinct productsku from all_sessions where productprice <=0) and total_ordered = 0
order by productsku

select * from products where sku in(select distinct productsku from all_sessions where productprice <=0)


select count(*) from sales_by_sku

select productsku, count(*) from sales_report group by productsku HAVING count(*) > 1


select productsku, count(*) from sales_by_sku group by productsku HAVING count(*) > 2

select count(*) from products

select pn.productsku as all_sessions_productsku,count_sessions, 
    sr.productsku as sales_report_productsku, sr.total_ordered as sales_report_total_order, 
    sku.productsku as sales_by_sku_productsku, sku.total_ordered as sales_by_sku_total_ordered,
    p.sku, p.orderedquantity
from sales_report as sr join sales_by_sku as sku on sr.productsku = sku.productsku join products p on sr.productsku = p.sku
join (select productsku, count(*) as count_sessions from all_sessions group by productsku) as pn 
on sku.productsku = pn.productsku


select productsku, count(*) as numoforder from all_sessions group by productsku HAVING count(*) > 1

WITH highlevel_transactions AS (
SELECT
	Country,
	city,
	total_revenue,
	NTILE(1000) OVER( ORDER BY total_revenue DESC  ) as ranking
FROM (	SELECT
		fullvisitorid,
		totaltransactionrevenue,
		CASE 
			WHEN totaltransactionrevenue IS NULL THEN 0
			ELSE totaltransactionrevenue/1000000
		END AS total_revenue,
		CASE 
			WHEN city IN ('(not set)', 'not available in demo dataset') THEN NULL
			ELSE city
		END AS city,
		CASE 
			WHEN country IN ('(not set)', 'not available in demo dataset') THEN NULL
			ELSE country
		END AS country
		
	FROM all_sessions)
WHERE
	total_revenue != 0
	AND city IS NOT NULL
)


SELECT country,city, round(sum(total_revenue),2) AS combine_revenue
FROM highlevel_transactions
GROUP BY country,city
ORDER BY sum(total_revenue) DESC
LIMIT 5;


select * from analytics where units_sold > 0


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