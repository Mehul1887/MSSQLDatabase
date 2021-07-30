-- =============================================
-- Author:		<Author,,Mitesh>
-- Create date: <Create Date,,31 Aug 2017>
-- Description:	<GetFreeSubscriptionStatus>
-- Call SP:		nan.GetFreeSubscriptionStatus 55,1,'',''
-- =============================================
CREATE PROCEDURE [nan].[GetFreeSubscriptionStatus]
	@FamilDetailsId BIGINT
AS
    BEGIN 
        SET NOCOUNT ON;
		DECLARE @IsFree BIT,@FreeSubscriptionInDays INT,@IsSubscribed BIT
		 IF EXISTS ( SELECT  FS.FamilySubscriptionId
                    FROM    nan.FamilySubscription AS FS
                    WHERE   FS.FamilyDetailsId = @FamilDetailsId
                            AND CAST(GETUTCDATE() AS DATE) >= CAST(FS.StartDate AS DATE)
                            AND CAST(GETUTCDATE() AS DATE) <= CAST(FS.EndDate AS DATE)
                            AND ISNULL(FS.IsDeleted, 0) = 0 )
            BEGIN
                SET @IsSubscribed = 1;
            END;
        ELSE
            BEGIN
				SELECT @IsFree= CAST(ACS.KeyValue AS BIT) FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='IsFree'
				IF @IsFree=1
				BEGIN
				    SET @IsSubscribed = 1;
				END
				ELSE
				BEGIN
                SET @IsSubscribed = 0;
				END

            END;

		SELECT  @FreeSubscriptionInDays =CAST(ISNULL(KeyValue,0) AS INT)
        FROM    nan.AAAAConfigSettings
        WHERE   KeyName='FreeSubscriptionInDays'

		SELECT ISNULL(@IsSubscribed,0) AS IsFree,ISNULL(@FreeSubscriptionInDays,0) AS FreeSubscriptionDays
    END;