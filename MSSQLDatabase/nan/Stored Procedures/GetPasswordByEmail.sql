-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 27-Apr-2017
-- Description:	
-- Call SP    :	
-- =============================================
CREATE PROCEDURE [nan].[GetPasswordByEmail] @Email NVARCHAR(100)
AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  U.Id ,
                U.EmailID ,
                U.Password
        FROM    nan.[User] AS U
        WHERE   U.EmailID = @Email
                AND ISNULL(U.IsDeleted, 0) = 0;
        
    END;