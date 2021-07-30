-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateUploadDocuments>
-- Call SP    :	InsertOrUpdateUploadDocuments
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateUploadDocuments]
    @UploadDocumentsId BIGINT ,
    @FamilyDetailsId BIGINT ,
    @DocumentPath NVARCHAR(250) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        IF ( @UploadDocumentsId = 0 )
            BEGIN
			
                INSERT  INTO nan.[UploadDocuments]
                        ( [UploadDocumentsName] ,
                          FamilyDetailsId ,                          
                          [DocumentPath] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( NULL,
							@FamilyDetailsId,                          
                          @DocumentPath ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @UploadDocumentsId = SCOPE_IDENTITY();
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
                          'Insert record in table UploadDocuments' ,
                          'UploadDocuments' ,
                          @UploadDocumentsId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  UploadDocuments
                SET     
                        UploadDocuments.FamilyDetailsId= @FamilyDetailsId ,                        
                        [DocumentPath] = @DocumentPath ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[UploadDocuments] AS UploadDocuments
                WHERE   [UploadDocumentsId] = @UploadDocumentsId;
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
                          'Update record in table UploadDocuments' ,
                          'UploadDocuments' ,
                          @UploadDocumentsId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@UploadDocumentsId, 0) AS InsertedId;
    END;