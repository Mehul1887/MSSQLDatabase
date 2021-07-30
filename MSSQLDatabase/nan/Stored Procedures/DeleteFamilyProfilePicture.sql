-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,DeleteFamilyDetails>
-- Call SP    :	[nan].[DeleteFamilyProfilePicture]
-- =============================================
CREATE PROCEDURE [nan].[DeleteFamilyProfilePicture]
    @FamilyId BIGINT,
    @PageId BIGINT
AS
    BEGIN
	
                        UPDATE  nan.[FamilyDetails]
                        SET     ProfileImage =''
                        WHERE   FamilyDetailsId = @FamilyId

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
                        VALUES  ( @FamilyId ,
                                  @PageId ,
                                  'Remove profile picture in table FamilyDetails' ,
                                  'FamilyDetails' ,
                                  @FamilyId ,
                                  GETUTCDATE() ,
                                  @FamilyId ,
                                  0
                                );

								SELECT @FamilyId AS familId
                   
    END;