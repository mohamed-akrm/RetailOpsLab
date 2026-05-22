USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_GetSalesReport
    @FromDate DATETIME2(0),
    @ToDate DATETIME2(0)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        C.CustomerId,
        C.CustomerName,
        COUNT(DISTINCT O.OrderId) AS NumberOfOrders,
        SUM(OI.Quantity) AS TotalItemsSold,
        SUM(OI.LineTotal) AS TotalSales
    FROM sales.Orders AS O
    INNER JOIN sales.Customers AS C
        ON C.CustomerId = O.CustomerId
    INNER JOIN sales.OrderItems AS OI
        ON OI.OrderId = O.OrderId
    WHERE O.OrderDate >= @FromDate
      AND O.OrderDate < @ToDate
      AND O.OrderStatus = N'Completed'
    GROUP BY
        C.CustomerId,
        C.CustomerName
    ORDER BY
        TotalSales DESC;
END;
GO
