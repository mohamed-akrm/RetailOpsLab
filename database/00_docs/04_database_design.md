# Database Design

## Main entities

| Table | Description |
|---|---|
| app.Users | application users |
| app.Roles | application roles |
| app.UserRoles | relation between users and roles |
| sales.Customers | customers who buy products |
| inventory.Categories | product categories |
| inventory.Suppliers | suppliers who provide products |
| inventory.Products | products sold by the company |
| inventory.Warehouses | warehouse locations |
| inventory.Stock | quantity of each product in each warehouse |
| sales.Orders | order header |
| sales.OrderItems | order details |
| sales.Payments | payments for orders |
| inventory.InventoryTransactions | stock movement history |
| audit.AuditLogs | saved user actions |
| audit.BlockedActions | blocked dangerous actions |

## Important relationships

- One customer can have many orders
- One order can have many order items
- One product can appear in many order items
- One product can exist in many warehouses
- One warehouse can contain many products
- One order can have one or more payments
- One user can perform many actions

## Why Order and OrderItems are separated

An order has common information such as customer, date, and status.

OrderItems contains the products inside the order.

This is better than putting all products inside one text column because each product line can be queried, indexed, priced, and validated separately.
