USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_CreateOrder
    @CustomerId INT,
    @AppUserId INT,
    @Items sales.OrderItemInputType READONLY,
    @NewOrderId BIGINT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /*
    This value is used by triggers.
    It helps the audit log know which application user caused the change.
    */
    EXEC sys.sp_set_session_context @key = N'AppUserId', @value = @AppUserId;

    IF NOT EXISTS (SELECT 1 FROM sales.Customers WHERE CustomerId = @CustomerId AND IsActive = 1)
        THROW 50010, 'Customer does not exist or is not active.', 1;

    IF NOT EXISTS (SELECT 1 FROM @Items)
        THROW 50011, 'Order must contain at least one item.', 1;

    IF EXISTS (SELECT 1 FROM @Items WHERE Quantity <= 0)
        THROW 50012, 'Item quantity must be greater than zero.', 1;

    IF EXISTS (SELECT 1 FROM @Items WHERE DiscountPercent < 0 OR DiscountPercent > 100)
        THROW 50013, 'Discount percent must be between 0 and 100.', 1;

    /*
    Check stock before starting the real insert.
    We group items because the same product may be sent twice.
    */
    IF EXISTS
    (
        SELECT 1
        FROM
        (
            SELECT ProductId, WarehouseId, SUM(Quantity) AS NeededQuantity
            FROM @Items
            GROUP BY ProductId, WarehouseId
        ) AS Needed
        LEFT JOIN inventory.Stock AS S
            ON S.ProductId = Needed.ProductId
           AND S.WarehouseId = Needed.WarehouseId
        WHERE ISNULL(S.Quantity, 0) < Needed.NeededQuantity
    )
    BEGIN
        THROW 50014, 'Not enough stock for one or more products.', 1;
    END;

    BEGIN TRANSACTION;

    BEGIN TRY
        INSERT INTO sales.Orders
        (
            CustomerId,
            OrderStatus,
            TotalAmount,
            CreatedByUserId
        )
        VALUES
        (
            @CustomerId,
            N'Pending',
            0,
            @AppUserId
        );

        SET @NewOrderId = SCOPE_IDENTITY();

        INSERT INTO sales.OrderItems
        (
            OrderId,
            ProductId,
            WarehouseId,
            Quantity,
            UnitPrice,
            DiscountPercent,
            LineTotal
        )
        SELECT
            @NewOrderId,
            I.ProductId,
            I.WarehouseId,
            I.Quantity,
            P.UnitPrice,
            I.DiscountPercent,
            I.Quantity * P.UnitPrice * (1 - I.DiscountPercent / 100.0)
        FROM @Items AS I
        INNER JOIN inventory.Products AS P
            ON P.ProductId = I.ProductId
        WHERE P.IsActive = 1;

        IF @@ROWCOUNT <> (SELECT COUNT(*) FROM @Items)
            THROW 50015, 'One or more products do not exist or are not active.', 1;

        UPDATE S
        SET S.Quantity = S.Quantity - Needed.NeededQuantity,
            S.LastUpdatedAt = SYSUTCDATETIME()
        FROM inventory.Stock AS S
        INNER JOIN
        (
            SELECT ProductId, WarehouseId, SUM(Quantity) AS NeededQuantity
            FROM @Items
            GROUP BY ProductId, WarehouseId
        ) AS Needed
            ON Needed.ProductId = S.ProductId
           AND Needed.WarehouseId = S.WarehouseId;

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
            -SUM(Quantity),
            N'SALE',
            @NewOrderId,
            @AppUserId
        FROM @Items
        GROUP BY ProductId, WarehouseId;

        UPDATE sales.Orders
        SET TotalAmount = sales.fn_CalculateOrderTotal(@NewOrderId),
            OrderStatus = N'Completed'
        WHERE OrderId = @NewOrderId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW;
    END CATCH;
END;
GO
