USE RetailOpsLab;
GO

/*
Run this before creating optimization indexes.
Copy CPU time, elapsed time, and logical reads from the Messages tab.
*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

EXEC sales.usp_GetSalesReport
    @FromDate = '2025-01-01',
    @ToDate = '2026-01-01';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
