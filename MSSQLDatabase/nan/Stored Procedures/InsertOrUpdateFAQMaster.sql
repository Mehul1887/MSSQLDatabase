-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateFAQMaster>
-- Call SP    :	InsertOrUpdateFAQMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateFAQMaster]
    @FAQMasterId BIGINT ,
    @FAQMasterName NVARCHAR(100) ,
    @FaqQuestion NVARCHAR(500) ,
    @FaqAnswer NVARCHAR(1000) ,
	@Sequence INT,
	@IsActive BIT,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @FAQMasterId = 0 )
            BEGIN
                INSERT  INTO nan.[FAQMaster]
                        ( [FAQMasterName] ,
                          [FaqQuestion] ,
                          [FaqAnswer] ,
						  [Sequence],
						  [IsActive],
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @FAQMasterName ,
                          @FaqQuestion ,
                          @FaqAnswer ,
						  @Sequence,
						  @IsActive,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @FAQMasterId = SCOPE_IDENTITY();
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
                          'Insert record in table FAQMaster' ,
                          'FAQMaster' ,
                          @FAQMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  FAQ
                SET     [FAQMasterName] = @FAQMasterName ,
                        [FaqQuestion] = @FaqQuestion ,
                        [FaqAnswer] = @FaqAnswer ,
						Sequence=@Sequence,
						IsActive=@IsActive,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[FAQMaster] AS FAQ
                WHERE   [FAQMasterId] = @FAQMasterId;
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
                          'Update record in table FAQMaster' ,
                          'FAQMaster' ,
                          @FAQMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@FAQMasterId, 0) AS InsertedId;
    END;