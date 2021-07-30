-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <02 Sep 2017>
-- Description:	<nan.GetActiveFamilyEmail>
-- Call SP    :	nan.GetActiveFamilyEmail
-- =============================================
CREATE PROCEDURE [nan].[GetActiveFamilyEmail]
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  FD.FamilyDetailsId AS FamilyDetailsId ,
                FD.FamilyDetailsName AS FamilyDetailsName ,
                FD.Email AS Email
        FROM    nan.FamilyDetails AS FD
        WHERE   ISNULL(FD.IsDeleteProfile, 0) = 0
                AND ISNULL(FD.IsDeleted, 0) = 0
                AND ISNULL(FD.IsActiveProfile, 0) = 1
                AND ISNULL(FD.Email, '') != '';
    END;