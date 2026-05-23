USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE inventory.usp_GetCategories
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CategoryId, CategoryName
    FROM inventory.Categories
    ORDER BY CategoryName;
END;
GO

CREATE OR ALTER PROCEDURE inventory.usp_GetSuppliers
AS
BEGIN
    SET NOCOUNT ON;

    SELECT SupplierId, SupplierName
    FROM inventory.Suppliers
    ORDER BY SupplierName;
END;
GO

CREATE OR ALTER PROCEDURE inventory.usp_GetWarehouses
AS
BEGIN
    SET NOCOUNT ON;

    SELECT WarehouseId, WarehouseName
    FROM inventory.Warehouses
    ORDER BY WarehouseName;
END;
GO
