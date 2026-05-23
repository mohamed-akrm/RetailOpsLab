/*
Run this file only if SQLCMD Mode is enabled in SSMS.
Menu: Query -> SQLCMD Mode

This version uses full paths for Akram's local machine.
Expected project folder:
D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab

Important:
- It creates the database from zero.
- It generates the big test data automatically at the end.
- Reports are not part of the MVC app because the heavy report page was removed.
*/

:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\00_create_database.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\01_create_schemas.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\02_create_app_tables.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\03_create_inventory_tables.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\04_create_sales_tables.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\05_create_audit_tables.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\01_database\06_create_table_types.sql"

:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\01_fn_calculate_order_total.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\02_fn_get_available_stock.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\03_fn_calculate_loyalty_points.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\04_fn_get_customer_financial_summary.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\05_fn_mask_contact_info.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\07_fn_calculate_working_days.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\03_functions\08_fn_get_fiscal_period.sql"

:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\01_usp_create_customer.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\02_usp_create_product.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\03_usp_add_stock.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\04_usp_create_order.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\05_usp_register_payment.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\06_usp_cancel_order.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\08_usp_get_low_stock_products.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\09_usp_get_customers.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\10_usp_get_products.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\11_usp_get_recent_orders.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\12_usp_get_order_details.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\13_usp_get_recent_audit_logs.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\14_usp_get_dashboard_numbers.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\15_usp_get_lookup_data.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\04_stored_procedures\16_usp_function_wrappers.sql"

:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\02_seed_data\01_small_seed_data.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\02_seed_data\02_generate_million_rows_procedure.sql"

PRINT 'Generating the large dataset. This step can take time on a normal laptop.';
EXEC util.usp_GenerateMillionRows
    @CustomerCount = 100000,
    @ProductCount = 50000,
    @OrderCount = 300000,
    @OrderItemCount = 1000000,
    @WarehouseCount = 5;
GO

:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\05_triggers\01_trg_audit_orders.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\05_triggers\02_trg_audit_products.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\05_triggers\03_trg_block_delete_orders.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\05_triggers\04_trg_protect_database_structure.sql"

:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\06_security\01_create_database_roles.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\06_security\02_grant_permissions.sql"
:r "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\database\06_security\03_grant_mvc_permissions.sql"

PRINT 'RetailOpsLab database is ready.';
GO
