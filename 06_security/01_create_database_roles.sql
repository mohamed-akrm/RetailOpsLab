USE RetailOpsLab;
GO

/*
SQL roles are database-level security groups.
They are different from app.Roles table.
*/

CREATE ROLE role_sales_employee;
GO

CREATE ROLE role_warehouse_employee;
GO

CREATE ROLE role_auditor;
GO

CREATE ROLE role_manager;
GO

CREATE ROLE role_backend_app;
GO
