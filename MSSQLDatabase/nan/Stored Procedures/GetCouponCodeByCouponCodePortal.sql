-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <17 Aug 2017>
-- Description:	<nan.GetCouponCodeByCouponCode>
-- Call SP    :	nan.GetCouponCodeByCouponCodePortal 'tt'
-- =============================================
CREATE PROCEDURE [nan].[GetCouponCodeByCouponCodePortal]
@CouponCode NVARCHAR(50)
AS
    BEGIN
	SET NOCOUNT ON;
IF EXISTS ( SELECT  CC.CouponCodeId
            FROM    nan.[CouponCode] AS CC
            WHERE   ISNULL([CC].IsDeleted, 0) = 0
                    AND CC.CouponCode = @CouponCode
                    AND ISNULL(CC.IsActive, 0) = 1 )
    BEGIN
        IF EXISTS ( SELECT  CC.CouponCodeId
                    FROM    nan.[CouponCode] AS CC
                    WHERE   ISNULL([CC].IsDeleted, 0) = 0
                            AND CC.CouponCode = @CouponCode
                            AND ISNULL(CC.IsActive, 0) = 1
                            AND CAST(CC.StartDate AS DATE) <= CAST(GETUTCDATE() AS DATE)
                            AND CAST(CC.EndDate AS DATE) >= CAST(GETUTCDATE() AS DATE) )
            BEGIN
                SELECT  [CC].[CouponCodeId] AS CouponCodeId ,
                        [CC].[CouponCodeName] AS CouponCodeName ,
                        [CC].[CouponCode] AS CouponCode ,
                        [CC].[Discount] AS Discount 
                FROM    nan.[CouponCode] AS CC
                WHERE   ISNULL([CC].IsDeleted, 0) = 0
                        AND CC.CouponCode = @CouponCode
                        AND ISNULL(CC.IsActive, 0) = 1
                        AND CAST(CC.StartDate AS DATE) <= CAST(GETUTCDATE() AS DATE)
                        AND CAST(CC.EndDate AS DATE) >= CAST(GETUTCDATE() AS DATE);	
            END;
        ELSE
            BEGIN
                SELECT  CAST(-1 AS BIGINT) AS CouponCodeId ,
                        '' AS CouponCodeName ,
                        '' AS CouponCode ,
                        CAST(0 AS DECIMAL) AS Discount          
            END;

    END;
ELSE
    BEGIN
        SELECT  CAST(0 AS BIGINT) AS CouponCodeId ,
                        '' AS CouponCodeName ,
                        '' AS CouponCode ,
                        CAST(0 AS DECIMAL) AS Discount         
    END;

    END;