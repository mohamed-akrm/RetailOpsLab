/*
Run this file only if SQLCMD Mode is enabled in SSMS.
Menu: Query -> SQLCMD Mode

If SQLCMD Mode is not enabled, run the files manually in the order shown in README.md.
*/

:r .\01_database\00_create_database.sql
:r .\01_database\01_create_schemas.sql
:r .\01_database\02_create_app_tables.sql
:r .\01_database\03_create_inventory_tables.sql
:r .\01_database\04_create_sales_tables.sql
:r .\01_database\05_create_audit_tables.sql
:r .\01_database\06_create_table_types.sql

:r .\03_functions\01_fn_calculate_order_total.sql
:r .\03_functions\02_fn_get_available_stock.sql

:r .\04_stored_procedures\01_usp_create_customer.sql
:r .\04_stored_procedures\02_usp_create_product.sql
:r .\04_stored_procedures\03_usp_add_stock.sql
:r .\04_stored_procedures\04_usp_create_order.sql
:r .\04_stored_procedures\05_usp_register_payment.sql
:r .\04_stored_procedures\06_usp_cancel_order.sql
:r .\04_stored_procedures\07_usp_get_sales_report.sql
:r .\04_stored_procedures\08_usp_get_low_stock_products.sql

:r .\05_triggers\01_trg_audit_orders.sql
:r .\05_triggers\02_trg_audit_products.sql
:r .\05_triggers\03_trg_block_delete_orders.sql
:r .\05_triggers\04_trg_protect_database_structure.sql

:r .\02_seed_data\01_small_seed_data.sql
:r .\02_seed_data\02_generate_million_rows_procedure.sql

:r .\06_security\01_create_database_roles.sql
:r .\06_security\02_grant_permissions.sql
