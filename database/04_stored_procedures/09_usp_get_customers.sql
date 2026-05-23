USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_GetCustomers
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (500)
        CustomerId,
        CustomerName,
        Phone,
        Email,
        City,
        IsActive,
        CreatedAt
    FROM sales.Customers
    ORDER BY CustomerId DESC;
END;
GO
