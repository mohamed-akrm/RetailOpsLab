CREATE FUNCTION Sales.fn_GetCustomerFinancialSummary
(
    @CustomerID INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        CustomerID,
        COUNT(OrderID) AS TotalOrders,
        ISNULL(SUM(TotalAmount), 0) AS LifetimeValue,
        MAX(OrderDate) AS LastOrderDate
    FROM Sales.Orders 
    WHERE CustomerID = @CustomerID
    GROUP BY CustomerID
);