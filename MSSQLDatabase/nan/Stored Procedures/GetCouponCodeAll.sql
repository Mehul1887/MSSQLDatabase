-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCouponCodeAll>
-- Call SP    :	GetCouponCodeAll
-- =============================================
CREATE PROCEDURE [nan].[GetCouponCodeAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [CC].[CouponCodeId] AS CouponCodeId ,
                [CC].[CouponCodeName] AS CouponCodeName ,
                [CC].[CouponCode] AS CouponCode ,
                [CC].[Discount] AS Discount ,
                [CC].[StartDate] AS StartDate ,
                [CC].[EndDate] AS EndDate ,
                [CC].[Description] AS Description ,
                [CC].[TermsCondition] AS TermsCondition
        FROM    nan.[CouponCode] AS CC
        WHERE   [CC].IsDeleted = 0;
    END;