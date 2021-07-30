-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<nan.IsRegisteredEmail>
-- Call SP    :	nan.IsRegisteredEmail 15
-- =============================================
CREATE PROCEDURE [nan].[IsRegisteredEmail]
    @RecordId BIGINT,
	@IsFor NVARCHAR(100),
	@Email NVARCHAR(100)
AS
    BEGIN
        SET NOCOUNT ON; 
        DECLARE @IsRegistered BIT;
        IF @IsFor='AgencyDetails'
		BEGIN
		    IF EXISTS(SELECT AD.AgencyDetailsId FROM nan.AgencyDetails AS AD WHERE ISNULL(AD.IsDeleteProfile,0)=0 AND ISNULL(AD.IsDeleted,0)=0 AND AD.AgencyDetailsId!=@RecordId AND AD.Email=@Email)
			BEGIN
			    SET @IsRegistered=1
			END
			--IF EXISTS(SELECT * FROM nan.FamilyDetails AS FD WHERE ISNULL(FD.IsDeleteProfile,0)=0 AND ISNULL(FD.IsDeleted,0)=0 AND FD.Email=@Email)
			--BEGIN
			--    SET @IsRegistered=1
			--END
		END
		ELSE IF @IsFor='FamilyDetails'
		BEGIN
		 --    IF EXISTS(SELECT AD.AgencyDetailsId FROM nan.AgencyDetails AS AD WHERE ISNULL(AD.IsDeleteProfile,0)=0 AND ISNULL(AD.IsDeleted,0)=0 AND AD.Email=@Email)
			--BEGIN
			--    SET @IsRegistered=1
			--END
			IF EXISTS(SELECT * FROM nan.FamilyDetails AS FD WHERE ISNULL(FD.IsDeleteProfile,0)=0 AND ISNULL(FD.IsDeleted,0)=0 AND FD.Email=@Email AND FD.FamilyDetailsId!=@RecordId)
			BEGIN
			    SET @IsRegistered=1
			END
		END
		SELECT ISNULL(@IsRegistered,0) AS IsRegistered
    END;