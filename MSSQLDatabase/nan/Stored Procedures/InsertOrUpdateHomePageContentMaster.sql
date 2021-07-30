-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<InsertOrUpdateHomePageContentMaster>
-- Call SP    :	InsertOrUpdateHomePageContentMaster
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateHomePageContentMaster]
    @HomePageContentMasterId BIGINT ,
    @HomePageContentMasterName NVARCHAR(100) ,
    @BannerTitle NVARCHAR(500) ,
    @AboutNannyShare NVARCHAR(500) ,
    @HowItWorks1 NVARCHAR(100) ,
    @HowItWorks2 NVARCHAR(100) ,
    @HowItWorks3 NVARCHAR(100) ,
    @HowItWorks4 NVARCHAR(100) ,
    @HowItWorks5 NVARCHAR(100) ,
    @BenefitTitle1 NVARCHAR(100) ,
    @BenefitTitle2 NVARCHAR(100) ,
    @BenefitTitle3 NVARCHAR(100) ,
    @BenefitText1 NVARCHAR(250) ,
    @BenefitText2 NVARCHAR(250) ,
    @BenefitText3 NVARCHAR(250) ,
    @userId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @InsertedId BIGINT;      
        IF ( @HomePageContentMasterId = 0 )
            BEGIN
                INSERT  INTO nan.HomePageContentMaster
                        ( HomePageContentMasterName ,
                          BannerTitle ,
                          AboutNannyShare ,
                          HowItWorks1 ,
                          HowItWorks2 ,
                          HowItWorks3 ,
                          HowItWorks4 ,
                          HowItWorks5 ,
                          BenefitTitle1 ,
                          BenefitTitle2 ,
                          BenefitTitle3 ,
                          BenefitText1 ,
                          BenefitText2 ,
                          BenefitText3 ,
                          CreatedOn ,
                          CreatedBy ,                         
                          IsDeleted
                        )
                VALUES  ( @HomePageContentMasterName , -- HomePageContentMasterName - nvarchar(100)
                          @BannerTitle , -- BannerTitle - nvarchar(500)
                          @AboutNannyShare , -- AboutNannyShare - nvarchar(500)
                          @HowItWorks1 , -- HowItWorks1 - nvarchar(100)
                          @HowItWorks2 , -- HowItWorks2 - nvarchar(100)
                          @HowItWorks3 , -- HowItWorks3 - nvarchar(100)
                          @HowItWorks4 , -- HowItWorks4 - nvarchar(100)
                          @HowItWorks5 , -- HowItWorks5 - nvarchar(100)
                          @BenefitTitle1 , -- BenefitTitle1 - nvarchar(100)
                          @BenefitTitle2 , -- BenefitTitle2 - nvarchar(100)
                          @BenefitTitle3 , -- BenefitTitle3 - nvarchar(100)
                          @BenefitText1 , -- BenefitText1 - nvarchar(250)
                          @BenefitText2 , -- BenefitText2 - nvarchar(250)
                          @BenefitText3 , -- BenefitText3 - nvarchar(250)
                          GETUTCDATE() , -- CreatedOn - datetime
                          @userId , -- CreatedBy - bigint                                  
                          0  -- IsDeleted - bit
                        );
                SELECT  @HomePageContentMasterId = SCOPE_IDENTITY();
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
                VALUES  ( @userId ,
                          @PageId ,
                          'Insert record in table HomePageContentMaster' ,
                          'HomePageContentMaster' ,
                          @HomePageContentMasterId ,
                          GETUTCDATE() ,
                          @userId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  HPCM
                SET     HPCM.HomePageContentMasterName = @HomePageContentMasterName ,
                        HPCM.BannerTitle = @BannerTitle ,
                        HPCM.AboutNannyShare = @AboutNannyShare ,
                        HPCM.HowItWorks1 = @HowItWorks1 ,
                        HPCM.HowItWorks2 = @HowItWorks2 ,
                        HPCM.HowItWorks3 = @HowItWorks3 ,
                        HPCM.HowItWorks4 = @HowItWorks4 ,
                        HPCM.HowItWorks5 = @HowItWorks5 ,
                        HPCM.BenefitTitle1 = @BenefitTitle1 ,
                        HPCM.BenefitTitle2 = @BenefitTitle2 ,
                        HPCM.BenefitTitle3 = @BenefitTitle3 ,
                        HPCM.BenefitText1 = @BenefitText1 ,
                        HPCM.BenefitText2 = @BenefitText2 ,
                        HPCM.BenefitText3 = @BenefitText3,
						HPCM.UpdatedOn=GETUTCDATE(),
						HPCM.UpdatedBy=@userId
                FROM    nan.HomePageContentMaster AS HPCM
                WHERE   HPCM.HomePageContentMasterId = @HomePageContentMasterId;
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
                VALUES  ( @userId ,
                          @PageId ,
                          'Update record in table HomePageContentMaster' ,
                          'HomePageContentMaster' ,
                          @HomePageContentMasterId ,
                          GETUTCDATE() ,
                          @userId ,
                          0
                        );
                SET @InsertedId = @HomePageContentMasterId;
            END;		
               
        SELECT  ISNULL(@InsertedId, 0) AS InsertedId;
    END;