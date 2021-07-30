-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetSubscriptionMasterById>
-- Call SP    :	GetSubscriptionMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetSubscriptionMasterById]
    @SubscriptionMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [SM].[SubscriptionMasterId] AS SubscriptionMasterId ,
                [SM].[SubscriptionMasterName] AS SubscriptionMasterName ,
                [SM].[SubscriptionPeriod] AS SubscriptionPeriod ,
                [SM].[Price] AS Price,
				ISNULL([SM].[IsActive],0) AS IsActive
        FROM    nan.[SubscriptionMaster] AS SM
        WHERE   [SM].[SubscriptionMasterId] = @SubscriptionMasterId;
    END;