using System.ComponentModel.DataAnnotations;

namespace RetailOpsLab.Models;

public class DashboardViewModel
{
    public int CustomersCount { get; set; }
    public int ProductsCount { get; set; }
    public int OrdersCount { get; set; }
    public int OrderItemsCount { get; set; }
    public int AuditLogsCount { get; set; }
}

public class CustomerViewModel
{
    public int CustomerId { get; set; }

    [Required]
    [Display(Name = "Customer Name")]
    public string CustomerName { get; set; } = "";

    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? City { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class ProductViewModel
{
    public int ProductId { get; set; }

    [Required]
    public string SKU { get; set; } = "";

    [Required]
    public string ProductName { get; set; } = "";

    [Range(1, int.MaxValue)]
    public int CategoryId { get; set; }
    public string CategoryName { get; set; } = "";

    [Range(1, int.MaxValue)]
    public int SupplierId { get; set; }
    public string SupplierName { get; set; } = "";

    [Range(0, 999999)]
    public decimal UnitPrice { get; set; }

    [Range(0, 999999)]
    public int ReorderLevel { get; set; } = 10;

    public bool IsActive { get; set; }
    public int TotalQuantity { get; set; }
}

public class LowStockViewModel
{
    public int ProductId { get; set; }
    public string SKU { get; set; } = "";
    public string ProductName { get; set; } = "";
    public string WarehouseName { get; set; } = "";
    public int Quantity { get; set; }
    public int ReorderLevel { get; set; }
}

public class AddStockViewModel
{
    [Range(1, int.MaxValue)]
    public int ProductId { get; set; }

    [Range(1, int.MaxValue)]
    public int WarehouseId { get; set; }

    [Range(1, 100000)]
    public int Quantity { get; set; } = 10;

    public List<ProductOption> Products { get; set; } = new();
    public List<WarehouseOption> Warehouses { get; set; } = new();
}

public class OrderListItemViewModel
{
    public long OrderId { get; set; }
    public int CustomerId { get; set; }
    public string CustomerName { get; set; } = "";
    public DateTime OrderDate { get; set; }
    public string OrderStatus { get; set; } = "";
    public decimal TotalAmount { get; set; }
    public int? CreatedByUserId { get; set; }
}

public class OrderCreateViewModel
{
    [Range(1, int.MaxValue)]
    public int CustomerId { get; set; }

    [Range(1, int.MaxValue)]
    public int ProductId { get; set; }

    [Range(1, int.MaxValue)]
    public int WarehouseId { get; set; } = 1;

    [Range(1, 1000)]
    public int Quantity { get; set; } = 1;

    [Range(0, 100)]
    public decimal DiscountPercent { get; set; }

    public List<CustomerOption> Customers { get; set; } = new();
    public List<ProductOption> Products { get; set; } = new();
    public List<WarehouseOption> Warehouses { get; set; } = new();
}

public class OrderDetailsViewModel
{
    public OrderListItemViewModel? Order { get; set; }
    public List<OrderItemViewModel> Items { get; set; } = new();
}

public class OrderItemViewModel
{
    public long OrderItemId { get; set; }
    public int ProductId { get; set; }
    public string ProductName { get; set; } = "";
    public int WarehouseId { get; set; }
    public string WarehouseName { get; set; } = "";
    public int Quantity { get; set; }
    public decimal UnitPrice { get; set; }
    public decimal DiscountPercent { get; set; }
    public decimal LineTotal { get; set; }
}

public class AuditLogViewModel
{
    public long AuditLogId { get; set; }
    public string TableName { get; set; } = "";
    public string ActionName { get; set; } = "";
    public string SchemaName { get; set; } = "";
    public string RecordId { get; set; } = "";
    public int? AppUserId { get; set; }
    public string? OldValue { get; set; }
    public string? NewValue { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class LookupOption
{
    public int Id { get; set; }
    public string Name { get; set; } = "";
}

public class CustomerOption : LookupOption { }
public class ProductOption : LookupOption
{
    public int CategoryId { get; set; }
}
public class WarehouseOption : LookupOption { }
public class CategoryOption : LookupOption { }
public class SupplierOption : LookupOption { }

public class FunctionLabViewModel
{
    public decimal OrderTotal { get; set; } = 1000;
    public int CustomerTier { get; set; } = 1;
    public int EarnedPoints { get; set; }

    public int CustomerId { get; set; } = 1;
    public string CustomerName { get; set; } = "";
    public int TotalOrders { get; set; }
    public decimal LifetimeValue { get; set; }
    public DateTime? LastOrderDate { get; set; }

    public string Email { get; set; } = "customer1@example.com";
    public string PhoneNumber { get; set; } = "01111111111";
    public string MaskedEmail { get; set; } = "";
    public string MaskedPhone { get; set; } = "";

    public DateTime StartDate { get; set; } = DateTime.Today.AddDays(-7);
    public DateTime EndDate { get; set; } = DateTime.Today;
    public int BusinessDays { get; set; }

    public DateTime FiscalInputDate { get; set; } = DateTime.Today;
    public int CalendarYear { get; set; }
    public int CalendarMonth { get; set; }
    public int CalendarQuarter { get; set; }
}
