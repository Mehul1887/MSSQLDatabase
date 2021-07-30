-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateLanguageMaster>
-- Call SP    :	InsertOrUpdateLanguageMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateLanguageMaster]
    @LanguageMasterId BIGINT ,
    @LanguageMasterName NVARCHAR(30) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @InsertedId BIGINT;
        IF EXISTS ( SELECT  LanguageMasterId
                    FROM    nan.LanguageMaster
                    WHERE   LanguageMasterName = @LanguageMasterName
                            AND LanguageMasterId != @LanguageMasterId
                            AND IsDeleted = 0 )
            BEGIN
                SET @InsertedId = -1;
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
        
        ELSE
            BEGIN
                IF ( @LanguageMasterId = 0 )
                    BEGIN
                        INSERT  INTO nan.[LanguageMaster]
                                ( [LanguageMasterName] ,
                                  [CreatedOn] ,
                                  [CreatedBy] ,
                                  [IsDeleted]
                                )
                        VALUES  ( @LanguageMasterName ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                        SELECT  @LanguageMasterId = SCOPE_IDENTITY();
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
                                  'Insert record in table LanguageMaster' ,
                                  'LanguageMaster' ,
                                  @LanguageMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
                ELSE
                    BEGIN
                        UPDATE  LM
                        SET     [LanguageMasterName] = @LanguageMasterName ,
                                [UpdatedOn] = GETUTCDATE() ,
                                [UpdatedBy] = @UserId
                        FROM    nan.[LanguageMaster] AS LM
                        WHERE   [LanguageMasterId] = @LanguageMasterId;
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
                                  'Update record in table LanguageMaster' ,
                                  'LanguageMaster' ,
                                  @LanguageMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
                SET @InsertedId = @LanguageMasterId;
                SELECT  ISNULL(@InsertedId, 0) AS InsertedId;
            END;
    END;