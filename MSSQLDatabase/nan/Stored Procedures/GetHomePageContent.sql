-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<nan.GetHomePageContent>
-- Call SP    :	nan.GetHomePageContent
-- =============================================
CREATE PROCEDURE [nan].[GetHomePageContent]
AS
    BEGIN
        SET NOCOUNT ON; 
        DECLARE @CouponCodeId BIGINT= 0 ,
            @CouponCodeName NVARCHAR(100) ,
            @CouponCode NVARCHAR(50) ,
            @Discount DECIMAL;

        SELECT TOP 1  @CouponCodeId = ISNULL(CC.CouponCodeId,0) ,
                @CouponCodeName = CC.CouponCodeName ,
				  @CouponCodeName = CC.CouponCodeName ,
                @CouponCode = CC.CouponCode ,
                @Discount = CC.Discount
        FROM    nan.CouponCode AS CC
        WHERE   ISNULL(CC.IsDeleted, 0) = 0
                AND ISNULL(CC.IsActive, 0) = 1
                AND CAST(GETUTCDATE() AS DATE) >= CAST(CC.StartDate AS DATE)
                AND CAST(GETUTCDATE() AS DATE) <= CAST(CC.EndDate AS DATE)
				ORDER BY CC.CouponCodeId DESC;

        SELECT  ISNULL(HPCM.HomePageContentMasterId, 0) AS HomePageContentMasterId ,
                ISNULL(HPCM.HomePageContentMasterName, '') AS HomePageContentMasterName ,
                ISNULL(HPCM.BannerTitle, '') AS BannerTitle ,
                ISNULL(HPCM.AboutNannyShare, '') AS AboutNannyShare ,
                ISNULL(HPCM.HowItWorks1, '') AS HowItWorks1 ,
                ISNULL(HPCM.HowItWorks2, '') AS HowItWorks2 ,
                ISNULL(HPCM.HowItWorks3, '') AS HowItWorks3 ,
                ISNULL(HPCM.HowItWorks4, '') AS HowItWorks4 ,
                ISNULL(HPCM.HowItWorks5, '') AS HowItWorks5 ,
                ISNULL(HPCM.BenefitTitle1, '') AS BenefitTitle1 ,
                ISNULL(HPCM.BenefitTitle2, '') AS BenefitTitle2 ,
                ISNULL(HPCM.BenefitTitle3, '') AS BenefitTitle3 ,
                ISNULL(HPCM.BenefitText1, '') AS BenefitText1 ,
                ISNULL(HPCM.BenefitText2, '') AS BenefitText2 ,
                ISNULL(HPCM.BenefitText3, '') AS BenefitText3 ,
                'USE CODE <b>' + @CouponCode + '</b> FOR '
                + CAST(@Discount AS NVARCHAR(50))
                + '% OFF SUBSCRIPTION FEES' AS CouponBanner ,
                @CouponCodeId AS CouponCodeId
        FROM    nan.HomePageContentMaster AS HPCM
        WHERE   ISNULL(HPCM.IsDeleted, 0) = 0;
    END;