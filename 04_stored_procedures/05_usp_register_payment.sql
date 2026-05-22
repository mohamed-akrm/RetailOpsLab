USE RetailOpsLab;
GO

CREATE OR ALTER PROCEDURE sales.usp_RegisterPayment
    @OrderId BIGINT,
    @Amount DECIMAL(18,2),
    @PaymentMethod NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Amount <= 0
        THROW 50020, 'Payment amount must be greater than zero.', 1;

    IF NOT EXISTS (SELECT 1 FROM sales.Orders WHERE OrderId = @OrderId)
        THROW 50021, 'Order does not exist.', 1;

    INSERT INTO sales.Payments
    (
        OrderId,
        Amount,
        PaymentMethod,
        PaymentStatus
    )
    VALUES
    (
        @OrderId,
        @Amount,
        @PaymentMethod,
        N'Paid'
    );
END;
GO
