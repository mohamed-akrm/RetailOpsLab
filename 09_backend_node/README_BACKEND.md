# Backend Node.js Example

This is a small backend example.

It does not build SQL strings from user input.
It calls stored procedures using parameters.

## Install

```bash
npm install
```

## Configure

Copy `.env.example` to `.env` and edit the values.

## Run

```bash
npm start
```

## Test endpoints

Create customer:

```http
POST /customers
```

Create order:

```http
POST /orders
```

Get report:

```http
GET /reports/sales?from=2025-01-01&to=2026-01-01
```
