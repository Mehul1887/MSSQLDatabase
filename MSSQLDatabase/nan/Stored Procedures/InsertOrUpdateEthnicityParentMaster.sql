-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateEthnicityParentMaster>
-- Call SP    :	InsertOrUpdateEthnicityParentMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateEthnicityParentMaster]
    @EthnicityParentMasterId BIGINT ,
    @EthnicityParentMasterName NVARCHAR(30) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @InsertedId BIGINT;
        IF EXISTS ( SELECT  EthnicityParentMasterId
                    FROM    nan.EthnicityParentMaster
                    WHERE   EthnicityParentMasterName = @EthnicityParentMasterName
                            AND EthnicityParentMasterId != @EthnicityParentMasterId
                            AND IsDeleted = 0 )
            BEGIN
                SET @InsertedId = -1;
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
        
        ELSE
            BEGIN
                IF ( @EthnicityParentMasterId = 0 )
                    BEGIN
                        INSERT  INTO nan.[EthnicityParentMaster]
                                ( [EthnicityParentMasterName] ,
                                  [CreatedOn] ,
                                  [CreatedBy] ,
                                  [IsDeleted]
                                )
                        VALUES  ( @EthnicityParentMasterName ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                        SELECT  @EthnicityParentMasterId = SCOPE_IDENTITY();
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
                                  'Insert record in table EthnicityParentMaster' ,
                                  'EthnicityParentMaster' ,
                                  @EthnicityParentMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
                ELSE
                    BEGIN
                        UPDATE  EPM
                        SET     [EthnicityParentMasterName] = @EthnicityParentMasterName ,
                                [UpdatedOn] = GETUTCDATE() ,
                                [UpdatedBy] = @UserId
                        FROM    nan.[EthnicityParentMaster] AS EPM
                        WHERE   [EthnicityParentMasterId] = @EthnicityParentMasterId;
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
                                  'Update record in table EthnicityParentMaster' ,
                                  'EthnicityParentMaster' ,
                                  @EthnicityParentMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
                SET @InsertedId = @EthnicityParentMasterId;
                SELECT  ISNULL(@InsertedId, 0) AS InsertedId;
            END;
    END;