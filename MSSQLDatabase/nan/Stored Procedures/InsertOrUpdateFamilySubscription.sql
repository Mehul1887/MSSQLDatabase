-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateFamilySubscription>
-- Call SP    :	InsertOrUpdateFamilySubscription
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateFamilySubscription]
    @FamilySubscriptionId BIGINT ,
    @FamilySubscriptionName NVARCHAR(100) ,
    @FamilyDetailsId BIGINT ,
    @SubscriptionMasterId BIGINT ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	DECLARE @Period INT=(SELECT SM.SubscriptionPeriod FROM nan.SubscriptionMaster AS SM WHERE SM.SubscriptionMasterId=@SubscriptionMasterId)
	SET NOCOUNT ON
        IF ( @FamilySubscriptionId = 0 )
            BEGIN
                INSERT  INTO nan.[FamilySubscription]
                        ( [FamilySubscriptionName] ,
                          [FamilyDetailsId] ,
                          [SubscriptionMasterId] ,
						  StartDate,
						  EndDate,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @FamilySubscriptionName ,
                          @FamilyDetailsId ,
                          @SubscriptionMasterId ,
						  GETUTCDATE(),
						  DATEADD(DAY,@Period,GETUTCDATE()),
                          GETUTCDATE() ,
                          @UserId ,
                          1
                        );
                SELECT  @FamilySubscriptionId = SCOPE_IDENTITY();
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Insert record in table FamilySubscription' ,
                          'FamilySubscription' ,
                          @FamilySubscriptionId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  FS
                SET     [FamilySubscriptionName] = @FamilySubscriptionName ,
                        [FamilyDetailsId] = @FamilyDetailsId ,
                        [SubscriptionMasterId] = @SubscriptionMasterId ,						
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId							
						FROM nan.[FamilySubscription] AS FS
                WHERE   [FamilySubscriptionId] = @FamilySubscriptionId;
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Update record in table FamilySubscription' ,
                          'FamilySubscription' ,
                          @FamilySubscriptionId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@FamilySubscriptionId, 0) AS InsertedId;
    END;