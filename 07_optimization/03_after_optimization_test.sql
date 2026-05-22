USE RetailOpsLab;
GO

/*
Run the same report after creating indexes.
Compare the numbers with the before-test.
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
