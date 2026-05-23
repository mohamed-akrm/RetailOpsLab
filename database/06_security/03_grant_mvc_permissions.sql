USE RetailOpsLab;
GO

/*
Extra permissions used by the MVC project.
The backend app executes stored procedures instead of reading tables directly.
*/

GRANT EXECUTE ON SCHEMA::app TO role_backend_app;
GRANT EXECUTE ON SCHEMA::sales TO role_backend_app;
GRANT EXECUTE ON SCHEMA::inventory TO role_backend_app;
GRANT EXECUTE ON OBJECT::audit.usp_GetRecentAuditLogs TO role_backend_app;
GO

GRANT EXECUTE ON SCHEMA::app TO role_manager;
GRANT EXECUTE ON OBJECT::audit.usp_GetRecentAuditLogs TO role_manager;
GO
