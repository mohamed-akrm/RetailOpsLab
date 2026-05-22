USE RetailOpsLab;
GO

CREATE OR ALTER TRIGGER inventory.trg_Audit_Products
ON inventory.Products
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
        CASE WHEN D.ProductId IS NULL THEN N'INSERT' ELSE N'UPDATE' END,
        N'inventory',
        N'Products',
        CONVERT(NVARCHAR(100), I.ProductId),
        (
            SELECT D.ProductId, D.SKU, D.ProductName, D.UnitPrice, D.IsActive
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        ),
        (
            SELECT I.ProductId, I.SKU, I.ProductName, I.UnitPrice, I.IsActive
            FOR JSON PATH, WITHOUT_ARRAY_WRAPPER
        )
    FROM inserted AS I
    LEFT JOIN deleted AS D
        ON D.ProductId = I.ProductId;
END;
GO
