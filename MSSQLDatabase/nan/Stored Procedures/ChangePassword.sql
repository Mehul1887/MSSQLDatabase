-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 27-Apr-2017
-- Description:	
-- Call SP    :	nan.ChangePassword '1','1'    
-- =============================================
CREATE PROCEDURE [nan].[ChangePassword]    
    @OldPassword NVARCHAR(100) ,
    @NewPassword NVARCHAR(100)
AS
    BEGIN
        SET NOCOUNT ON;

        IF EXISTS ( SELECT  U.Id
                    FROM    nan.[User] AS U
                    WHERE   U.Password = @OldPassword )
            BEGIN
                UPDATE  nan.[User]
                SET     Password = @NewPassword
                WHERE   Password=@OldPassword
                SELECT  CAST(1 AS INT) AS PasswordChange;
            END;

        ELSE
            BEGIN
                SELECT  CAST(0 AS INT) AS PasswordChange;
            END;
   
    END;