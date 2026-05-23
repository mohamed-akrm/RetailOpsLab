USE RetailOpsLab;
GO

/*
This file should fail.
It asks for a very large quantity.
The procedure should reject the order before changing the database.
*/

DECLARE @Items sales.OrderItemInputType;
DECLARE @NewOrderId BIGINT;

INSERT INTO @Items (ProductId, WarehouseId, Quantity, DiscountPercent)
VALUES
(1, 1, 999999999, 0);

EXEC sales.usp_CreateOrder
    @CustomerId = 1,
    @AppUserId = 1,
    @Items = @Items,
    @NewOrderId = @NewOrderId OUTPUT;
GO
