USE RetailOpsLab;
GO

/*
Small data for quick testing.
This is not the million-row data.
*/

INSERT INTO app.Users (UserName, FullName, Email)
VALUES
(N'akram', N'Mohamed Akram', N'akram@example.com'),
(N'sales_user', N'Sales User', N'sales@example.com'),
(N'warehouse_user', N'Warehouse User', N'warehouse@example.com'),
(N'auditor_user', N'Auditor User', N'auditor@example.com');
GO

INSERT INTO app.Roles (RoleName)
VALUES
(N'Admin'),
(N'SalesEmployee'),
(N'WarehouseEmployee'),
(N'Auditor');
GO

INSERT INTO app.UserRoles (UserId, RoleId)
SELECT U.UserId, R.RoleId
FROM app.Users AS U
CROSS JOIN app.Roles AS R
WHERE U.UserName = N'akram';
GO

INSERT INTO inventory.Categories (CategoryName)
VALUES
(N'Electronics'),
(N'Food'),
(N'Clothes'),
(N'Office Supplies');
GO

INSERT INTO inventory.Suppliers (SupplierName, Phone, City)
VALUES
(N'Supplier One', N'01000000001', N'Cairo'),
(N'Supplier Two', N'01000000002', N'Giza'),
(N'Supplier Three', N'01000000003', N'Alexandria');
GO

INSERT INTO inventory.Warehouses (WarehouseName, City)
VALUES
(N'Main Warehouse', N'Cairo'),
(N'Backup Warehouse', N'Giza');
GO

DECLARE @ProductId INT;

EXEC inventory.usp_CreateProduct
    @SKU = N'P-100',
    @ProductName = N'Keyboard',
    @CategoryId = 1,
    @SupplierId = 1,
    @UnitPrice = 350,
    @ReorderLevel = 10,
    @NewProductId = @ProductId OUTPUT;

EXEC inventory.usp_CreateProduct
    @SKU = N'P-200',
    @ProductName = N'Mouse',
    @CategoryId = 1,
    @SupplierId = 1,
    @UnitPrice = 180,
    @ReorderLevel = 15,
    @NewProductId = @ProductId OUTPUT;

EXEC inventory.usp_CreateProduct
    @SKU = N'P-300',
    @ProductName = N'Notebook',
    @CategoryId = 4,
    @SupplierId = 2,
    @UnitPrice = 40,
    @ReorderLevel = 30,
    @NewProductId = @ProductId OUTPUT;
GO

EXEC inventory.usp_AddStock @ProductId = 1, @WarehouseId = 1, @Quantity = 100, @AppUserId = 1;
EXEC inventory.usp_AddStock @ProductId = 2, @WarehouseId = 1, @Quantity = 100, @AppUserId = 1;
EXEC inventory.usp_AddStock @ProductId = 3, @WarehouseId = 1, @Quantity = 200, @AppUserId = 1;
GO

DECLARE @CustomerId INT;

EXEC sales.usp_CreateCustomer
    @CustomerName = N'First Customer',
    @Phone = N'01111111111',
    @Email = N'customer1@example.com',
    @City = N'Cairo',
    @NewCustomerId = @CustomerId OUTPUT;
GO

DECLARE @Items sales.OrderItemInputType;
DECLARE @NewOrderId BIGINT;

INSERT INTO @Items (ProductId, WarehouseId, Quantity, DiscountPercent)
VALUES
(1, 1, 2, 0),
(2, 1, 1, 5);

EXEC sales.usp_CreateOrder
    @CustomerId = 1,
    @AppUserId = 1,
    @Items = @Items,
    @NewOrderId = @NewOrderId OUTPUT;

SELECT @NewOrderId AS NewOrderId;
GO
