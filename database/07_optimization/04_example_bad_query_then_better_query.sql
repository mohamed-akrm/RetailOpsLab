USE RetailOpsLab;
GO

/*
Bad style for large data:
The function YEAR(OrderDate) makes it harder for SQL Server to use an index on OrderDate.
*/

SELECT COUNT(*) AS OrdersIn2025
FROM sales.Orders
WHERE YEAR(OrderDate) = 2025;
GO

/*
Better style:
Use a date range instead.
*/

SELECT COUNT(*) AS OrdersIn2025
FROM sales.Orders
WHERE OrderDate >= '2025-01-01'
  AND OrderDate < '2026-01-01';
GO
