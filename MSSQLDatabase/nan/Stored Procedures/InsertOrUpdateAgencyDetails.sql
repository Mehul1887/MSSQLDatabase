-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateAgencyDetails>
-- Call SP    :	InsertOrUpdateAgencyDetails
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateAgencyDetails]
    @AgencyDetailsId BIGINT ,
    @AgencyDetailsName NVARCHAR(60) ,
    @Address1 NVARCHAR(250) ,
    @Address2 NVARCHAR(250) ,
    @GoogleLat NVARCHAR(20) ,
    @GoogleLong NVARCHAR(20) ,
    @AreaId BIGINT ,
  
    @PostCode NVARCHAR(20) ,
    @Phone NVARCHAR(20) ,
    @Email NVARCHAR(100) ,
    @Website NVARCHAR(100) ,
    @ContactForm NVARCHAR(100) ,
    @IsProfileReviewed BIT ,
    @IsDeleteProfile BIT ,
    @IsActiveProfilebyAdmin BIT ,
    @IsActiveProfile BIT ,
    @CheckedTerms BIT ,
    @IsSubscribeNewsletter BIT ,
 
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @AgencyDetailsId = 0 )
            BEGIN
                INSERT  INTO nan.[AgencyDetails]
                        ( [AgencyDetailsName] ,
                          [Address1] ,
                          [Address2] ,
                          [GoogleLat] ,
                          [GoogleLong] ,
                          [AreaId] ,
                     
                          [PostCode] ,
                          [Phone] ,
                          [Email] ,
                          [Website] ,
                          [ContactForm] ,
                          [IsProfileReviewed] ,
                          [IsDeleteProfile] ,
                      
                          [IsActiveProfilebyAdmin] ,
                          [IsActiveProfile] ,
             
                          [CheckedTerms] ,
                          [IsSubscribeNewsletter] ,
                      
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @AgencyDetailsName ,
                          @Address1 ,
                          @Address2 ,
                          @GoogleLat ,
                          @GoogleLong ,
                          @AreaId ,
                       
                          @PostCode ,
                          @Phone ,
                          @Email ,
                          @Website ,
                          @ContactForm ,
                          @IsProfileReviewed ,
                          @IsDeleteProfile ,
                          @IsActiveProfilebyAdmin ,
                          @IsActiveProfile ,
                 
                          @CheckedTerms ,
                          @IsSubscribeNewsletter ,
                  
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @AgencyDetailsId = SCOPE_IDENTITY();
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
                          'Insert record in table AgencyDetails' ,
                          'AgencyDetails' ,
                          @AgencyDetailsId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  AD
                SET     [AgencyDetailsName] = @AgencyDetailsName ,
                        [Address1] = @Address1 ,
                        [Address2] = @Address2 ,
                        [GoogleLat] = @GoogleLat ,
                        [GoogleLong] = @GoogleLong ,
                        [AreaId] = @AreaId ,
                     
                        [PostCode] = @PostCode ,
                        [Phone] = @Phone ,
                        [Email] = @Email ,
                        [Website] = @Website ,
                        [ContactForm] = @ContactForm ,
                        [IsProfileReviewed] = @IsProfileReviewed ,
                        [IsDeleteProfile] = @IsDeleteProfile ,
   
                        [IsActiveProfilebyAdmin] = @IsActiveProfilebyAdmin ,
                        [IsActiveProfile] = @IsActiveProfile ,
                    
                        [CheckedTerms] = @CheckedTerms ,
                        [IsSubscribeNewsletter] = @IsSubscribeNewsletter ,
                     
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[AgencyDetails] AS AD
                WHERE   [AgencyDetailsId] = @AgencyDetailsId;
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
                          'Update record in table AgencyDetails' ,
                          'AgencyDetails' ,
                          @AgencyDetailsId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@AgencyDetailsId, 0) AS InsertedId;
    END;