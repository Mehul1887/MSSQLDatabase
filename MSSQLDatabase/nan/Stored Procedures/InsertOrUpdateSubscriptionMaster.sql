-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateSubscriptionMaster>
-- Call SP    :	InsertOrUpdateSubscriptionMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateSubscriptionMaster]
    @SubscriptionMasterId BIGINT ,
    @SubscriptionMasterName NVARCHAR(100) ,
    @SubscriptionPeriod BIGINT ,
    @Price DECIMAL(10, 0) ,
	@ISActive BIT,    
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
	 DECLARE @InsertedId BIGINT;
        IF EXISTS (SELECT SM.SubscriptionMasterId FROM nan.SubscriptionMaster AS SM WHERE ISNULL(SM.IsDeleted,0)=0 AND @SubscriptionMasterName=SM.SubscriptionMasterName AND SM.SubscriptionMasterId!=@SubscriptionMasterId)
            BEGIN
                SET @InsertedId = -1;
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
			ELSE
			BEGIN
			    

        IF ( @SubscriptionMasterId = 0 )
            BEGIN
                INSERT  INTO nan.[SubscriptionMaster]
                        ( [SubscriptionMasterName] ,
                          [SubscriptionPeriod] ,
                          [Price] ,
						  [IsActive],
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @SubscriptionMasterName ,
                          @SubscriptionPeriod ,
                          @Price ,
						  @ISActive,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @SubscriptionMasterId = SCOPE_IDENTITY();
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
                          'Insert record in table SubscriptionMaster' ,
                          'SubscriptionMaster' ,
                          @SubscriptionMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  SubscriptionMaster
                SET     [SubscriptionMasterName] = @SubscriptionMasterName ,
                        [SubscriptionPeriod] = @SubscriptionPeriod ,
                        [Price] = @Price ,
						[IsActive]=@ISActive,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[SubscriptionMaster] AS SubscriptionMaster
                WHERE   [SubscriptionMasterId] = @SubscriptionMasterId;
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
                          'Update record in table SubscriptionMaster' ,
                          'SubscriptionMaster' ,
                          @SubscriptionMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@SubscriptionMasterId, 0) AS InsertedId;
					END
    END;