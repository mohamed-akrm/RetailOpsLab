USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE inventory.usp_CreateProduct
    @SKU NVARCHAR(50),
    @ProductName NVARCHAR(200),
    @CategoryId INT,
    @SupplierId INT,
    @UnitPrice DECIMAL(18,2),
    @ReorderLevel INT = 20,
    @NewProductId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    IF @SKU IS NULL OR LTRIM(RTRIM(@SKU)) = N''
        THROW 50002, 'SKU is required.', 1;

    IF @ProductName IS NULL OR LTRIM(RTRIM(@ProductName)) = N''
        THROW 50003, 'Product name is required.', 1;

    IF @UnitPrice < 0
        THROW 50004, 'Unit price cannot be negative.', 1;

    INSERT INTO inventory.Products
    (
        SKU,
        ProductName,
        CategoryId,
        SupplierId,
        UnitPrice,
        ReorderLevel
    )
    VALUES
    (
        @SKU,
        @ProductName,
        @CategoryId,
        @SupplierId,
        @UnitPrice,
        @ReorderLevel
    );

    SET @NewProductId = SCOPE_IDENTITY();
END;
GO
