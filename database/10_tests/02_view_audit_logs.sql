USE RetailOpsLab;
GO

SELECT TOP 50
    AuditLogId,
    AppUserId,
    ActionName,
    SchemaName,
    TableName,
    RecordId,
    CreatedAt
FROM audit.AuditLogs
ORDER BY AuditLogId DESC;
GO
