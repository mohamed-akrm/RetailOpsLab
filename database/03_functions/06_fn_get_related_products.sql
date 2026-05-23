USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION inventory.fn_GetRelatedProducts
(
    @ProductId INT,
    @CategoryId INT,
    @Limit INT = 5
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@Limit)
        ProductId,
        ProductName,
        UnitPrice
    FROM inventory.Products
    WHERE CategoryId = @CategoryId
      AND ProductId <> @ProductId
      AND IsActive = 1
    ORDER BY NEWID()
);
GO
