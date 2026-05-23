USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_DemoCalculateLoyaltyPoints
    @OrderTotal DECIMAL(18,2),
    @CustomerTier INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT EarnedPoints
    FROM sales.fn_CalculateLoyaltyPoints(@OrderTotal, @CustomerTier);
END;
GO

CREATE OR ALTER PROCEDURE sales.usp_GetCustomerFinancialSummary
    @CustomerId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        CustomerId,
        CustomerName,
        TotalOrders,
        LifetimeValue,
        LastOrderDate
    FROM sales.fn_GetCustomerFinancialSummary(@CustomerId);
END;
GO

CREATE OR ALTER PROCEDURE app.usp_DemoMaskContactInfo
    @Email NVARCHAR(256),
    @PhoneNumber NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT MaskedEmail, MaskedPhone
    FROM app.fn_MaskContactInfo(@Email, @PhoneNumber);
END;
GO

CREATE OR ALTER PROCEDURE app.usp_DemoCalculateWorkingDays
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT BusinessDays
    FROM app.fn_CalculateWorkingDays(@StartDate, @EndDate);
END;
GO

CREATE OR ALTER PROCEDURE app.usp_DemoGetFiscalPeriod
    @InputDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    SELECT CalendarYear, CalendarMonth, CalendarQuarter
    FROM app.fn_GetFiscalPeriod(@InputDate);
END;
GO
