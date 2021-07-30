-- =============================================
-- Author: Sanjay Chaudhary  
-- Create date: 17-Jan-2018
-- Description: 
-- Call SP    : nan.ChangeUserName 'admin'
-- =============================================
CREATE PROCEDURE [nan].[ChangeUserName]
    @UserName NVARCHAR(100)
AS
    BEGIN
        DECLARE @IsDone BIT= 0;
        UPDATE  nan.[User]
        SET     UserName = @UserName ,
                @IsDone = 1;

        SELECT  ISNULL(@IsDone, 0) AS IsDone,ISNULL(@UserName,'') AS UserName;        
    END;