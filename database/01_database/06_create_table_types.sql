USE RetailOpsLab;
GO

/*
This type is used by sales.usp_CreateOrder.
It lets the backend send many order items to one stored procedure call.
*/

CREATE TYPE sales.OrderItemInputType AS TABLE
(
    ProductId INT NOT NULL,
    WarehouseId INT NOT NULL,
    Quantity INT NOT NULL,
    DiscountPercent DECIMAL(5,2) NOT NULL
);
GO
