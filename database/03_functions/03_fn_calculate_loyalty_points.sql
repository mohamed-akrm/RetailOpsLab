USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION sales.fn_CalculateLoyaltyPoints
(
    @OrderTotal DECIMAL(18,2),
    @CustomerTier INT = 1 -- 1 = Normal, 2 = VIP
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        CASE
            WHEN @CustomerTier = 2 THEN CAST(@OrderTotal / 5.0 AS INT)
            ELSE CAST(@OrderTotal / 10.0 AS INT)
        END AS EarnedPoints
);
GO
