# How To Run

## Step 1: Create the database

Run files in `01_database` in order.

## Step 2: Create functions

Run files in `03_functions`.

## Step 3: Create stored procedures

Run files in `04_stored_procedures`.

## Step 4: Create triggers

Run files in `05_triggers`.

## Step 5: Insert small test data

Run:

```sql
EXEC util.usp_ResetDemoData;
```

or simply run the file:

```text
02_seed_data/01_small_seed_data.sql
```

## Step 6: Generate large data

Run:

```sql
EXEC util.usp_GenerateMillionRows
    @CustomerCount = 100000,
    @ProductCount = 50000,
    @OrderCount = 300000,
    @OrderItemCount = 1000000,
    @WarehouseCount = 5;
```

This may take time depending on your laptop.

## Step 7: Test optimization

Run:

1. `07_optimization/01_before_optimization_test.sql`
2. `07_optimization/02_create_optimization_indexes.sql`
3. `07_optimization/03_after_optimization_test.sql`

## Step 8: Test backend

Go to `09_backend_node` and read `README_BACKEND.md`.
