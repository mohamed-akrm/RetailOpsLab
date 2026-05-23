USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE inventory.usp_AddStock
    @ProductId INT,
    @WarehouseId INT,
    @Quantity INT,
    @AppUserId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Quantity <= 0
        THROW 50005, 'Quantity must be greater than zero.', 1;

    BEGIN TRANSACTION;

    BEGIN TRY
        IF EXISTS
        (
            SELECT 1
            FROM inventory.Stock
            WHERE ProductId = @ProductId
              AND WarehouseId = @WarehouseId
        )
        BEGIN
            UPDATE inventory.Stock
            SET Quantity = Quantity + @Quantity,
                LastUpdatedAt = SYSUTCDATETIME()
            WHERE ProductId = @ProductId
              AND WarehouseId = @WarehouseId;
        END
        ELSE
        BEGIN
            INSERT INTO inventory.Stock (ProductId, WarehouseId, Quantity)
            VALUES (@ProductId, @WarehouseId, @Quantity);
        END;

        INSERT INTO inventory.InventoryTransactions
        (
            ProductId,
            WarehouseId,
            QuantityChange,
            TransactionType,
            ReferenceOrderId,
            CreatedByUserId
        )
        VALUES
        (
            @ProductId,
            @WarehouseId,
            @Quantity,
            N'PURCHASE',
            NULL,
            @AppUserId
        );

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
