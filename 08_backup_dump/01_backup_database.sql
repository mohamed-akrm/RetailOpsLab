USE master;
GO

/*
Edit the path if needed.
The folder must already exist on the SQL Server machine.
*/

BACKUP DATABASE RetailOpsLab
TO DISK = 'C:\SQLBackups\RetailOpsLab.bak'
WITH INIT, NAME = 'RetailOpsLab Full Backup';
GO
