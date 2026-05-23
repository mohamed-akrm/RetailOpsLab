USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION app.fn_CalculateWorkingDays
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        (DATEDIFF(DAY, @StartDate, @EndDate) + 1)
        - (DATEDIFF(WEEK, @StartDate, @EndDate) * 2)
        - (CASE WHEN DATENAME(WEEKDAY, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)
        - (CASE WHEN DATENAME(WEEKDAY, @EndDate) = 'Saturday' THEN 1 ELSE 0 END)
        AS BusinessDays
);
GO
