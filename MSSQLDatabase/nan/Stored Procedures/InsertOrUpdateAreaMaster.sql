-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateAreaMaster>
-- Call SP    :	InsertOrUpdateAreaMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateAreaMaster]
    @AreaMasterId BIGINT ,
    @AreaMasterName NVARCHAR(50) ,
    @CountryMatserId BIGINT ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @InsertedId BIGINT;
        IF EXISTS ( SELECT  AreaMasterId
                    FROM    nan.AreaMaster
                    WHERE   AreaMasterName = @AreaMasterName
                            AND AreaMasterId != @AreaMasterId
                            AND IsDeleted = 0 )
            BEGIN
                SET @InsertedId = -1;
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
        
        ELSE
            BEGIN
                IF ( @AreaMasterId = 0 )
                    BEGIN
                        INSERT  INTO nan.[AreaMaster]
                                ( [AreaMasterName] ,
                                  [CountryMatserId] ,
                                  [CreatedOn] ,
                                  [CreatedBy] ,
                                  [IsDeleted]
                                )
                        VALUES  ( @AreaMasterName ,
                                  @CountryMatserId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                        SELECT  @AreaMasterId = SCOPE_IDENTITY();
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
                                  'Insert record in table AreaMaster' ,
                                  'AreaMaster' ,
                                  @AreaMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
                ELSE
                    BEGIN
                        UPDATE  AM
                        SET     [AreaMasterName] = @AreaMasterName ,
                                [CountryMatserId] = @CountryMatserId ,
                                [UpdatedOn] = GETUTCDATE() ,
                                [UpdatedBy] = @UserId
                        FROM    nan.[AreaMaster] AS AM
                        WHERE   [AreaMasterId] = @AreaMasterId;
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
                                  'Update record in table AreaMaster' ,
                                  'AreaMaster' ,
                                  @AreaMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
			
                SET @InsertedId = @AreaMasterId;
                SELECT  ISNULL(@InsertedId, 0) AS InsertedId;
            END;
    END;