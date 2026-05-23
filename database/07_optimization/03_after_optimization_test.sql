USE RetailOpsLab;
GO

/*
Optional optimization test.
Run this manually after creating indexes, then compare Messages output.
This is not used by the MVC app.
*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT TOP (100)
    C.CustomerId,
    C.CustomerName,
    COUNT_BIG(DISTINCT O.OrderId) AS NumberOfOrders,
    SUM(OI.Quantity) AS TotalItemsSold,
    SUM(OI.LineTotal) AS TotalSales
FROM sales.Orders AS O
INNER JOIN sales.Customers AS C
    ON C.CustomerId = O.CustomerId
INNER JOIN sales.OrderItems AS OI
    ON OI.OrderId = O.OrderId
WHERE O.OrderDate >= '2025-01-01'
  AND O.OrderDate < '2026-01-01'
  AND O.OrderStatus = N'Completed'
GROUP BY C.CustomerId, C.CustomerName
ORDER BY TotalSales DESC;
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
