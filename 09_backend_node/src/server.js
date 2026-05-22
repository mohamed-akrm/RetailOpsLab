const express = require('express');
const { sql, getPool } = require('./db');

const app = express();
app.use(express.json());

app.get('/', function (req, res) {
  res.json({ message: 'RetailOpsLab backend is running' });
});

app.post('/customers', async function (req, res) {
  try {
    const pool = await getPool();

    const result = await pool.request()
      .input('CustomerName', sql.NVarChar(200), req.body.customerName)
      .input('Phone', sql.NVarChar(50), req.body.phone || null)
      .input('Email', sql.NVarChar(200), req.body.email || null)
      .input('City', sql.NVarChar(100), req.body.city || null)
      .output('NewCustomerId', sql.Int)
      .execute('sales.usp_CreateCustomer');

    res.json({ customerId: result.output.NewCustomerId });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.post('/orders', async function (req, res) {
  try {
    const pool = await getPool();

    const itemsTable = new sql.Table('sales.OrderItemInputType');
    itemsTable.columns.add('ProductId', sql.Int);
    itemsTable.columns.add('WarehouseId', sql.Int);
    itemsTable.columns.add('Quantity', sql.Int);
    itemsTable.columns.add('DiscountPercent', sql.Decimal(5, 2));

    for (const item of req.body.items) {
      itemsTable.rows.add(
        item.productId,
        item.warehouseId,
        item.quantity,
        item.discountPercent || 0
      );
    }

    const result = await pool.request()
      .input('CustomerId', sql.Int, req.body.customerId)
      .input('AppUserId', sql.Int, req.body.appUserId)
      .input('Items', itemsTable)
      .output('NewOrderId', sql.BigInt)
      .execute('sales.usp_CreateOrder');

    res.json({ orderId: result.output.NewOrderId });
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

app.get('/reports/sales', async function (req, res) {
  try {
    const pool = await getPool();

    const result = await pool.request()
      .input('FromDate', sql.DateTime2, req.query.from)
      .input('ToDate', sql.DateTime2, req.query.to)
      .execute('sales.usp_GetSalesReport');

    res.json(result.recordset);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

const port = process.env.PORT || 3000;

app.listen(port, function () {
  console.log('Server is running on port ' + port);
});
