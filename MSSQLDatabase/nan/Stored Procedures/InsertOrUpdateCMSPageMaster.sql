-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateCMSPageMaster>
-- Call SP    :	InsertOrUpdateCMSPageMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateCMSPageMaster]
    @CMSPageMasterId BIGINT ,
    @CMSPageMasterName NVARCHAR(50) ,
    @PageContent NVARCHAR(MAX) ,
    @PageMasterId BIGINT ,
    @Title NVARCHAR(50) ,
    @Keywords NVARCHAR(100) ,
    @Description NVARCHAR(200) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @CMSPageMasterId = 0 )
            BEGIN
                INSERT  INTO nan.[CMSPageMaster]
                        ( [CMSPageMasterName] ,
                          [PageContent] ,
                          [PageMasterId] ,
                          [Title] ,
                          [Keywords] ,
                          [Description] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @CMSPageMasterName ,
                          @PageContent ,
                          @PageMasterId ,
                          @Title ,
                          @Keywords ,
                          @Description ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @CMSPageMasterId = SCOPE_IDENTITY();
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
                          'Insert record in table CMSPageMaster' ,
                          'CMSPageMaster' ,
                          @CMSPageMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  CMS
                SET     [CMSPageMasterName] = @CMSPageMasterName ,
                        [PageContent] = @PageContent ,
                        [PageMasterId] = @PageMasterId ,
                        [Title] = @Title ,
                        [Keywords] = @Keywords ,
                        [Description] = @Description ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[CMSPageMaster] AS CMS
                WHERE   [CMSPageMasterId] = @CMSPageMasterId;
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
                          'Update record in table CMSPageMaster' ,
                          'CMSPageMaster' ,
                          @CMSPageMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@CMSPageMasterId, 0) AS InsertedId;
    END;