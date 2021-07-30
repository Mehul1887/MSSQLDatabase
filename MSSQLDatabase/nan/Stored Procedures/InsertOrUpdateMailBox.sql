-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateMailBox>
-- Call SP    :	[nan].InsertOrUpdateMailBox 9,'Shah',9,16,'<p>Reply from martin to patel</p>','Next Meeting',true,9,true,false,'','',0,0

-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateMailBox]
    @MailBoxId BIGINT ,
    @MailBoxName NVARCHAR(100) ,
    @FromID BIGINT ,
    @ToID BIGINT ,
    @BodyText NVARCHAR(1000) ,
    @Subject NVARCHAR(100) ,
    @IsParent BIT ,
    @ParentMailID BIGINT ,
    @IsRead BIT ,
    @IsTrash BIT ,
    @TrashOn DATETIME ,
    @MailSentOn DATETIME ,
	@IsReply BIT,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	DECLARE @mailboxidtemp BIGINT
	SET NOCOUNT ON
		
        IF ( @MailBoxId = 0 )
            BEGIN
                INSERT  INTO nan.[MailBox]
                        ( [MailBoxName] ,
                          [FromID] ,
                          [ToID] ,
                          [BodyText] ,
                          [Subject] ,
                          [IsParent] ,
                          [ParentMailID] ,
                          [IsRead] ,
                          [IsTrash] ,
                          [TrashOn] ,
                          [MailSentOn] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @MailBoxName ,
                          @FromID ,
                          @ToID ,
                          @BodyText ,
                          @Subject ,
                          @IsParent ,
                          @ParentMailID ,
                          @IsRead ,
                          @IsTrash ,
                          @TrashOn ,
                          @MailSentOn ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @MailBoxId = SCOPE_IDENTITY();				
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
                          'Insert record in table MailBox' ,
                          'MailBox' ,
                          @MailBoxId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
						
            END
			ELSE IF @MailBoxId>0 AND @IsReply=1
			BEGIN
				SET @ParentMailID = @MailBoxId;

			      INSERT  INTO nan.[MailBox]
                        ( [MailBoxName] ,
                          [FromID] ,
                          [ToID] ,
                          [BodyText] ,
                          [Subject] ,
                          [IsParent] ,
                          [ParentMailID] ,
                          [IsRead] ,
                          [IsTrash] ,
                          [TrashOn] ,
                          [MailSentOn] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @MailBoxName ,
                          @FromID ,
                          @ToID ,
                          @BodyText ,
                          @Subject ,
                          0 ,
                          @ParentMailID ,
                          @IsRead ,
                          @IsTrash ,
                          @TrashOn ,
                          @MailSentOn ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @MailBoxId = SCOPE_IDENTITY();				
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
                          'Insert record in table MailBox' ,
                          'MailBox' ,
                          @MailBoxId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
			END
			ELSE
			BEGIN
		
                UPDATE  MailBox
                SET     [MailBoxName] = @MailBoxName ,
                        [FromID] = @FromID ,
                        [ToID] = @ToID ,
                        [BodyText] = @BodyText ,
                        [Subject] = @Subject ,
                        [IsParent] = @IsParent ,
                        [ParentMailID] = @ParentMailID ,
                        [IsRead] = @IsRead ,
                        [IsTrash] = @IsTrash ,
                        [TrashOn] = @TrashOn ,
                        [MailSentOn] = @MailSentOn ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[MailBox] AS MailBox
                WHERE   [MailBoxId] = @MailBoxId;
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
                          'Update record in table MailBox' ,
                          'MailBox' ,
                          @MailBoxId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
          END
        SELECT  ISNULL(@MailBoxId, 0) AS InsertedId;
    END;