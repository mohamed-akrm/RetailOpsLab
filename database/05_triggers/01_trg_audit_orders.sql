USE RetailOpsLab;
GO

CREATE OR ALTER TRIGGER sales.trg_Audit_Orders
ON sales.Orders
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO audit.AuditLogs
    (
        AppUserId,
        ActionName,
        SchemaName,
        TableName,
        RecordId,
        OldValue,
        NewValue
    )
    SELECT
        TRY_CONVERT(INT, SESSION_CONTEXT(N'AppUserId')),
        CASE WHEN D.OrderId IS NULL THEN N'INSERT' ELSE N'UPDATE' END,
        N'sales',
        N'Orders',
        CONVERT(NVARCHAR(100), I.OrderId),
        (
            SELECT D.OrderId, D.CustomerId, D.OrderDate, D.OrderStatus, D.TotalAmount, D.CreatedByUserId
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ),
        (
            SELECT I.OrderId, I.CustomerId, I.OrderDate, I.OrderStatus, I.TotalAmount, I.CreatedByUserId
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    FROM inserted AS I
    LEFT JOIN deleted AS D
        ON D.OrderId = I.OrderId;
END;
GO
