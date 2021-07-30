-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyDetailsById>
-- Call SP    :	nan.GetFamilyDetailsById 45
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyDetailsById]
    @FamilyDetailsId BIGINT
AS
    BEGIN
	DECLARE @APIUrl NVARCHAR(100)='';
		SELECT @APIUrl = (SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='APIUrl')
        SELECT  [FD].[FamilyDetailsId] AS FamilyDetailsId ,
                [FD].[FamilyDetailsName] AS FamilyDetailsName ,
                [FD].[HaveNanny] AS HaveNanny ,
				CASE WHEN ISNULL(FD.HaveNanny,-1)=-1 THEN '' 
								WHEN 	ISNULL(FD.HaveNanny,-1)=0 THEN 'No'
								WHEN 	ISNULL(FD.HaveNanny,-1)=1 THEN 'Yes'
								WHEN 	ISNULL(FD.HaveNanny,-1)=2 THEN 'Flexible' END AS IsNanny,
                [FD].[EthnicityChildMasterId] AS EthnicityChildMasterId ,
				[ECM].[EthnicityChildMasterName] AS EthnicityChildMasterName ,
                [FD].[LanguageMasterId] AS LanguageMasterId ,
				STUFF(( SELECT  ', ' + LM.LanguageMasterName
                        FROM nan.LanguageMaster AS LM
							WHERE LM.LanguageMasterId IN (SELECT Data FROM nan.Split(FD.LanguageMasterId,',')) 
                      FOR
                        XML PATH('')
                      ), 1, 1, '') AS  LanguageMasterName,				
                [FD].[Email] AS Email ,
                [FD].[PhoneNumber] AS PhoneNumber ,			
                [FD].[Mobile] AS Mobile ,
                [FD].[Password] AS Password ,
                [FD].[ContactTime] AS ContactTime ,
                [FD].[PhoneNumberVisible] AS PhoneNumberVisible ,
                [FD].[Address1] AS Address1 ,
                [FD].[Address2] AS Address2 ,
                [FD].[GoogleLat] AS GoogleLat ,
                [FD].[GoogleLong] AS GoogleLong ,
				FD.CityName AS CityName,
				FD.CountyName AS CountyName,
				ISNULL([CM].[CountryMasterId],0) AS CountryMasterId ,
                ISNULL([CM].[CountryMasterName],'') AS CountryMasterName ,
                [FD].[PostCode] AS PostCode ,
                [FD].[IsDeleteProfile] AS IsDeleteProfile ,
                [FD].[DeleteProfileDateTime] AS DeleteProfileDateTime ,
                [FD].[IsActiveProfilebyAdmin] AS IsActiveProfilebyAdmin ,
                [FD].[IsActiveProfile] AS IsActiveProfile ,
                [FD].[ActiveProfileDateTime] AS ActiveProfileDateTime ,
                [FD].[CheckedTerms] AS CheckedTerms ,
                [FD].[IsSubscribeNewsletter] AS IsSubscribeNewsletter ,
                [FD].[LastLoginTime] AS LastLoginTime,
				ISNULL(FD.NoOfChildren,0) AS NoOfChildren,
				ISNULL(FD.ChildrenAge1,'0') AS ChildrenAge1,
				FD.ChildrenGender1 AS ChildrenGender1,
			--	ISNULL(FD.ChildrenAge2,0) AS ChildrenAge2,
				--FD.ChildrenGender2 AS ChildrenGender2,
				FD.HaveSmoker AS HaveSmoker,
				FD.HavePet AS HavePet,
				FD.PetDetails AS PetDetails,
				FD.Description AS Description,
				FD.NannyRequired AS NannyRequired,
				nan.ChangeDateFormat(FD.NannyAvailableDate,'dd/mm/yyyy') AS StrNannyAvailableDate,			
				ISNULL(FD.ProfileViews,0) AS ProfileViews,
				CASE WHEN ISNULL(FD.ProfileImage,'')='' THEN 'app/images/avtar1Large.png' 
				WHEN ISNULL(FD.ProfileImage,'')='female.png' THEN 'app/images/femaleLarge.png'
				WHEN ISNULL(FD.ProfileImage,'')='male.png' THEN 'app/images/maleLarge.png'
				ELSE @APIUrl+'Uploads/'+FD.ProfileImage END AS ProfileImageUrl,
				CASE WHEN ISNULL(FD.ProfileImage,'')=''  THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT)  END AS HasImage,
				ISNULL(FD.ProfileImage,'') AS ProfileImage,				
				 CASE WHEN ISNULL(FD.ChildrenAge1,'-1')='-1' AND FD.ChildrenGender1 IS NULL THEN
							CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS IsChildren1,							
							FD.IsActiveProfile AS IsActiveProfile ,
							ISNULL(FD.FirstName,'') AS FirstName,
							ISNULL(FD.LastName,'') AS LastName	
        FROM    nan.[FamilyDetails] AS FD
		LEFT JOIN nan.EthnicityChildMaster AS ECM ON ECM.EthnicityChildMasterId=FD.EthnicityChildMasterId		
		left JOIN nan.CountryMaster AS CM ON CM.CountryMasterId=FD.CountryMasterId
        WHERE   [FD].[FamilyDetailsId] = @FamilyDetailsId
    END;