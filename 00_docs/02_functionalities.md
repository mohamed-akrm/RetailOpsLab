# Functionalities Documentation

## Customer management

- Add a new customer
- Store phone, email, and city
- Mark customer as active or inactive

## Product and inventory management

- Add products
- Add suppliers and categories
- Add warehouses
- Store current stock per product per warehouse
- Add stock movement records
- Show low stock products

## Sales management

- Create an order with many order items
- Calculate line total automatically
- Calculate order total automatically
- Reduce stock when order is created
- Register payment
- Cancel order and return stock

## Audit and protection

- Save changes on orders
- Save changes on products
- Block direct delete from orders
- Block dangerous schema changes such as DROP TABLE and ALTER TABLE

## Security

- Create database roles
- Give users execute permission on stored procedures
- Avoid giving normal users direct table permissions

## Optimization

- Run report before indexes
- Create indexes
- Run same report after indexes
- Compare logical reads and execution time
