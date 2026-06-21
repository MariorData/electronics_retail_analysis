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

