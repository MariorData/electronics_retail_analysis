CREATE VIEW factsales 
AS

SELECT 
       s.OrderNumber,
       s.LineItem,
       s.OrderDate,
       s.DeliveryDate,
       s.CustomerKey,
       s.StorerKey,
       s.ProductKey,
       s.Quantity,
       s.Quantity*p.UnitPriceUSD*r.Exchange AS Sales_Amount_USD,
       s.Quantity*p.UnitCostUSD*r.Exchange AS COGS_USD
  FROM sales s
  LEFT JOIN dimproduct p
    ON s.ProductKey=p.ProductKey
  LEFT JOIN dimexcrates r
    ON s.CurrencyCode=r.Currency AND s.OrderDate=r.CurrencyDate 
