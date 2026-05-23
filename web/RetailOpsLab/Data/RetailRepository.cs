using System.Data;
using Microsoft.Data.SqlClient;
using RetailOpsLab.Models;

namespace RetailOpsLab.Data;

public class RetailRepository
{
    private readonly string _connectionString;

    public RetailRepository(IConfiguration configuration)
    {
        _connectionString = configuration.GetConnectionString("RetailDb")
            ?? throw new InvalidOperationException("RetailDb connection string is missing.");
    }

    private SqlConnection CreateConnection()
    {
        return new SqlConnection(_connectionString);
    }

    private static int GetInt(SqlDataReader reader, string name)
    {
        return Convert.ToInt32(reader[name]);
    }

    private static long GetLong(SqlDataReader reader, string name)
    {
        return Convert.ToInt64(reader[name]);
    }

    private static decimal GetDecimal(SqlDataReader reader, string name)
    {
        return Convert.ToDecimal(reader[name]);
    }

    private static string GetString(SqlDataReader reader, string name)
    {
        return reader[name] == DBNull.Value ? "" : Convert.ToString(reader[name]) ?? "";
    }

    private static DateTime GetDateTime(SqlDataReader reader, string name)
    {
        return Convert.ToDateTime(reader[name]);
    }

    public async Task<DashboardViewModel> GetDashboardNumbersAsync()
    {
        using var connection = CreateConnection();
        using var command = new SqlCommand("app.usp_GetDashboardNumbers", connection);
        command.CommandType = CommandType.StoredProcedure;

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        var model = new DashboardViewModel();
        if (await reader.ReadAsync())
        {
            model.CustomersCount = GetInt(reader, "CustomersCount");
            model.ProductsCount = GetInt(reader, "ProductsCount");
            model.OrdersCount = GetInt(reader, "OrdersCount");
            model.OrderItemsCount = GetInt(reader, "OrderItemsCount");
            model.AuditLogsCount = GetInt(reader, "AuditLogsCount");
        }
        return model;
    }

    public async Task<List<CustomerViewModel>> GetCustomersAsync()
    {
        var customers = new List<CustomerViewModel>();

        using var connection = CreateConnection();
        using var command = new SqlCommand("sales.usp_GetCustomers", connection);
        command.CommandType = CommandType.StoredProcedure;

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            customers.Add(new CustomerViewModel
            {
                CustomerId = GetInt(reader, "CustomerId"),
                CustomerName = GetString(reader, "CustomerName"),
                Phone = GetString(reader, "Phone"),
                Email = GetString(reader, "Email"),
                City = GetString(reader, "City"),
                IsActive = Convert.ToBoolean(reader["IsActive"]),
                CreatedAt = GetDateTime(reader, "CreatedAt")
            });
        }

