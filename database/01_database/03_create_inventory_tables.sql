USE RetailOpsLab;
GO

CREATE TABLE inventory.Categories
(
    CategoryId INT IDENTITY(1,1) CONSTRAINT PK_Categories PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL CONSTRAINT UQ_Categories_CategoryName UNIQUE
);
GO

CREATE TABLE inventory.Suppliers
(
    SupplierId INT IDENTITY(1,1) CONSTRAINT PK_Suppliers PRIMARY KEY,
    SupplierName NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(50) NULL,
    City NVARCHAR(100) NULL
);
GO

CREATE TABLE inventory.Products
(
    ProductId INT IDENTITY(1,1) CONSTRAINT PK_Products PRIMARY KEY,
    SKU NVARCHAR(50) NOT NULL CONSTRAINT UQ_Products_SKU UNIQUE,
    ProductName NVARCHAR(200) NOT NULL,
    CategoryId INT NOT NULL,
    SupplierId INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    ReorderLevel INT NOT NULL CONSTRAINT DF_Products_ReorderLevel DEFAULT (20),
    IsActive BIT NOT NULL CONSTRAINT DF_Products_IsActive DEFAULT (1),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Products_CreatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT CK_Products_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT CK_Products_ReorderLevel CHECK (ReorderLevel >= 0),
    CONSTRAINT FK_Products_Categories FOREIGN KEY (CategoryId) REFERENCES inventory.Categories(CategoryId),
    CONSTRAINT FK_Products_Suppliers FOREIGN KEY (SupplierId) REFERENCES inventory.Suppliers(SupplierId)
);
GO

CREATE TABLE inventory.Warehouses
(
    WarehouseId INT IDENTITY(1,1) CONSTRAINT PK_Warehouses PRIMARY KEY,
    WarehouseName NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NULL
);
GO

CREATE TABLE inventory.Stock
(
    ProductId INT NOT NULL,
    WarehouseId INT NOT NULL,
    Quantity INT NOT NULL CONSTRAINT DF_Stock_Quantity DEFAULT (0),
    LastUpdatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Stock_LastUpdatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT PK_Stock PRIMARY KEY (ProductId, WarehouseId),
    CONSTRAINT CK_Stock_Quantity CHECK (Quantity >= 0),
    CONSTRAINT FK_Stock_Products FOREIGN KEY (ProductId) REFERENCES inventory.Products(ProductId),
    CONSTRAINT FK_Stock_Warehouses FOREIGN KEY (WarehouseId) REFERENCES inventory.Warehouses(WarehouseId)
);
GO
