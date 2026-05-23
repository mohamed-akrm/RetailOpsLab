USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE app.usp_GetDashboardNumbers
AS
BEGIN
    SET NOCOUNT ON;

    /*
    This dashboard procedure avoids heavy SUM or full table scans.
    It reads row counts from SQL Server metadata, so it remains fast
    after generating one million order items.
    */

    SELECT
        ISNULL((SELECT SUM(row_count) FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID(N'sales.Customers') AND index_id IN (0, 1)), 0) AS CustomersCount,
        ISNULL((SELECT SUM(row_count) FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID(N'inventory.Products') AND index_id IN (0, 1)), 0) AS ProductsCount,
        ISNULL((SELECT SUM(row_count) FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID(N'sales.Orders') AND index_id IN (0, 1)), 0) AS OrdersCount,
        ISNULL((SELECT SUM(row_count) FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID(N'sales.OrderItems') AND index_id IN (0, 1)), 0) AS OrderItemsCount,
        ISNULL((SELECT SUM(row_count) FROM sys.dm_db_partition_stats WHERE object_id = OBJECT_ID(N'audit.AuditLogs') AND index_id IN (0, 1)), 0) AS AuditLogsCount;
END;
GO
