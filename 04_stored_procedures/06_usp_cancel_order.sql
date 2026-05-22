USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_CancelOrder
    @OrderId BIGINT,
    @AppUserId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    EXEC sys.sp_set_session_context @key = N'AppUserId', @value = @AppUserId;

    IF NOT EXISTS (SELECT 1 FROM sales.Orders WHERE OrderId = @OrderId)
        THROW 50030, 'Order does not exist.', 1;

    IF EXISTS (SELECT 1 FROM sales.Orders WHERE OrderId = @OrderId AND OrderStatus = N'Cancelled')
        THROW 50031, 'Order is already cancelled.', 1;

    BEGIN TRANSACTION;

    BEGIN TRY
        UPDATE S
        SET S.Quantity = S.Quantity + OI.Quantity,
            S.LastUpdatedAt = SYSUTCDATETIME()
        FROM inventory.Stock AS S
        INNER JOIN sales.OrderItems AS OI
            ON OI.ProductId = S.ProductId
           AND OI.WarehouseId = S.WarehouseId
        WHERE OI.OrderId = @OrderId;

        INSERT INTO inventory.InventoryTransactions
        (
            ProductId,
            WarehouseId,
            QuantityChange,
            TransactionType,
            ReferenceOrderId,
            CreatedByUserId
        )
        SELECT
            ProductId,
            WarehouseId,
            Quantity,
            N'RETURN',
            @OrderId,
            @AppUserId
        FROM sales.OrderItems
        WHERE OrderId = @OrderId;

        UPDATE sales.Orders
        SET OrderStatus = N'Cancelled'
        WHERE OrderId = @OrderId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
