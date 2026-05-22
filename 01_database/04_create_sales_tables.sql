USE RetailOpsLab;
GO

CREATE TABLE sales.Customers
(
    CustomerId INT IDENTITY(1,1) CONSTRAINT PK_Customers PRIMARY KEY,
    CustomerName NVARCHAR(200) NOT NULL,
    Phone NVARCHAR(50) NULL,
    Email NVARCHAR(200) NULL,
    City NVARCHAR(100) NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Customers_IsActive DEFAULT (1),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_Customers_CreatedAt DEFAULT SYSUTCDATETIME()
);
GO

CREATE TABLE sales.Orders
(
    OrderId BIGINT IDENTITY(1,1) CONSTRAINT PK_Orders PRIMARY KEY,
    CustomerId INT NOT NULL,
    OrderDate DATETIME2(0) NOT NULL CONSTRAINT DF_Orders_OrderDate DEFAULT SYSUTCDATETIME(),
    OrderStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_Orders_OrderStatus DEFAULT N'Pending',
    TotalAmount DECIMAL(18,2) NOT NULL CONSTRAINT DF_Orders_TotalAmount DEFAULT (0),
    CreatedByUserId INT NULL,

    CONSTRAINT CK_Orders_OrderStatus CHECK (OrderStatus IN (N'Pending', N'Completed', N'Cancelled', N'Late')),
    CONSTRAINT CK_Orders_TotalAmount CHECK (TotalAmount >= 0),
    CONSTRAINT FK_Orders_Customers FOREIGN KEY (CustomerId) REFERENCES sales.Customers(CustomerId),
    CONSTRAINT FK_Orders_Users FOREIGN KEY (CreatedByUserId) REFERENCES app.Users(UserId)
);
GO

CREATE TABLE sales.OrderItems
(
    OrderItemId BIGINT IDENTITY(1,1) CONSTRAINT PK_OrderItems PRIMARY KEY,
    OrderId BIGINT NOT NULL,
    ProductId INT NOT NULL,
    WarehouseId INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(18,2) NOT NULL,
    DiscountPercent DECIMAL(5,2) NOT NULL CONSTRAINT DF_OrderItems_DiscountPercent DEFAULT (0),
    LineTotal DECIMAL(18,2) NOT NULL,

    CONSTRAINT CK_OrderItems_Quantity CHECK (Quantity > 0),
    CONSTRAINT CK_OrderItems_UnitPrice CHECK (UnitPrice >= 0),
    CONSTRAINT CK_OrderItems_DiscountPercent CHECK (DiscountPercent >= 0 AND DiscountPercent <= 100),
    CONSTRAINT CK_OrderItems_LineTotal CHECK (LineTotal >= 0),
    CONSTRAINT FK_OrderItems_Orders FOREIGN KEY (OrderId) REFERENCES sales.Orders(OrderId),
    CONSTRAINT FK_OrderItems_Products FOREIGN KEY (ProductId) REFERENCES inventory.Products(ProductId),
    CONSTRAINT FK_OrderItems_Warehouses FOREIGN KEY (WarehouseId) REFERENCES inventory.Warehouses(WarehouseId)
);
GO

CREATE TABLE sales.Payments
(
    PaymentId BIGINT IDENTITY(1,1) CONSTRAINT PK_Payments PRIMARY KEY,
    OrderId BIGINT NOT NULL,
    PaymentDate DATETIME2(0) NOT NULL CONSTRAINT DF_Payments_PaymentDate DEFAULT SYSUTCDATETIME(),
    Amount DECIMAL(18,2) NOT NULL,
    PaymentMethod NVARCHAR(50) NOT NULL,
    PaymentStatus NVARCHAR(30) NOT NULL CONSTRAINT DF_Payments_PaymentStatus DEFAULT N'Paid',

    CONSTRAINT CK_Payments_Amount CHECK (Amount > 0),
    CONSTRAINT CK_Payments_Status CHECK (PaymentStatus IN (N'Paid', N'Refunded', N'Failed')),
    CONSTRAINT FK_Payments_Orders FOREIGN KEY (OrderId) REFERENCES sales.Orders(OrderId)
);
GO

CREATE TABLE sales.Returns
(
    ReturnId BIGINT IDENTITY(1,1) CONSTRAINT PK_Returns PRIMARY KEY,
    OrderId BIGINT NOT NULL,
    ProductId INT NOT NULL,
    WarehouseId INT NOT NULL,
    Quantity INT NOT NULL,
    ReturnDate DATETIME2(0) NOT NULL CONSTRAINT DF_Returns_ReturnDate DEFAULT SYSUTCDATETIME(),
    Reason NVARCHAR(300) NULL,

    CONSTRAINT CK_Returns_Quantity CHECK (Quantity > 0),
    CONSTRAINT FK_Returns_Orders FOREIGN KEY (OrderId) REFERENCES sales.Orders(OrderId),
    CONSTRAINT FK_Returns_Products FOREIGN KEY (ProductId) REFERENCES inventory.Products(ProductId),
    CONSTRAINT FK_Returns_Warehouses FOREIGN KEY (WarehouseId) REFERENCES inventory.Warehouses(WarehouseId)
);
GO

CREATE TABLE inventory.InventoryTransactions
(
    InventoryTransactionId BIGINT IDENTITY(1,1) CONSTRAINT PK_InventoryTransactions PRIMARY KEY,
    ProductId INT NOT NULL,
    WarehouseId INT NOT NULL,
    QuantityChange INT NOT NULL,
    TransactionType NVARCHAR(30) NOT NULL,
    ReferenceOrderId BIGINT NULL,
    CreatedByUserId INT NULL,
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_InventoryTransactions_CreatedAt DEFAULT SYSUTCDATETIME(),

    CONSTRAINT CK_InventoryTransactions_Type CHECK (TransactionType IN (N'SALE', N'PURCHASE', N'RETURN', N'ADJUSTMENT')),
    CONSTRAINT FK_InventoryTransactions_Products FOREIGN KEY (ProductId) REFERENCES inventory.Products(ProductId),
    CONSTRAINT FK_InventoryTransactions_Warehouses FOREIGN KEY (WarehouseId) REFERENCES inventory.Warehouses(WarehouseId),
    CONSTRAINT FK_InventoryTransactions_Orders FOREIGN KEY (ReferenceOrderId) REFERENCES sales.Orders(OrderId),
    CONSTRAINT FK_InventoryTransactions_Users FOREIGN KEY (CreatedByUserId) REFERENCES app.Users(UserId)
);
GO
