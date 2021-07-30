-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 28 Aug 2017>
-- Description:	<nan.InsertOrUpdateBlogMaster>
-- Call SP    :	InsertOrUpdateBlogMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateBlogMaster]
    @Id BIGINT ,
    @BlogTitle NVARCHAR(100) ,
    @BlogImagePath NVARCHAR(200) ,
	@BlogDescription NVARCHAR(max),
	@UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @Id = 0 )
            BEGIN
                INSERT  INTO [nan].[BlogMaster]
                        ( [BlogTitle] ,
                          [BlogImagePath] ,
                          [BlogDescription],
						  CreatedBy,
						  CreatedOn,
						  IsDeleted 
                        )
                VALUES  ( @BlogTitle ,
                          @BlogImagePath ,
                          @BlogDescription ,
						  @UserId,GETUTCDATE(),
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
                          'Insert record in table BlogMaster' ,
                          'BlogMaster' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  BLOG
                SET     [BlogTitle] = @BlogTitle ,
                        [BlogImagePath] = @BlogImagePath ,
                        [BlogDescription] = @BlogDescription ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM [nan].[BlogMaster] AS BLOG
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
                          'Update record in table BlogMaster' ,
                          'BlogMaster' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@Id, 0) AS InsertedId;
    END;