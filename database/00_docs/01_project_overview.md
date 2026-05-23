# Project Overview

## Project name

RetailOpsLab: Sales, Inventory, Audit, Security, and Query Optimization System.

## Main idea

The system simulates a small retail company. Customers place orders. Each order contains products. Products are stored in warehouses. When an order is created, stock is reduced. Every important action is saved in audit logs.

## Main modules

| Module | Purpose |
|---|---|
| app | users and application roles |
| sales | customers, orders, order items, payments |
| inventory | products, warehouses, stock, stock movement |
| audit | logs and blocked actions |
| util | helper procedures such as data generation |

## Why this project is useful

This project is good for database learning because it has real transactional behavior:

- order creation must be atomic
- stock must not become negative
- users should not access tables directly
- important changes must be audited
- reports need indexes when the data becomes large

## Simple architecture

Backend application

calls stored procedures

SQL Server database

stores data and protects it using transactions, triggers, constraints, and roles.
