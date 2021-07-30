-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,InsertOrUpdateContactUs>
-- Call SP    :	InsertOrUpdateContactUs
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateContactUs]
    @Id BIGINT ,
    @Name NVARCHAR(50) ,
    @Subject NVARCHAR(500) ,
    @BodyText NVARCHAR(max) ,
	@ReplyText NVARCHAR(MAX),
    @EmailId NVARCHAR(50) ,
    @IsReply BIT ,
    @IsRead BIT ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @Id = 0 )
            BEGIN
                INSERT INTO nan.ContactUs
                        ( 
                          Name ,
                          EmailId ,
                          Subject ,
                          BodyText ,
                          IsRead ,
                          IsReply ,
                          CreatedOn ,
                          CreatedBy ,                                              
                          IsDeleted
                        )
                VALUES  (
							@Name,
							@EmailId,
							@Subject,
							@BodyText,
							@IsRead,
							@IsReply,
							GETUTCDATE(),
							@UserId,
							0							
                        )
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
                          'Insert record in table ContactUs' ,
                          'ContactUs' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
            END;
        ELSE
            BEGIN
			DECLARE @ReplyDate DATETIME=NULL
			IF(@IsReply=1 AND ISNULL(@ReplyText,'')!='')
				BEGIN
				SET @ReplyDate=GETUTCDATE()
				END		
                UPDATE CU
						SET CU.ReplyText=@ReplyText,
						CU.IsReply=@IsReply,
						CU.IsRead=@IsRead,
						CU.ReplyOn=@ReplyDate,
						CU.UpdatedOn=GETUTCDATE(),
						CU.UpdatedBy=@UserId
                         FROM nan.ContactUs CU
                WHERE   [ContactUsId] = @Id;
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
                          'Update record in table ContactUs' ,
                          'ContactUs' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );

			IF(@IsReply=1 AND ISNULL(@ReplyText,'')!='')
			BEGIN
				EXEC nan.CreateEmail @TemplateTitle = N'Contact Us', -- nvarchar(100)
				    @FamilyIdList = N'', -- nvarchar(max)
				    @RecordId = @Id, -- bigint
				    @PageId = @PageId, -- int
				    @UserId = @UserId, -- int
				    @AgencyId = 0 -- int
				
			END
            END;
        SELECT  ISNULL(@Id, 0) AS InsertedId;
    END;