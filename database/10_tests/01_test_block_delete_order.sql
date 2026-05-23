USE RetailOpsLab;
GO

/*
This should fail because direct delete is blocked by a trigger.
*/

DELETE FROM sales.Orders
WHERE OrderId = 1;
GO

SELECT TOP 20 *
FROM audit.BlockedActions
ORDER BY BlockedActionId DESC;
GO
