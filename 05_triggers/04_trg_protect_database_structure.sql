USE RetailOpsLab;
GO

/*
This database-level trigger blocks dangerous structure changes.

Important note:
DDL triggers run inside the same transaction as the DDL command.
If we insert an audit row and then ROLLBACK, that audit row is rolled back too.
So this trigger focuses on protection, not logging.
*/

CREATE OR ALTER TRIGGER trg_Protect_Database_Structure
ON DATABASE
FOR DROP_TABLE, ALTER_TABLE
AS
BEGIN
    SET NOCOUNT ON;

    RAISERROR ('DROP TABLE and ALTER TABLE are blocked in this database.', 16, 1);
    ROLLBACK;
END;
GO
