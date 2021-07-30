-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <30 Aug 2017>
-- Description:	<nan.GetActiveSubscriptionAll>
-- Call SP    :	nan.GetActiveSubscriptionAll
-- =============================================
CREATE PROCEDURE [nan].[GetActiveSubscriptionAllPortal]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [SM].[SubscriptionMasterId] AS SubscriptionMasterId ,
                [SM].[SubscriptionMasterName] AS SubscriptionMasterName ,
                [SM].[SubscriptionPeriod] AS SubscriptionPeriod ,
                [SM].[Price] AS Price
        FROM    nan.[SubscriptionMaster] AS SM
        WHERE   [SM].IsDeleted = 0 AND ISNULL(SM.IsActive,0)=1					
    END;