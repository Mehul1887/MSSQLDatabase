-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilySubscriptionAll>
-- Call SP    :	GetFamilySubscriptionAll
-- =============================================
CREATE PROCEDURE [nan].[GetFamilySubscriptionAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FS].[FamilySubscriptionId] AS FamilySubscriptionId ,
                [FS].[FamilySubscriptionName] AS FamilySubscriptionName ,
                [FS].[FamilyDetailsId] AS FamilyDetailsId ,
                [FS].[SubscriptionMasterId] AS SubscriptionMasterId
        FROM    nan.[FamilySubscription] AS FS
        WHERE   [FS].IsDeleted = 0;
    END;