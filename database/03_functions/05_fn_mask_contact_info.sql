USE RetailOpsLab;
GO

CREATE OR ALTER FUNCTION app.fn_MaskContactInfo
(
    @Email NVARCHAR(256),
    @PhoneNumber NVARCHAR(50)
)
RETURNS TABLE
AS
RETURN
(
    SELECT
        CASE
            WHEN @Email IS NOT NULL AND CHARINDEX('@', @Email) > 2
                THEN LEFT(@Email, 2) + '***' + SUBSTRING(@Email, CHARINDEX('@', @Email), LEN(@Email))
            ELSE '***'
        END AS MaskedEmail,
        CASE
            WHEN @PhoneNumber IS NOT NULL AND LEN(@PhoneNumber) >= 4
                THEN '***-***-' + RIGHT(@PhoneNumber, 4)
            ELSE '***'
        END AS MaskedPhone
);
GO
