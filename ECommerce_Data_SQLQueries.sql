--- The below queries are from a database of hypothetical e-commerce orders.

select *
from dbo.EcommerceOrders$

--- 1) For each country, show total orders, total units, and average delivery days

select Country, count(*) as TotalOrders, sum(Quantity) as TotalUnits, AVG(DeliveryDays) as AvgDeliveryDays
from dbo.EcommerceOrders$
group by Country
order by TotalOrders desc

--- 2) Find the total revenue by ProductCategory, sorted from highest to lowest

select ProductCategory, UnitPrice * Quantity * (1-DiscountPct) as Revenue
from dbo.EcommerceOrders$
order by Revenue desc

--- 3) Find the top 10 customers by total spend

SELECT TOP 10
    CustomerID,
    CustomerName,
    SUM(UnitPrice * Quantity * (1 - DiscountPct)) AS TotalSpend
FROM dbo.EcommerceOrders$
GROUP BY
    CustomerID,
    CustomerName
ORDER BY
    TotalSpend DESC;

--- 4) Show the monthly revenue trend

SELECT
    YEAR(OrderDate)  AS OrderYear,
    MONTH(OrderDate) AS OrderMonth,
    SUM(UnitPrice * Quantity * (1 - DiscountPct)) AS MonthlyRevenue
FROM dbo.EcommerceOrders$
GROUP BY
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY
    OrderYear,
    OrderMonth;

--- 5) Calculate the return rate by ProductCategory

SELECT
    ProductCategory,
    COUNT(*) AS TotalOrders,
    SUM(CASE WHEN Returned = 1 OR OrderStatus = 'Returned' THEN 1 ELSE 0 END) AS ReturnedOrders,
    CAST(100.0 * SUM(CASE WHEN Returned = 1 OR OrderStatus = 'Returned' THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(6,2)) AS ReturnRatePct
FROM dbo.EcommerceOrders$
GROUP BY
    ProductCategory
ORDER BY
    ReturnRatePct DESC;

--- 6) Compare average customer rating for orders with a discount vs without a discount

SELECT
    CASE
        WHEN DiscountPct > 0 THEN 'Discounted'
        ELSE 'No Discount'
    END AS DiscountGroup,
    COUNT(*) AS OrderCount,
    AVG(CustomerRating) AS AvgCustomerRating
FROM dbo.EcommerceOrders$
GROUP BY
    CASE
        WHEN DiscountPct > 0 THEN 'Discounted'
        ELSE 'No Discount'
    END;

--- 7) Identify products that have at least 30 orders and an average customer rating of 3.0 or higer

SELECT
    ProductName,
    COUNT(*) AS OrderCount,
    AVG(CustomerRating) AS AvgCustomerRating
FROM dbo.EcommerceOrders$
GROUP BY
    ProductName
HAVING
    COUNT(*) >= 30
    AND AVG(CustomerRating) >= 3.0
ORDER BY
    AvgCustomerRating DESC,
    OrderCount DESC;

--- 8) For each customer, find their largest single order value, then list the top 20 customers by that max order value.

SELECT TOP 20
    CustomerID,
    CustomerName,
    MAX(UnitPrice * Quantity * (1 - DiscountPct)) AS MaxOrderValue
FROM dbo.EcommerceOrders$
GROUP BY
    CustomerID,
    CustomerName
ORDER BY
    MaxOrderValue DESC;

--- 9) For each ProductCategory, find the best-selling product by total revenue.

WITH ProductRevenue AS (
    SELECT
        ProductCategory,
        ProductName,
        SUM(UnitPrice * Quantity * (1 - DiscountPct)) AS TotalRevenue
    FROM dbo.EcommerceOrders$
    WHERE OrderStatus <> 'Cancelled'
    GROUP BY
        ProductCategory,
        ProductName
),
RankedProducts AS (
    SELECT
        ProductCategory,
        ProductName,
        TotalRevenue,
        DENSE_RANK() OVER (
            PARTITION BY ProductCategory
            ORDER BY TotalRevenue DESC
        ) AS RevenueRank
    FROM ProductRevenue
)
SELECT
    ProductCategory,
    ProductName,
    TotalRevenue
FROM RankedProducts
WHERE RevenueRank = 1
ORDER BY
    ProductCategory,
    TotalRevenue DESC;