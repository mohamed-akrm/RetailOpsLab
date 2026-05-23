USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE inventory.usp_GetProducts
AS
BEGIN
    SET NOCOUNT ON;

    /*
    Take the latest 500 products first, then calculate stock for those only.
    This keeps the Products page fast after the database contains 50,000 products.
    */

    ;WITH LatestProducts AS
    (
        SELECT TOP (500)
            ProductId,
            SKU,
            ProductName,
            CategoryId,
            SupplierId,
            UnitPrice,
            ReorderLevel,
            IsActive
        FROM inventory.Products
        ORDER BY ProductId DESC
    )
    SELECT
        P.ProductId,
        P.SKU,
        P.ProductName,
        P.CategoryId,
        C.CategoryName,
        P.SupplierId,
        S.SupplierName,
        P.UnitPrice,
        P.ReorderLevel,
        P.IsActive,
        ISNULL(SUM(ST.Quantity), 0) AS TotalQuantity
    FROM LatestProducts AS P
    INNER JOIN inventory.Categories AS C
        ON C.CategoryId = P.CategoryId
    INNER JOIN inventory.Suppliers AS S
        ON S.SupplierId = P.SupplierId
    LEFT JOIN inventory.Stock AS ST
        ON ST.ProductId = P.ProductId
    GROUP BY
        P.ProductId,
        P.SKU,
        P.ProductName,
        P.CategoryId,
        C.CategoryName,
        P.SupplierId,
        S.SupplierName,
        P.UnitPrice,
        P.ReorderLevel,
        P.IsActive
    ORDER BY P.ProductId DESC;
END;
GO
