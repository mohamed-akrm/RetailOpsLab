USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION inventory.fn_GetAvailableStock
(
    @ProductId INT,
    @WarehouseId INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Quantity INT;

    SELECT @Quantity = Quantity
    FROM inventory.Stock
    WHERE ProductId = @ProductId
      AND WarehouseId = @WarehouseId;

    RETURN ISNULL(@Quantity, 0);
END;
GO
