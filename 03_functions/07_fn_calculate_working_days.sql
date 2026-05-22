CREATE FUNCTION App.fn_CalculateWorkingDays
(
    @StartDate DATE,
    @EndDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        (DATEDIFF(dd, @StartDate, @EndDate) + 1)
        -(DATEDIFF(wk, @StartDate, @EndDate) * 2)
        -(CASE WHEN DATENAME(dw, @StartDate) = 'Sunday' THEN 1 ELSE 0 END)
        -(CASE WHEN DATENAME(dw, @EndDate) = 'Saturday' THEN 1 ELSE 0 END)
        AS BusinessDays
);