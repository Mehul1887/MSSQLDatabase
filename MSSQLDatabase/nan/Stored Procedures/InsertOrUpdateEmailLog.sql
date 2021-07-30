-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,InsertOrUpdateEmailLog>
-- Call SP    :	InsertOrUpdateEmailLog
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateEmailLog]
    @Id BIGINT ,
    @RelaventId BIGINT ,
    @ModuleId BIGINT ,
    @MailContent NVARCHAR(MAX) ,
    @MailTo NVARCHAR(MAX) ,
    @CC NVARCHAR(MAX) ,
    @BCC NVARCHAR(MAX) ,
    @SentOn DATETIME ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @Id = 0 )
            BEGIN
                INSERT  INTO nan.[EmailLog]
                        ( [RelaventId] ,                          
                          [MailContent] ,
                          [MailTo] ,
                          [CC] ,
                          [BCC] ,
                          [SentOn] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted] 
                        )
                VALUES  ( @RelaventId ,                          
                          @MailContent ,
                          @MailTo ,
                          @CC ,
                          @BCC ,
                          @SentOn ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
                SELECT  @Id = SCOPE_IDENTITY();
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
                          'Insert record in table EmailLog' ,
                          'EmailLog' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
            END;
        ELSE
            BEGIN
                UPDATE  EL
                SET     [RelaventId] = @RelaventId ,
                        [MailContent] = @MailContent ,
                        [MailTo] = @MailTo ,
                        [CC] = @CC ,
                        [BCC] = @BCC ,
                        [SentOn] = @SentOn ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[EmailLog] AS EL
                WHERE   [Id] = @Id;
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
                          'Update record in table EmailLog' ,
                          'EmailLog' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
            END;
        SELECT  ISNULL(@Id, 0) AS InsertedId;
    END;