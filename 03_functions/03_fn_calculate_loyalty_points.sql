CREATE FUNCTION Sales.fn_CalculateLoyaltyPoints
(
    @OrderTotal DECIMAL(18,2),
    @CustomerTier INT = 1 -- 1: Normal, 2: VIP
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        CASE 
            WHEN @CustomerTier = 2 THEN CAST(@OrderTotal / 5.0 AS INT) -- VIP: نقطة لكل 5 جنيه/دولار
            ELSE CAST(@OrderTotal / 10.0 AS INT) -- العادي: نقطة لكل 10
        END AS EarnedPoints
);