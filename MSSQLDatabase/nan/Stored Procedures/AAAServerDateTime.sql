-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- Call SP    :	AAA_ServerDateTime
-- =============================================
CREATE PROCEDURE [nan].[AAAServerDateTime]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  GETDATE() AS ServerDateTime ,
                GETUTCDATE() AS [UTCDateTime] ,
                CONVERT(VARCHAR(50), GETDATE(), 103) AS Date_DMY ,
                CONVERT(VARCHAR(50), GETDATE(), 101) AS Date_MDY;
    END;