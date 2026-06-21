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
