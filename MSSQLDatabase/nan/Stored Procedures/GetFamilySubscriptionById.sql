-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilySubscriptionById>
-- Call SP    :	GetFamilySubscriptionById
-- =============================================
CREATE PROCEDURE [nan].[GetFamilySubscriptionById]
    @FamilySubscriptionId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FS].[FamilySubscriptionId] AS FamilySubscriptionId ,
                [FS].[FamilySubscriptionName] AS FamilySubscriptionName ,
                [FS].[FamilyDetailsId] AS FamilyDetailsId ,
                [FS].[SubscriptionMasterId] AS SubscriptionMasterId
        FROM    nan.[FamilySubscription] AS FS
        WHERE   [FS].[FamilySubscriptionId] = @FamilySubscriptionId;
    END;