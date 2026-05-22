USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE util.usp_GenerateMillionRows
    @CustomerCount INT = 100000,
    @ProductCount INT = 50000,
    @OrderCount INT = 300000,
    @OrderItemCount INT = 1000000,
    @WarehouseCount INT = 5
AS
BEGIN
    SET NOCOUNT ON;

    /*
    This procedure creates big data for performance testing.
    It is not random in a perfect way, but it is good enough for learning.
    */

    DECLARE @i INT;

    IF NOT EXISTS (SELECT 1 FROM inventory.Categories)
    BEGIN
        INSERT INTO inventory.Categories (CategoryName)
        VALUES (N'Electronics'), (N'Food'), (N'Clothes'), (N'Books'), (N'Office Supplies');
    END;

    IF NOT EXISTS (SELECT 1 FROM inventory.Suppliers)
    BEGIN
        INSERT INTO inventory.Suppliers (SupplierName, Phone, City)
        VALUES
        (N'Supplier 1', N'01000000001', N'Cairo'),
        (N'Supplier 2', N'01000000002', N'Giza'),
        (N'Supplier 3', N'01000000003', N'Alexandria');
    END;

    SET @i = 1;
    WHILE @i <= @WarehouseCount
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM inventory.Warehouses WHERE WarehouseName = CONCAT(N'Warehouse ', @i))
        BEGIN
            INSERT INTO inventory.Warehouses (WarehouseName, City)
            VALUES (CONCAT(N'Warehouse ', @i), N'Cairo');
        END;

        SET @i = @i + 1;
    END;

    ;WITH Numbers AS
    (
        SELECT TOP (@CustomerCount)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NumberValue
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
    )
    INSERT INTO sales.Customers (CustomerName, Phone, Email, City)
    SELECT
        CONCAT(N'Customer ', NumberValue),
        CONCAT(N'010', RIGHT(CONCAT(N'00000000', NumberValue), 8)),
        CONCAT(N'customer', NumberValue, N'@example.com'),
        CASE NumberValue % 4
            WHEN 0 THEN N'Cairo'
            WHEN 1 THEN N'Giza'
            WHEN 2 THEN N'Alexandria'
            ELSE N'Mansoura'
        END
    FROM Numbers;

    DECLARE @MaxCategoryId INT = (SELECT MAX(CategoryId) FROM inventory.Categories);
    DECLARE @MaxSupplierId INT = (SELECT MAX(SupplierId) FROM inventory.Suppliers);

    ;WITH Numbers AS
    (
        SELECT TOP (@ProductCount)
            ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NumberValue
        FROM sys.all_objects A
        CROSS JOIN sys.all_objects B
    )
    INSERT INTO inventory.Products
    (
        SKU,
        ProductName,
        CategoryId,
        SupplierId,
        UnitPrice,
        ReorderLevel
    )
    SELECT
        CONCAT(N'SKU-', NumberValue),
        CONCAT(N'Product ', NumberValue),
        1 + (NumberValue % @MaxCategoryId),
        1 + (NumberValue % @MaxSupplierId),
        10 + (NumberValue % 1000),
        20
    FROM Numbers;

    INSERT INTO inventory.Stock (ProductId, WarehouseId, Quantity)
    SELECT
        P.ProductId,
        W.WarehouseId,
        1000000
    FROM inventory.Products AS P
    CROSS JOIN inventory.Warehouses AS W
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM inventory.Stock AS S
        WHERE S.ProductId = P.ProductId
          AND S.WarehouseId = W.WarehouseId
    );

    DECLARE @MinCustomerId INT = (SELECT MIN(CustomerId) FROM sales.Customers);
    DECLARE @CustomerRange INT = (SELECT COUNT(*) FROM sales.Customers);

    DECLARE @InsertedOrders INT = 0;
    DECLARE @BatchSize INT = 10000;
    DECLARE @CurrentBatch INT;

    WHILE @InsertedOrders < @OrderCount
    BEGIN
        SET @CurrentBatch =
            CASE
                WHEN @OrderCount - @InsertedOrders >= @BatchSize THEN @BatchSize
                ELSE @OrderCount - @InsertedOrders
            END;

        ;WITH Numbers AS
        (
            SELECT TOP (@CurrentBatch)
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @InsertedOrders AS NumberValue
            FROM sys.all_objects A
            CROSS JOIN sys.all_objects B
        )
        INSERT INTO sales.Orders
        (
            CustomerId,
            OrderDate,
            OrderStatus,
            TotalAmount,
            CreatedByUserId
        )
        SELECT
            @MinCustomerId + (NumberValue % @CustomerRange),
            DATEADD(DAY, -1 * (NumberValue % 730), SYSUTCDATETIME()),
            N'Completed',
            0,
            1
        FROM Numbers;

        SET @InsertedOrders = @InsertedOrders + @CurrentBatch;
    END;

    DECLARE @MinOrderId BIGINT = (SELECT MIN(OrderId) FROM sales.Orders);
    DECLARE @OrderRange BIGINT = (SELECT COUNT(*) FROM sales.Orders);
    DECLARE @MinProductId INT = (SELECT MIN(ProductId) FROM inventory.Products);
    DECLARE @ProductRange INT = (SELECT COUNT(*) FROM inventory.Products);
    DECLARE @MinWarehouseId INT = (SELECT MIN(WarehouseId) FROM inventory.Warehouses);
    DECLARE @WarehouseRange INT = (SELECT COUNT(*) FROM inventory.Warehouses);

    DECLARE @InsertedItems INT = 0;
    SET @BatchSize = 50000;

    WHILE @InsertedItems < @OrderItemCount
    BEGIN
        SET @CurrentBatch =
            CASE
                WHEN @OrderItemCount - @InsertedItems >= @BatchSize THEN @BatchSize
                ELSE @OrderItemCount - @InsertedItems
            END;

        ;WITH Numbers AS
        (
            SELECT TOP (@CurrentBatch)
                ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) + @InsertedItems AS NumberValue
            FROM sys.all_objects A
            CROSS JOIN sys.all_objects B
        )
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
            @MinOrderId + (N.NumberValue % @OrderRange),
            P.ProductId,
            @MinWarehouseId + (N.NumberValue % @WarehouseRange),
            1 + (N.NumberValue % 5),
            P.UnitPrice,
            CASE WHEN N.NumberValue % 10 = 0 THEN 5 ELSE 0 END,
            (1 + (N.NumberValue % 5)) * P.UnitPrice *
            (1 - (CASE WHEN N.NumberValue % 10 = 0 THEN 5 ELSE 0 END) / 100.0)
        FROM Numbers AS N
        INNER JOIN inventory.Products AS P
            ON P.ProductId = @MinProductId + ((N.NumberValue * 17) % @ProductRange);

        SET @InsertedItems = @InsertedItems + @CurrentBatch;
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
    SELECT
        OI.ProductId,
        OI.WarehouseId,
        -OI.Quantity,
        N'SALE',
        OI.OrderId,
        1
    FROM sales.OrderItems AS OI
    WHERE NOT EXISTS
    (
        SELECT 1
        FROM inventory.InventoryTransactions AS IT
        WHERE IT.ReferenceOrderId = OI.OrderId
          AND IT.ProductId = OI.ProductId
          AND IT.WarehouseId = OI.WarehouseId
          AND IT.QuantityChange = -OI.Quantity
    );

    ;WITH OrderTotals AS
    (
        SELECT OrderId, SUM(LineTotal) AS TotalAmount
        FROM sales.OrderItems
        GROUP BY OrderId
    )
    UPDATE O
    SET O.TotalAmount = T.TotalAmount
    FROM sales.Orders AS O
    INNER JOIN OrderTotals AS T
        ON T.OrderId = O.OrderId;

    SELECT
        (SELECT COUNT(*) FROM sales.Customers) AS CustomersCount,
        (SELECT COUNT(*) FROM inventory.Products) AS ProductsCount,
        (SELECT COUNT(*) FROM sales.Orders) AS OrdersCount,
        (SELECT COUNT(*) FROM sales.OrderItems) AS OrderItemsCount,
        (SELECT COUNT(*) FROM inventory.InventoryTransactions) AS InventoryTransactionsCount;
END;
GO
