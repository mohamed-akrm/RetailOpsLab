# Optimization Report Template

## Query tested

Sales report between two dates.

## Before optimization

| Metric | Value |
|---|---|
| CPU time | write here |
| Elapsed time | write here |
| Logical reads on Orders | write here |
| Logical reads on OrderItems | write here |
| Execution plan notes | write here |

## Indexes added

Write the indexes created from:

```text
07_optimization/02_create_optimization_indexes.sql
```

## After optimization

| Metric | Value |
|---|---|
| CPU time | write here |
| Elapsed time | write here |
| Logical reads on Orders | write here |
| Logical reads on OrderItems | write here |
| Execution plan notes | write here |

## Conclusion

Explain if the index improved the query or not.

Do not say optimization worked unless the numbers prove it.
