-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <02 Sep 2017>
-- Description:	<nan.ChangeFamilyDetailsStatus>
-- Call SP    :	nan.ChangeFamilyDetailsStatus
-- =============================================
CREATE PROCEDURE [nan].[ChangeFamilyDetailsStatus]
    @FamilyDetailsId BIGINT,
	@IsActive BIT,
	@IsDelete BIT,
	@IsFor NVARCHAR(20)
AS
    BEGIN
	DECLARE @IsDone BIT=0
        IF(@IsFor='active')
		BEGIN
		    UPDATE nan.FamilyDetails SET IsActiveProfile=@IsActive,ActiveProfileDateTime=GETUTCDATE()
			WHERE FamilyDetailsId=@FamilyDetailsId
			SET @IsDone=1
		END
		ELSE IF(@IsFor='delete')
		BEGIN
		    UPDATE nan.FamilyDetails SET IsDeleteProfile=@IsActive,DeleteProfileDateTime=GETUTCDATE()
			WHERE FamilyDetailsId=@FamilyDetailsId
			SET @IsDone=1
		END
		ELSE IF(@IsFor='inactive')
		BEGIN
		    UPDATE nan.FamilyDetails SET IsActiveProfile=@IsActive,ActiveProfileDateTime=GETUTCDATE()
			WHERE FamilyDetailsId=@FamilyDetailsId
			SET @IsDone=1
		END
		SELECT ISNULL(@IsDone,0) AS IsDone
    END;