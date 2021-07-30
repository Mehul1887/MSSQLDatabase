-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateCountryMaster>
-- Call SP    :	nan.InsertOrUpdateCountryMaster 0,'India',1,1
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateCountryMaster]
    @CountryMasterId BIGINT ,
    @CountryMasterName NVARCHAR(100) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	DECLARE @InsertedId BIGINT;
        IF  EXISTS ( SELECT  CountryMasterId
                        FROM    nan.CountryMaster
                        WHERE   CountryMasterName = @CountryMasterName
								AND CountryMasterId!=@CountryMasterId
                                AND IsDeleted = 0 )
            BEGIN
				SET @InsertedId = -1
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
        
        ELSE
            BEGIN
                IF ( @CountryMasterId = 0 )
                    BEGIN           
                   
                        INSERT  INTO nan.[CountryMaster]
                                ( [CountryMasterName] ,
                                  [CreatedOn] ,
                                  [CreatedBy] ,
                                  [IsDeleted]
                                )
                        VALUES  ( @CountryMasterName ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                        SELECT  @CountryMasterId = SCOPE_IDENTITY();
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
                                  'Insert record in table CountryMaster' ,
                                  'CountryMaster' ,
                                  @CountryMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                   
                    END;
                ELSE
                    BEGIN                
                        UPDATE  nan.[CountryMaster]
                        SET     [CountryMasterName] = @CountryMasterName ,
                                [UpdatedOn] = GETUTCDATE() ,
                                [UpdatedBy] = @UserId
                        WHERE   [CountryMasterId] = @CountryMasterId;
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
                                  'Update record in table CountryMaster' ,
                                  'CountryMaster' ,
                                  @CountryMasterId ,
                                  GETUTCDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
					SET @InsertedId = @CountryMasterId
                SELECT  ISNULL(@InsertedId, 0) AS InsertedId;		
            END;
    END;