        return customers;
    }

    public async Task<int> CreateCustomerAsync(CustomerViewModel model)
    {
        using var connection = CreateConnection();
        using var command = new SqlCommand("sales.usp_CreateCustomer", connection);
        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@CustomerName", model.CustomerName);
        command.Parameters.AddWithValue("@Phone", (object?)model.Phone ?? DBNull.Value);
        command.Parameters.AddWithValue("@Email", (object?)model.Email ?? DBNull.Value);
        command.Parameters.AddWithValue("@City", (object?)model.City ?? DBNull.Value);

        var output = new SqlParameter("@NewCustomerId", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        command.Parameters.Add(output);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();

        return Convert.ToInt32(output.Value);
    }

    public async Task<List<ProductViewModel>> GetProductsAsync()
    {
        var products = new List<ProductViewModel>();

        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_GetProducts", connection);
        command.CommandType = CommandType.StoredProcedure;

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            products.Add(new ProductViewModel
            {
                ProductId = GetInt(reader, "ProductId"),
                SKU = GetString(reader, "SKU"),
                ProductName = GetString(reader, "ProductName"),
                CategoryId = GetInt(reader, "CategoryId"),
                CategoryName = GetString(reader, "CategoryName"),
                SupplierId = GetInt(reader, "SupplierId"),
                SupplierName = GetString(reader, "SupplierName"),
                UnitPrice = GetDecimal(reader, "UnitPrice"),
                ReorderLevel = GetInt(reader, "ReorderLevel"),
                IsActive = Convert.ToBoolean(reader["IsActive"]),
                TotalQuantity = GetInt(reader, "TotalQuantity")
            });
        }

        return products;
    }

    public async Task<int> CreateProductAsync(ProductViewModel model)
    {
        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_CreateProduct", connection);
        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@SKU", model.SKU);
        command.Parameters.AddWithValue("@ProductName", model.ProductName);
        command.Parameters.AddWithValue("@CategoryId", model.CategoryId);
        command.Parameters.AddWithValue("@SupplierId", model.SupplierId);
        command.Parameters.AddWithValue("@UnitPrice", model.UnitPrice);
        command.Parameters.AddWithValue("@ReorderLevel", model.ReorderLevel);
        command.Parameters.AddWithValue("@AppUserId", 1);

        var output = new SqlParameter("@NewProductId", SqlDbType.Int)
        {
            Direction = ParameterDirection.Output
        };
        command.Parameters.Add(output);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();

        return Convert.ToInt32(output.Value);
    }

    public async Task AddStockAsync(AddStockViewModel model)
    {
        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_AddStock", connection);
        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@ProductId", model.ProductId);
        command.Parameters.AddWithValue("@WarehouseId", model.WarehouseId);
        command.Parameters.AddWithValue("@Quantity", model.Quantity);
        command.Parameters.AddWithValue("@AppUserId", 1);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();
    }

    public async Task<List<OrderListItemViewModel>> GetRecentOrdersAsync()
    {
        var orders = new List<OrderListItemViewModel>();

        using var connection = CreateConnection();
        using var command = new SqlCommand("sales.usp_GetRecentOrders", connection);
        command.CommandType = CommandType.StoredProcedure;

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            orders.Add(new OrderListItemViewModel
            {
                OrderId = GetLong(reader, "OrderId"),
                CustomerId = GetInt(reader, "CustomerId"),
                CustomerName = GetString(reader, "CustomerName"),
                OrderDate = GetDateTime(reader, "OrderDate"),
                OrderStatus = GetString(reader, "OrderStatus"),
                TotalAmount = GetDecimal(reader, "TotalAmount"),
                CreatedByUserId = reader["CreatedByUserId"] == DBNull.Value ? null : GetInt(reader, "CreatedByUserId")
            });
        }

        return orders;
    }

    public async Task<long> CreateOrderAsync(OrderCreateViewModel model)
    {
        var itemsTable = new DataTable();
        itemsTable.Columns.Add("ProductId", typeof(int));
        itemsTable.Columns.Add("WarehouseId", typeof(int));
        itemsTable.Columns.Add("Quantity", typeof(int));
        itemsTable.Columns.Add("DiscountPercent", typeof(decimal));
        itemsTable.Rows.Add(model.ProductId, model.WarehouseId, model.Quantity, model.DiscountPercent);

        using var connection = CreateConnection();
        using var command = new SqlCommand("sales.usp_CreateOrder", connection);
        command.CommandType = CommandType.StoredProcedure;

        command.Parameters.AddWithValue("@CustomerId", model.CustomerId);
        command.Parameters.AddWithValue("@AppUserId", 1);

        var itemsParameter = command.Parameters.AddWithValue("@Items", itemsTable);
        itemsParameter.SqlDbType = SqlDbType.Structured;
        itemsParameter.TypeName = "sales.OrderItemInputType";

        var output = new SqlParameter("@NewOrderId", SqlDbType.BigInt)
        {
            Direction = ParameterDirection.Output
        };
        command.Parameters.Add(output);

        await connection.OpenAsync();
        await command.ExecuteNonQueryAsync();

        return Convert.ToInt64(output.Value);
    }

    public async Task<OrderDetailsViewModel> GetOrderDetailsAsync(long orderId)
    {
        var model = new OrderDetailsViewModel();

        using var connection = CreateConnection();
        using var command = new SqlCommand("sales.usp_GetOrderDetails", connection);
        command.CommandType = CommandType.StoredProcedure;
        command.Parameters.AddWithValue("@OrderId", orderId);

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        if (await reader.ReadAsync())
        {
            model.Order = new OrderListItemViewModel
            {
                OrderId = GetLong(reader, "OrderId"),
                CustomerId = GetInt(reader, "CustomerId"),
                CustomerName = GetString(reader, "CustomerName"),
                OrderDate = GetDateTime(reader, "OrderDate"),
                OrderStatus = GetString(reader, "OrderStatus"),
                TotalAmount = GetDecimal(reader, "TotalAmount"),
                CreatedByUserId = reader["CreatedByUserId"] == DBNull.Value ? null : GetInt(reader, "CreatedByUserId")
            };
        }

        await reader.NextResultAsync();

        while (await reader.ReadAsync())
        {
            model.Items.Add(new OrderItemViewModel
            {
                OrderItemId = GetLong(reader, "OrderItemId"),
                ProductId = GetInt(reader, "ProductId"),
                ProductName = GetString(reader, "ProductName"),
                WarehouseId = GetInt(reader, "WarehouseId"),
                WarehouseName = GetString(reader, "WarehouseName"),
                Quantity = GetInt(reader, "Quantity"),
                UnitPrice = GetDecimal(reader, "UnitPrice"),
                DiscountPercent = GetDecimal(reader, "DiscountPercent"),
                LineTotal = GetDecimal(reader, "LineTotal")
            });
        }

        return model;
    }

    public async Task<List<LowStockViewModel>> GetLowStockProductsAsync()
    {
        var rows = new List<LowStockViewModel>();

        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_GetLowStockProducts", connection);
        command.CommandType = CommandType.StoredProcedure;

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            rows.Add(new LowStockViewModel
            {
                ProductId = GetInt(reader, "ProductId"),
                SKU = GetString(reader, "SKU"),
                ProductName = GetString(reader, "ProductName"),
                WarehouseName = GetString(reader, "WarehouseName"),
                Quantity = GetInt(reader, "Quantity"),
                ReorderLevel = GetInt(reader, "ReorderLevel")
            });
        }

        return rows;
    }

    public async Task<List<AuditLogViewModel>> GetRecentAuditLogsAsync()
    {
        var logs = new List<AuditLogViewModel>();

        using var connection = CreateConnection();
        using var command = new SqlCommand("audit.usp_GetRecentAuditLogs", connection);
        command.CommandType = CommandType.StoredProcedure;

        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();

        while (await reader.ReadAsync())
        {
            logs.Add(new AuditLogViewModel
            {
                AuditLogId = GetLong(reader, "AuditLogId"),
                TableName = GetString(reader, "TableName"),
                ActionName = GetString(reader, "ActionName"),
                SchemaName = GetString(reader, "SchemaName"),
                RecordId = GetString(reader, "RecordId"),
                AppUserId = reader["AppUserId"] == DBNull.Value ? null : GetInt(reader, "AppUserId"),
                OldValue = GetString(reader, "OldValue"),
                NewValue = GetString(reader, "NewValue"),
                CreatedAt = GetDateTime(reader, "CreatedAt")
            });
        }

        return logs;
    }

    public async Task<List<CustomerOption>> GetCustomerOptionsAsync()
    {
        var customers = await GetCustomersAsync();
        return customers.Select(c => new CustomerOption { Id = c.CustomerId, Name = c.CustomerName }).ToList();
    }

    public async Task<List<ProductOption>> GetProductOptionsAsync()
    {
        var products = await GetProductsAsync();
        return products.Select(p => new ProductOption { Id = p.ProductId, Name = p.ProductName, CategoryId = p.CategoryId }).ToList();
    }

    public async Task<List<CategoryOption>> GetCategoriesAsync()
    {
        var rows = new List<CategoryOption>();
        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_GetCategories", connection);
        command.CommandType = CommandType.StoredProcedure;
        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
            rows.Add(new CategoryOption { Id = GetInt(reader, "CategoryId"), Name = GetString(reader, "CategoryName") });
        return rows;
    }

    public async Task<List<SupplierOption>> GetSuppliersAsync()
    {
        var rows = new List<SupplierOption>();
        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_GetSuppliers", connection);
        command.CommandType = CommandType.StoredProcedure;
        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
            rows.Add(new SupplierOption { Id = GetInt(reader, "SupplierId"), Name = GetString(reader, "SupplierName") });
        return rows;
    }

    public async Task<List<WarehouseOption>> GetWarehousesAsync()
    {
        var rows = new List<WarehouseOption>();
        using var connection = CreateConnection();
        using var command = new SqlCommand("inventory.usp_GetWarehouses", connection);
        command.CommandType = CommandType.StoredProcedure;
        await connection.OpenAsync();
        using var reader = await command.ExecuteReaderAsync();
        while (await reader.ReadAsync())
            rows.Add(new WarehouseOption { Id = GetInt(reader, "WarehouseId"), Name = GetString(reader, "WarehouseName") });
        return rows;
    }

    public async Task<FunctionLabViewModel> RunFunctionLabAsync(FunctionLabViewModel input)
    {
        var model = input;

        using var connection = CreateConnection();
        await connection.OpenAsync();

        using (var command = new SqlCommand("sales.usp_DemoCalculateLoyaltyPoints", connection))
        {
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@OrderTotal", model.OrderTotal);
            command.Parameters.AddWithValue("@CustomerTier", model.CustomerTier);
            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync()) model.EarnedPoints = GetInt(reader, "EarnedPoints");
        }

        using (var command = new SqlCommand("sales.usp_GetCustomerFinancialSummary", connection))
        {
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@CustomerId", model.CustomerId);
            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                model.CustomerName = GetString(reader, "CustomerName");
                model.TotalOrders = GetInt(reader, "TotalOrders");
                model.LifetimeValue = GetDecimal(reader, "LifetimeValue");
                model.LastOrderDate = reader["LastOrderDate"] == DBNull.Value ? null : GetDateTime(reader, "LastOrderDate");
            }
        }

        using (var command = new SqlCommand("app.usp_DemoMaskContactInfo", connection))
        {
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@Email", model.Email);
            command.Parameters.AddWithValue("@PhoneNumber", model.PhoneNumber);
            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                model.MaskedEmail = GetString(reader, "MaskedEmail");
                model.MaskedPhone = GetString(reader, "MaskedPhone");
            }
        }

        using (var command = new SqlCommand("app.usp_DemoCalculateWorkingDays", connection))
        {
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@StartDate", model.StartDate.Date);
            command.Parameters.AddWithValue("@EndDate", model.EndDate.Date);
            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync()) model.BusinessDays = GetInt(reader, "BusinessDays");
        }

        using (var command = new SqlCommand("app.usp_DemoGetFiscalPeriod", connection))
        {
            command.CommandType = CommandType.StoredProcedure;
            command.Parameters.AddWithValue("@InputDate", model.FiscalInputDate.Date);
            using var reader = await command.ExecuteReaderAsync();
            if (await reader.ReadAsync())
            {
                model.CalendarYear = GetInt(reader, "CalendarYear");
                model.CalendarMonth = GetInt(reader, "CalendarMonth");
                model.CalendarQuarter = GetInt(reader, "CalendarQuarter");
            }
        }

        return model;
    }
}
