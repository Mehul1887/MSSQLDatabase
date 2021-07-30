-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 27-Apr-2017
-- Description:	
-- Call SP    :	
-- =============================================
CREATE PROCEDURE [nan].[ChangePasswordForFamily]
    @FamilyId BIGINT ,
    @OldPassword NVARCHAR(100) ,
    @NewPassword NVARCHAR(100)
AS
    BEGIN
	SET NOCOUNT ON
        IF EXISTS ( SELECT  FD.FamilyDetailsId
                    FROM    nan.FamilyDetails AS FD
                    WHERE   FD.FamilyDetailsId = @FamilyId
                            AND FD.Password = @OldPassword )
            BEGIN
                UPDATE  FD
                SET     [Password] = @NewPassword
				FROM nan.FamilyDetails AS FD
                WHERE   FamilyDetailsId = @FamilyId;
                SELECT  ISNULL(CAST(1 AS INT),0) AS PasswordChange;
            END;
        ELSE
            BEGIN
                SELECT  ISNULL(CAST(0 AS INT),0) AS PasswordChange;
            END;
    END;