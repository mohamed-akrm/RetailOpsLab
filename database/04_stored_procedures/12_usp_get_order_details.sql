USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_GetOrderDetails
    @OrderId BIGINT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        O.OrderId,
        O.CustomerId,
        C.CustomerName,
        O.OrderDate,
        O.OrderStatus,
        O.TotalAmount,
        O.CreatedByUserId
    FROM sales.Orders AS O
    INNER JOIN sales.Customers AS C
        ON C.CustomerId = O.CustomerId
    WHERE O.OrderId = @OrderId;

    SELECT
        OI.OrderItemId,
        OI.ProductId,
        P.ProductName,
        OI.WarehouseId,
        W.WarehouseName,
        OI.Quantity,
        OI.UnitPrice,
        OI.DiscountPercent,
        OI.LineTotal
    FROM sales.OrderItems AS OI
    INNER JOIN inventory.Products AS P
        ON P.ProductId = OI.ProductId
    INNER JOIN inventory.Warehouses AS W
        ON W.WarehouseId = OI.WarehouseId
    WHERE OI.OrderId = @OrderId
    ORDER BY OI.OrderItemId;
END;
GO
