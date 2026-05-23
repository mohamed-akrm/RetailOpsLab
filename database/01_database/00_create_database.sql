/*
This file creates the database.
Run it first.

Warning: it drops the database if it already exists.
Use this only on a local learning machine.
*/

USE master;
GO

IF DB_ID(N'RetailOpsLab') IS NOT NULL
BEGIN
    ALTER DATABASE RetailOpsLab SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RetailOpsLab;
END;
GO

CREATE DATABASE RetailOpsLab;
GO

ALTER DATABASE RetailOpsLab SET RECOVERY SIMPLE;
GO

USE RetailOpsLab;
GO
