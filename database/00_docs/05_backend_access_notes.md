# Backend Access Notes

## Main rule

The backend should call stored procedures instead of writing direct SELECT, INSERT, UPDATE, or DELETE statements everywhere.

## Why

This gives better control:

- validation stays close to the database
- permissions can be given on procedures only
- SQL injection risk is reduced when parameters are used
- business logic becomes easier to review

## Important correction

A stored procedure does not automatically prevent SQL injection.

You still need:

- parameterized calls from backend code
- no string concatenation for SQL commands
- no unsafe dynamic SQL inside stored procedures
- limited database permissions

## Example

Good idea:

```text
Backend -> sales.usp_CreateOrder(CustomerId, AppUserId, Items)
```

Bad idea:

```text
Backend builds SQL text like: SELECT * FROM Orders WHERE CustomerId = userInput
```
