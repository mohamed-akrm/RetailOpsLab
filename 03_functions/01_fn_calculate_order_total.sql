USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION sales.fn_CalculateOrderTotal
(
    @OrderId BIGINT
)
RETURNS DECIMAL(18,2)
AS
BEGIN
    DECLARE @Total DECIMAL(18,2);

    SELECT @Total = SUM(LineTotal)
    FROM sales.OrderItems
    WHERE OrderId = @OrderId;

    RETURN ISNULL(@Total, 0);
END;
GO
