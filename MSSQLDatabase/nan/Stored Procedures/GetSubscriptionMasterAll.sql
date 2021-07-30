-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetSubscriptionMasterAll>
-- Call SP    :	GetSubscriptionMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetSubscriptionMasterAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [SM].[SubscriptionMasterId] AS SubscriptionMasterId ,
                [SM].[SubscriptionMasterName] AS SubscriptionMasterName ,
                [SM].[SubscriptionPeriod] AS SubscriptionPeriod ,
                [SM].[Price] AS Price
        FROM    nan.[SubscriptionMaster] AS SM
        WHERE   [SM].IsDeleted = 0;
    END;