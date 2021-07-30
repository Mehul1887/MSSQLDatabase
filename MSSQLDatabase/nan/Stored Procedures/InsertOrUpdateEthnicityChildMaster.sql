-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateEthnicityChildMaster>
-- Call SP    :	InsertOrUpdateEthnicityChildMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateEthnicityChildMaster]
    @EthnicityChildMasterId BIGINT ,
    @EthnicityChildMasterName NVARCHAR(30) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
	DECLARE @InsertedId BIGINT;
        IF EXISTS ( SELECT EthnicityChildMasterId FROM nan.EthnicityChildMaster
                    WHERE   EthnicityChildMasterName = @EthnicityChildMasterName
                            AND EthnicityChildMasterId != @EthnicityChildMasterId
                            AND IsDeleted = 0 )
            BEGIN
                SET @InsertedId = -1;
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
			ELSE
			BEGIN			    			
        IF ( @EthnicityChildMasterId = 0 )
            BEGIN
                INSERT  INTO nan.[EthnicityChildMaster]
                        ( [EthnicityChildMasterName] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @EthnicityChildMasterName ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @EthnicityChildMasterId = SCOPE_IDENTITY();
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
                          'Insert record in table EthnicityChildMaster' ,
                          'EthnicityChildMaster' ,
                          @EthnicityChildMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  ECM
                SET     [EthnicityChildMasterName] = @EthnicityChildMasterName ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[EthnicityChildMaster] AS ECM
                WHERE   [EthnicityChildMasterId] = @EthnicityChildMasterId;
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
                          'Update record in table EthnicityChildMaster' ,
                          'EthnicityChildMaster' ,
                          @EthnicityChildMasterId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@EthnicityChildMasterId, 0) AS InsertedId;
		END
    END;