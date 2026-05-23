USE RetailOpsLab;
GO

/*
The idea: normal users should execute procedures.
They should not edit tables directly.
*/

GRANT EXECUTE ON OBJECT::sales.usp_CreateCustomer TO role_sales_employee;
GRANT EXECUTE ON OBJECT::sales.usp_CreateOrder TO role_sales_employee;
GRANT EXECUTE ON OBJECT::sales.usp_RegisterPayment TO role_sales_employee;
GO

GRANT EXECUTE ON OBJECT::inventory.usp_AddStock TO role_warehouse_employee;
GRANT EXECUTE ON OBJECT::inventory.usp_GetLowStockProducts TO role_warehouse_employee;
GO

GRANT SELECT ON OBJECT::audit.AuditLogs TO role_auditor;
GRANT SELECT ON OBJECT::audit.BlockedActions TO role_auditor;
GO

GRANT EXECUTE ON SCHEMA::sales TO role_manager;
GRANT EXECUTE ON SCHEMA::inventory TO role_manager;
GRANT SELECT ON SCHEMA::audit TO role_manager;
GO

GRANT EXECUTE ON SCHEMA::sales TO role_backend_app;
GRANT EXECUTE ON SCHEMA::inventory TO role_backend_app;
GO

/*
Demo user creation is commented because login names are different on every machine.
Uncomment and edit if you want to test real SQL users.

CREATE LOGIN sales_login WITH PASSWORD = 'StrongPassword_123';
CREATE USER sales_user FOR LOGIN sales_login;
ALTER ROLE role_sales_employee ADD MEMBER sales_user;
*/
