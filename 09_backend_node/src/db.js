const sql = require('mssql');
require('dotenv').config();

const config = {
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  server: process.env.DB_SERVER,
  database: process.env.DB_NAME,
  port: Number(process.env.DB_PORT || 1433),
  options: {
    trustServerCertificate: true
  }
};

let pool;

async function getPool() {
  if (!pool) {
    pool = await sql.connect(config);
  }

  return pool;
}

module.exports = {
  sql,
  getPool
};
