-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <26 Apr 2017>
-- Description:	<Get Area By Country Id>
-- Call SP    :	nan.GetFamilySubscriptionByFamilyId 43
-- =============================================
CREATE PROCEDURE [nan].[GetFamilySubscriptionByFamilyId] @FamilyId BIGINT
AS
    BEGIN
        SELECT  FS.FamilySubscriptionId ,
                FS.FamilySubscriptionName ,
                FS.SubscriptionMasterId ,
                SM.SubscriptionMasterName ,
                SM.SubscriptionPeriod ,
                SM.Price
        FROM    nan.FamilySubscription AS FS
                LEFT JOIN nan.SubscriptionMaster AS SM ON SM.SubscriptionMasterId = FS.SubscriptionMasterId
        WHERE   FS.FamilyDetailsId = @FamilyId
                AND ISNULL(FS.IsDeleted, 0) = 0
        ORDER BY FS.FamilySubscriptionName ASC;
    END;