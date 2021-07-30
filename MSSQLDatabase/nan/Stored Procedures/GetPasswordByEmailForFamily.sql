-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 27-Apr-2017
-- Description:	
-- Call SP    :	
-- =============================================
CREATE PROCEDURE [nan].[GetPasswordByEmailForFamily] @Email NVARCHAR(100)
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  FD.FamilyDetailsId ,
                FD.Email ,
                FD.Password
        FROM    nan.FamilyDetails AS FD
        WHERE   FD.Email = @Email
                AND ISNULL(FD.IsDeleted, 0) = 0;
    END;