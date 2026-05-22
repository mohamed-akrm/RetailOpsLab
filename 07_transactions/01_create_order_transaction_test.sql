USE RetailOpsLab;
GO

/*
This file tests the transaction inside sales.usp_CreateOrder.
The procedure should create order, order items, inventory transactions, and stock update together.
*/

DECLARE @Items sales.OrderItemInputType;
DECLARE @NewOrderId BIGINT;

INSERT INTO @Items (ProductId, WarehouseId, Quantity, DiscountPercent)
VALUES
(1, 1, 1, 0),
(2, 1, 1, 0);

EXEC sales.usp_CreateOrder
    @CustomerId = 1,
    @AppUserId = 1,
    @Items = @Items,
    @NewOrderId = @NewOrderId OUTPUT;

SELECT @NewOrderId AS NewOrderId;

SELECT *
FROM sales.Orders
WHERE OrderId = @NewOrderId;

SELECT *
FROM sales.OrderItems
WHERE OrderId = @NewOrderId;

SELECT *
FROM inventory.InventoryTransactions
WHERE ReferenceOrderId = @NewOrderId;
GO
