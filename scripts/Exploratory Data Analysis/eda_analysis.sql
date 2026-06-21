--Measures

SELECT 'Total_quantity' AS Measure_name, SUM(quantity) AS Measure_value
FROM sales

UNION ALL

SELECT 'Total_sales' , SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate

UNION ALL

SELECT 'AVG_price' , 
SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)/
SUM(quantity)

FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate


UNION ALL

SELECT 'Total_margin', SUM(s.Quantity*p.UnitPriceUSD*r.Exchange-s.Quantity*p.UnitCostUSD*r.Exchange) 
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate

UNION ALL

SELECT 'Total_margin_(pct)', 
	SUM(s.Quantity*p.UnitPriceUSD*r.Exchange-s.Quantity*p.UnitCostUSD*r.Exchange)
	/SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate

UNION ALL 

SELECT 'No_Orders', COUNT(DISTINCT(OrderNumber)) 
FROM sales

UNION ALL 

SELECT 'AVG_Order_Sales' ,
SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)/
COUNT(DISTINCT(OrderNumber))
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate


UNION ALL 

SELECT 'No_customers', COUNT(DISTINCT(CustomerKey))
FROM sales

UNION ALL 

SELECT 'AVG_Customer_Sales' ,
SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)/
COUNT(DISTINCT(CustomerKey))
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate

UNION ALL 

SELECT 'No_products', COUNT(DISTINCT(ProductKey))
FROM sales

UNION ALL 

SELECT 'AVG_Product_Sales' ,
SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)/
COUNT(DISTINCT(s.ProductKey))
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate


--Sales over time with mom change

SELECT  YEAR(orderdate)*100+MONTH(orderdate) AS YearMonth ,
SUM(s.Quantity*p.UnitPriceUSD*r.Exchange) AS Sales_Amount,
LAG(SUM(s.Quantity*p.UnitPriceUSD*r.Exchange),1,0) OVER (ORDER BY YEAR(orderdate)*100+MONTH(orderdate)) AS PM_Sales_Amount,
SUM(s.Quantity*p.UnitPriceUSD*r.Exchange)-
	LAG(SUM(s.Quantity*p.UnitPriceUSD*r.Exchange),1,0) OVER (ORDER BY YEAR(orderdate)*100+MONTH(orderdate)) AS Sales_Diff_vs_PM

FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate
GROUP BY YEAR(orderdate)*100+MONTH(orderdate)

/*
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis or identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month 
-- and the running total of sales over time by year
SELECT
	order_date,
	total_sales,
	SUM(total_sales) OVER (PARTITION BY YEAR(order_date) ORDER BY order_date) AS year_running_total_sales,
    AVG(total_sales) OVER (ORDER BY order_date ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS moving_sales_avg_6m
FROM
(
    SELECT 
        DATETRUNC(month, orderdate) AS order_date,
        SUM(s.Quantity*p.UnitPriceUSD*r.Exchange) AS total_sales
    FROM sales s
	LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
	LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate
    GROUP BY DATETRUNC(month, orderdate)
) t

/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank dimensions (e.g., products, customers) based on performance or other metrics.
    - To identify top performers or laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/

-- Which 10 products Generating the Highest Revenue?
-- Simple Ranking
SELECT TOP 10
    p.ProductName,
    SUM(s.Quantity*p.UnitPriceUSD*r.Exchange) AS total_sales
FROM sales s
LEFT JOIN dimproduct p
	ON s.ProductKey=p.ProductKey
LEFT JOIN dimexcrates r
	ON s.CurrencyCode=r.Currency
	AND s.OrderDate=r.CurrencyDate
GROUP BY p.ProductName
ORDER BY total_sales DESC;

-- Complex but Flexibly Ranking Using Window Functions
SELECT *
FROM ( 
	SELECT
    p.ProductName,
    SUM(s.Quantity*p.UnitPriceUSD*r.Exchange) AS total_sales,
	RANK() OVER (ORDER BY SUM(s.Quantity*p.UnitPriceUSD*r.Exchange) DESC) AS rank_products
	FROM sales s
	LEFT JOIN dimproduct p
		ON s.ProductKey=p.ProductKey
	LEFT JOIN dimexcrates r
		ON s.CurrencyCode=r.Currency
		AND s.OrderDate=r.CurrencyDate
	GROUP BY p.ProductName          
	) AS ranked_products
	WHERE rank_products <= 10;

