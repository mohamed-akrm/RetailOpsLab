USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE audit.usp_GetRecentAuditLogs
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (200)
        AuditLogId,
        SchemaName,
        TableName,
        ActionName,
        RecordId,
        AppUserId,
        OldValue,
        NewValue,
        CreatedAt
    FROM audit.AuditLogs
    ORDER BY AuditLogId DESC;
END;
GO
