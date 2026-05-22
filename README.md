# RetailOpsLab

RetailOpsLab is a SQL Server project for learning advanced database topics using a practical sales and inventory system.

The project is intentionally split into many small files instead of one huge script.


- Create a complete database from scratch
- Insert seed data
- Generate almost one million records for testing
- Write stored procedures and functions
- Use transactions with COMMIT and ROLLBACK
- Use triggers for audit and protection
- Save user actions in audit tables
- Create SQL roles and permissions
- Compare slow queries before and after indexes
- Connect backend code to the database using stored procedures
- Backup / dump the database

## Suggested order

Open SSMS and run these folders in order:

1. `01_database`
2. `03_functions`
3. `04_stored_procedures`
4. `05_triggers`
5. `02_seed_data`
6. `06_security`
7. `07_transactions`
8. `07_optimization`
9. `08_backup_dump`
10. `09_backend_node` if you want backend integration
11. `10_tests`

You can also try `Run_All.sql`, but in SSMS you must enable **SQLCMD Mode** first.


