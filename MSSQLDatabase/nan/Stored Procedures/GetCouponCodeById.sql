-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCouponCodeById>
-- Call SP    :	GetCouponCodeById
-- =============================================
CREATE PROCEDURE [nan].[GetCouponCodeById] @CouponCodeId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [CC].[CouponCodeId] AS CouponCodeId ,
                [CC].[CouponCodeName] AS CouponCodeName ,
                [CC].[CouponCode] AS CouponCode ,
                [CC].[Discount] AS Discount ,			
               ISNULL(nan.ChangeDateFormat([CC].[StartDate], 'dd/MM/yyyy'),'') AS StartDate ,
                ISNULL(nan.ChangeDateFormat([CC].[EndDate], 'dd/MM/yyyy'),'') AS EndDate ,
                [CC].[Description] AS Description ,
                [CC].[TermsCondition] AS TermsCondition,
				ISNULL([CC].IsForAdvert,0) AS IsForAdvert,
				ISNULL(CC.IsActive,0) AS IsActive
        FROM    nan.[CouponCode] AS CC
        WHERE   [CC].[CouponCodeId] = @CouponCodeId;
    END;