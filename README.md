# RetailOpsLab

RetailOpsLab is a small ASP.NET Core MVC + SQL Server project for an Advanced Database course.

The project focuses on:

- SQL Server database design
- stored procedures
- functions
- transactions
- triggers
- audit logging
- permissions
- large test data generation
- MVC pages that call stored procedures using parameters

## Project structure

```text
RetailOpsLab
├── database
│   ├── 01_database
│   ├── 02_seed_data
│   ├── 03_functions
│   ├── 04_stored_procedures
│   ├── 05_triggers
│   ├── 06_security
│   ├── 07_optimization
│   └── Run_All.sql
└── web
    └── RetailOpsLab
        ├── Controllers
        ├── Data
        ├── Models
        ├── Views
        └── appsettings.json
```

## Important path note

`database/Run_All.sql` uses full paths for this local folder:

```text
D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab
```

So extract the project so that the folder is exactly:

```text
D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab
```

If you put it somewhere else, edit the `:r` paths inside `database/Run_All.sql`.

## How to run the database

1. Open SQL Server Management Studio.
2. Open this file:

```text
RetailOpsLab\database\Run_All.sql
```

3. Enable SQLCMD Mode:

```text
Query -> SQLCMD Mode
```

4. Press Execute.

The script creates the database and also runs:

```sql
EXEC util.usp_GenerateMillionRows
    @CustomerCount = 100000,
    @ProductCount = 50000,
    @OrderCount = 300000,
    @OrderItemCount = 1000000,
    @WarehouseCount = 5;
```

## How to run the MVC app

Open PowerShell inside the project folder and run:

```powershell
dotnet run --project "D:\FCAI\the last dance\sem2\Advanced database\RetailOpsLab\web\RetailOpsLab\RetailOpsLab.csproj"
```

Or double-click:

```text
Run_MVC_App.bat
```

## Pages included

- Dashboard
- Customers
- Products
- Orders
- Audit
- Functions

The Reports page was removed because it was heavy on the million-row dataset.

## Functions included

Safe functions only:

- sales.fn_CalculateLoyaltyPoints
- sales.fn_GetCustomerFinancialSummary
- app.fn_MaskContactInfo
- app.fn_CalculateWorkingDays
- app.fn_GetFiscalPeriod

The related-products function was removed because the old version used `NEWID()` inside a SQL Server function, which causes an error.
