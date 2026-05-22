CREATE FUNCTION Inventory.fn_GetRelatedProducts
(
    @ProductID INT,
    @CategoryID INT,
    @Limit INT = 5
)
RETURNS TABLE
AS
RETURN
(
    SELECT TOP (@Limit)
        ProductID,
        ProductName,
        UnitPrice
    FROM Inventory.Products
    WHERE CategoryID = @CategoryID 
      AND ProductID <> @ProductID
      AND IsActive = 1
    ORDER BY ProductID
);