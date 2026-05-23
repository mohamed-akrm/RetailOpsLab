USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION sales.fn_GetCustomerFinancialSummary
(
    @CustomerId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        C.CustomerId,
        C.CustomerName,
        COUNT(O.OrderId) AS TotalOrders,
        ISNULL(SUM(O.TotalAmount), 0) AS LifetimeValue,
        MAX(O.OrderDate) AS LastOrderDate
    FROM sales.Customers AS C
    LEFT JOIN sales.Orders AS O
        ON O.CustomerId = C.CustomerId
    WHERE C.CustomerId = @CustomerId
    GROUP BY C.CustomerId, C.CustomerName
);
GO
