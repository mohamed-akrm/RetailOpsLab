USE RetailOpsLab;
GO

/*
This trigger blocks direct delete from Orders.
The safer action is to cancel the order using sales.usp_CancelOrder.
*/

CREATE OR ALTER TRIGGER sales.trg_Block_Delete_Orders
ON sales.Orders
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO audit.BlockedActions
    (
        AppUserId,
        ActionName,
        Reason
    )
    SELECT
        TRY_CONVERT(INT, SESSION_CONTEXT(N'AppUserId')),
        N'DELETE_ORDER_BLOCKED',
        N'Direct delete from sales.Orders is not allowed. Use sales.usp_CancelOrder instead.';

    THROW 50100, 'Direct delete from sales.Orders is blocked. Use sales.usp_CancelOrder instead.', 1;
END;
GO
