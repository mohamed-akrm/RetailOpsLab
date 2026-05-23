USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_GetRecentOrders
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (200)
        O.OrderId,
        O.CustomerId,
        C.CustomerName,
        O.OrderDate,
        O.OrderStatus,
        O.TotalAmount,
        O.CreatedByUserId
    FROM sales.Orders AS O
    INNER JOIN sales.Customers AS C
        ON C.CustomerId = O.CustomerId
    ORDER BY O.OrderId DESC;
END;
GO
