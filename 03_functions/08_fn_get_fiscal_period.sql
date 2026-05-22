CREATE FUNCTION App.fn_GetFiscalPeriod
(
    @InputDate DATE
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        YEAR(@InputDate) AS CalendarYear,
        MONTH(@InputDate) AS CalendarMonth,
        DATEPART(QUARTER, @InputDate) AS CalendarQuarter
);