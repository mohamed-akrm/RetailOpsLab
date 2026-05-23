USE RetailOpsLab;
GO

/*
These indexes are created after testing the slow report.
Do not create them before the before-test, or the comparison will not be fair.
*/

CREATE INDEX IX_Orders_OrderDate_Status_Customer
ON sales.Orders (OrderDate, OrderStatus, CustomerId)
INCLUDE (TotalAmount);
GO

CREATE INDEX IX_OrderItems_OrderId
ON sales.OrderItems (OrderId)
INCLUDE (Quantity, LineTotal, ProductId);
GO

CREATE INDEX IX_Stock_Quantity
ON inventory.Stock (Quantity)
INCLUDE (ProductId, WarehouseId);
GO

CREATE INDEX IX_InventoryTransactions_CreatedAt
ON inventory.InventoryTransactions (CreatedAt)
INCLUDE (ProductId, WarehouseId, QuantityChange, TransactionType);
GO
