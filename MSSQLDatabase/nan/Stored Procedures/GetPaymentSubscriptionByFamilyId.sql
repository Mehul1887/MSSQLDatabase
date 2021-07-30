-- =============================================
-- Author      : Sanjay Chaudhary		
-- Create date : 27-Apr-2017
-- Description :	
-- Call SP     : nan.GetPaymentSubscriptionByFamilyId
-- =============================================
CREATE PROCEDURE [nan].[GetPaymentSubscriptionByFamilyId] @familyId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  FD.FamilyDetailsId AS FamilyDetailsId ,
                FD.FamilyDetailsName AS FamilyDetailsName ,
                FD.HaveNanny AS HaveNanny ,
                FD.EthnicityChildMasterId AS EthnicityChildMasterId ,
                ECM.EthnicityChildMasterName AS EthnicityChildMasterName ,
                FD.LanguageMasterId AS LanguageMasterId ,
                FD.Email AS Email ,
                FD.PhoneNumber AS PhoneNumber ,
                FD.Mobile AS Mobile ,
                FD.ContactTime AS ContactTime ,
                FD.PhoneNumberVisible AS PhoneNumberVisible ,
                FD.Address1 AS Address1 ,
                FD.Address2 AS Address2 ,
                CM.CountryMasterId AS CountryMasterId ,
                CM.CountryMasterName AS CountryMasterName ,
                FD.PostCode AS PostCode ,
                FD.IsActiveProfilebyAdmin AS IsActiveProfilebyAdmin ,
                FD.IsActiveProfile AS IsActiveProfile ,
                FD.ActiveProfileDateTime AS IsActiveProfile ,
                FD.CheckedTerms AS CheckedTerms ,
                FD.IsSubscribeNewsletter AS IsSubscribeNewsletter ,
                FD.LastLoginTime AS LastLoginTime ,
                FS.FamilySubscriptionId AS FamilySubscriptionId ,
                FS.FamilySubscriptionName AS FamilySubscriptionName ,
                SM.SubscriptionMasterId AS SubscriptionMasterId ,
                SM.SubscriptionMasterName AS SubscriptionMasterName ,
                SM.SubscriptionPeriod AS SubscriptionPeriod ,
                SM.Price AS SubscriptionPrice ,
                FPH.FamilyPaymentHistoryId AS FamilyPaymentHistoryId ,
                CAST(DATEADD(DAY, SM.SubscriptionPeriod, FPH.CreatedOn) AS DATE) AS SubscriptionEndDate
        FROM    nan.FamilyDetails AS FD
                
                INNER JOIN nan.CountryMaster AS CM ON CM.CountryMasterId = FD.CountryMasterId
                                                      AND ISNULL(CM.IsDeleted,
                                                              0) = 0
                INNER JOIN nan.EthnicityChildMaster AS ECM ON ECM.EthnicityChildMasterId = FD.EthnicityChildMasterId
                                                              AND ISNULL(ECM.IsDeleted,
                                                              0) = 0                  
                LEFT JOIN nan.FamilyPaymentHistory AS FPH ON FPH.FamilyDetailsId = FD.FamilyDetailsId
                                                             AND ISNULL(FPH.IsDeleted,
                                                              0) = 0
                LEFT JOIN nan.FamilySubscription AS FS ON FS.FamilySubscriptionId = FPH.FamilySubscriptionId
                                                          AND ISNULL(FS.IsDeleted,
                                                              0) = 0
                LEFT JOIN nan.SubscriptionMaster AS SM ON SM.SubscriptionMasterId = FS.SubscriptionMasterId
                                                          AND ISNULL(SM.IsDeleted,
                                                              0) = 0
        WHERE   FD.FamilyDetailsId = @familyId
              --AND CAST(DATEADD(DAY, SM.SubscriptionPeriod, FPH.CreatedOn) AS DATE) > CAST(GETUTCDATE() AS DATE);

    END;