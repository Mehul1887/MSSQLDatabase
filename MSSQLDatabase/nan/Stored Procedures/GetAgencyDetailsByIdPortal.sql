-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetAgencyDetailsByIdPortal>
-- Call SP    :	nan.GetAgencyDetailsByIdPortal 4
-- =============================================
CREATE PROCEDURE [nan].[GetAgencyDetailsByIdPortal]
    @AgencyDetailsId BIGINT
AS
    BEGIN
        SELECT  [AD].[AgencyDetailsId] AS AgencyDetailsId ,
                [AD].[AgencyDetailsName] AS AgencyDetailsName ,
                [AD].[Address1] AS Address1 ,
                [AD].[Address2] AS Address2 ,
                [AD].[GoogleLat] AS GoogleLat ,
                [AD].[GoogleLong] AS GoogleLong ,
                  ISNULL([AD].[AreaId],0) AS AreaId ,
				[AM].[AreaMasterName] AS AreaMasterName ,
					ISNULL([CM].[CountryMasterId],0) AS CountryMasterId,
				[CM].[CountryMasterName] AS CountryMasterName,
                [AD].[PostCode] AS PostCode ,
                [AD].[Phone] AS Phone ,
                [AD].[Email] AS Email ,
                [AD].[Website] AS Website ,
                [AD].[ContactForm] AS ContactForm ,
                [AD].[IsProfileReviewed] AS IsProfileReviewed ,
                [AD].[IsDeleteProfile] AS IsDeleteProfile ,
                [AD].[DeleteProfileDateTime] AS DeleteProfileDateTime ,
                [AD].[IsActiveProfilebyAdmin] AS IsActiveProfilebyAdmin ,
                [AD].[IsActiveProfile] AS IsActiveProfile ,
                [AD].[ActiveProfileDateTime] AS ActiveProfileDateTime ,
                [AD].[CheckedTerms] AS CheckedTerms ,
                [AD].[IsSubscribeNewsletter] AS IsSubscribeNewsletter ,
                [AD].[LastLoginTime] AS LastLoginTime
        FROM    nan.[AgencyDetails] AS AD
		LEFT JOIN nan.AreaMaster AS AM ON AM.AreaMasterId=[AD].AreaId
		LEFT JOIN nan.CountryMaster AS CM ON AM.CountryMatserId=CM.CountryMasterId
        WHERE   [AD].[AgencyDetailsId] = @AgencyDetailsId;
    END;