-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyDetailsById>
-- Call SP    :	nan.GetFamilyDetailsByIdPortal 101,0,0
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyDetailsByIdPortal]
    @FamilyDetailsId BIGINT,
	@IsView BIT,
	@ParentFamilyDetailsId BIGINT
AS
    BEGIN

		DECLARE @IsFavourite BIT=0,@APIUrl NVARCHAR(250),@IsFree BIT,@IsSubscribed BIGINT
		IF ISNULL(@FamilyDetailsId,0)>0 AND @IsView=0
		BEGIN			
				IF EXISTS ( SELECT  FS.FamilySubscriptionId
                    FROM    nan.FamilySubscription AS FS
                    WHERE   FS.FamilyDetailsId = @FamilyDetailsId
                            AND CAST(GETUTCDATE() AS DATE) >= CAST(FS.StartDate AS DATE)
                            AND CAST(GETUTCDATE() AS DATE) <= CAST(FS.EndDate AS DATE)
                            AND ISNULL(FS.IsDeleted, 0) = 0 )
            BEGIN
                SET @IsSubscribed = 1;
            END;
        ELSE
            BEGIN
				SELECT @IsFree= CAST(ACS.KeyValue AS BIT) FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='IsFree'
				IF @IsFree=1
				BEGIN
				    SET @IsSubscribed = 1;
				END
				ELSE
				BEGIN
                SET @IsSubscribed = 0;
				END
            END
			IF @IsSubscribed=0
			BEGIN
					UPDATE nan.FamilyDetails SET IsActiveProfile=0 WHERE FamilyDetailsId=@FamilyDetailsId    
			END
		END
		PRINT @IsSubscribed
		SELECT @APIUrl = (SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='APIUrl')

			IF (ISNULL(@ParentFamilyDetailsId,0)>0 AND ISNULL(@ParentFamilyDetailsId,0) <> @FamilyDetailsId)
			BEGIN
			    IF EXISTS(SELECT FF.FamilyFavoritesId FROM nan.FamilyFavorites AS FF WHERE ISNULL(FF.IsDeleted,0)=0 AND FF.TargetFamilyDetailsId=@FamilyDetailsId AND FF.FamilyDetailsId=@ParentFamilyDetailsId AND FF.IsFavoritesForFamily=1)
				BEGIN
				    SET @IsFavourite=1
				END
			END
			IF (@IsView=1 AND ISNULL(@ParentFamilyDetailsId,0)<>@FamilyDetailsId AND ISNULL(@ParentFamilyDetailsId,0)>0)
		BEGIN
		    UPDATE nan.FamilyDetails SET ProfileViews=ISNULL(ProfileViews,0)+1 WHERE FamilyDetailsId=@FamilyDetailsId
		END	
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
				ISNULL([CM2].[CountryMasterId],0) AS CountryMasterId ,
                ISNULL([CM2].[CountryMasterName],'') AS CountryMasterName ,
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
				CASE WHEN ISNULL(FD.NannyRequired,-1)=0 THEN
				nan.ChangeDateFormat(FD.NannyAvailableDate,'dd/mm/yyyy')
				-- WHEN ISNULL(FD.NannyRequired,-1)=1 THEN
				--'Immediately'
				-- WHEN ISNULL(FD.NannyRequired,-1)=2 THEN
				--'Flexible'
				END AS StrNannyAvailableDate,
				CASE WHEN ISNULL(FD.NannyRequired,-1)=0 THEN
				nan.ChangeDateFormat(FD.NannyAvailableDate,'dd/mm/yyyy')
				 WHEN ISNULL(FD.NannyRequired,-1)=1 THEN
				'Immediately'
				 WHEN ISNULL(FD.NannyRequired,-1)=2 THEN
				'Flexible'
				END AS IsNannyAvailableDate,			
				ISNULL(@IsFavourite,0) AS IsFavourite,
				ISNULL(FD.ProfileViews,0) AS ProfileViews,
				CASE WHEN ISNULL(FD.ProfileImage,'')='' THEN 'app/images/avtar1Large.png'
					WHEN ISNULL(FD.ProfileImage,'')='male.png' THEN 'app/images/maleLarge.png'
					WHEN ISNULL(FD.ProfileImage,'')='female.png' THEN 'app/images/femaleLarge.png'
					 ELSE @APIUrl+'Uploads/'+FD.ProfileImage END AS ProfileImageUrl,
				CASE WHEN ISNULL(FD.ProfileImage,'')='' OR ISNULL(FD.ProfileImage,'')='' THEN CAST(0 AS BIT) ELSE CAST(1 AS BIT)  END AS HasImage,
				ISNULL(FD.ProfileImage,'') AS ProfileImage,				
				 CASE WHEN ISNULL(FD.ChildrenAge1,'-1')='-1' AND FD.ChildrenGender1 IS NULL THEN
							CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS IsChildren1,
							CAST(0 AS BIT) AS IsChildren2,
							 CASE WHEN ISNULL(FF.FamilyFavoritesId, 0) <> 0 AND ISNULL(FF.IsFavoritesForFamily,0)=1
                                 THEN CAST(1 AS BIT)
                                 ELSE CAST(0 AS BIT)
                            END AS IsFavourite,
							FD.IsActiveProfile AS IsActiveProfile ,
							ISNULL(FD.FirstName,'') AS FirstName,
							ISNULL(FD.LastName,'') AS LastName							
        FROM    nan.[FamilyDetails] AS FD
		LEFT JOIN nan.EthnicityChildMaster AS ECM ON ECM.EthnicityChildMasterId=FD.EthnicityChildMasterId
		LEFT JOIN nan.CountryMaster AS CM2 ON CM2.CountryMasterId = FD.CountryMasterId
		  LEFT JOIN nan.FamilyFavorites AS FF ON FF.FamilyDetailsId = @ParentFamilyDetailsId
                                                              AND FF.TargetFamilyDetailsId = @FamilyDetailsId
        WHERE   [FD].[FamilyDetailsId] = @FamilyDetailsId
		AND ISNULL(FD.IsDeleted,0)=0;		
    END;