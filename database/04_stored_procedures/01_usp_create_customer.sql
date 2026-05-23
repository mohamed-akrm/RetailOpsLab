USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_CreateCustomer
    @CustomerName NVARCHAR(200),
    @Phone NVARCHAR(50) = NULL,
    @Email NVARCHAR(200) = NULL,
    @City NVARCHAR(100) = NULL,
    @NewCustomerId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @CustomerName IS NULL OR LTRIM(RTRIM(@CustomerName)) = N''
    BEGIN
        THROW 50001, 'Customer name is required.', 1;
    END;

    INSERT INTO sales.Customers (CustomerName, Phone, Email, City)
    VALUES (@CustomerName, @Phone, @Email, @City);

    SET @NewCustomerId = SCOPE_IDENTITY();
END;
GO
