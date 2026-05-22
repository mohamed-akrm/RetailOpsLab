USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE inventory.usp_GetLowStockProducts
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        P.ProductId,
        P.SKU,
        P.ProductName,
        W.WarehouseName,
        S.Quantity,
        P.ReorderLevel
    FROM inventory.Stock AS S
    INNER JOIN inventory.Products AS P
        ON P.ProductId = S.ProductId
    INNER JOIN inventory.Warehouses AS W
        ON W.WarehouseId = S.WarehouseId
    WHERE S.Quantity <= P.ReorderLevel
    ORDER BY S.Quantity ASC;
END;
GO
