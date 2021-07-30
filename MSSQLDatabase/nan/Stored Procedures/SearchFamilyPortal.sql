-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyDetailsAll>
-- Call SP    :	nan.SearchFamilyPortal 100,1,'','',1,'51.75308159999999','-1.2559484999999313',NULL,-1,0,-1,91,0
-- =============================================
CREATE PROCEDURE [nan].[SearchFamilyPortal]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(100) ,
    @Sort NVARCHAR(50) ,
    @Distance FLOAT ,
    @lat NVARCHAR(30) ,
    @Long NVARCHAR(30) ,
    @NannySharingStartDate DATETIME ,
    @NannyRequired INT ,
    @NoOfChildren INT ,
    @HaveNanny INT ,
    @FamilyDetailId BIGINT ,
    @IsFavourite BIT
AS
    BEGIN
        SET NOCOUNT ON;
	--	SET @Search=REPLACE(@Search,' ','')
        DECLARE @SearchDistance FLOAT ,
            @APIUrl NVARCHAR(250);
        DECLARE @Start AS INT ,		
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  @SearchDistance = CAST(( SELECT ACS.KeyValue
                                         FROM   nan.AAAAConfigSettings AS ACS
                                         WHERE  ACS.KeyName = 'SearchingDistence'
                                       ) AS FLOAT);
        SELECT  @APIUrl = ( SELECT  ACS.KeyValue
                            FROM    nan.AAAAConfigSettings AS ACS
                            WHERE   ACS.KeyName = 'APIUrl'
                          );

			DECLARE @FamilyLat NVARCHAR(50)='',@FamilyLong NVARCHAR(50)=''
		
			IF(ISNULL(@lat,'0')='0' AND ISNULL(@Long,'0')='0')
			BEGIN
				SELECT @FamilyLat= ISNULL(FD.GoogleLat,'0'), @FamilyLong=ISNULL(FD.GoogleLong,'0') FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@FamilyDetailId
				SET @lat = @FamilyLat
				SET @Long = @FamilyLong
			END
					
        SELECT  RowNum ,
                Total ,
                FamilyDetailsId ,
                FamilyDetailsName ,
                HaveNanny ,
				IsNanny,
                Email ,
                PhoneNumber ,
                Mobile ,
                Address1 ,
                Address2 ,
                Address2 ,
                Address2 ,
                GoogleLat ,
                GoogleLong ,
                PostCode ,
                IsFavourite ,
                ProfileImage,
				IsChildren1,
				IsChildren2,
				ChildrenAge1,
				ChildrenGender1,
				ChildrenAge2,
				ChildrenGender2,
				CountryMasterName,
				Distance
        FROM    ( SELECT    FD.FamilyDetailsId AS FamilyDetailsId ,
                            FD.FamilyDetailsName AS FamilyDetailsName ,
                            FD.HaveNanny AS HaveNanny ,
							CASE WHEN ISNULL(FD.HaveNanny,-1)=-1 THEN '' 
								WHEN 	ISNULL(FD.HaveNanny,-1)=0 THEN 'No'
								WHEN 	ISNULL(FD.HaveNanny,-1)=1 THEN 'Yes'
								WHEN 	ISNULL(FD.HaveNanny,-1)=2 THEN 'Flexible' END AS IsNanny,
                            FD.Email AS Email ,
                            FD.PhoneNumber AS PhoneNumber ,
                            FD.Mobile AS Mobile ,
                            FD.Address1 AS Address1 ,
                            FD.Address2 AS Address2 ,
                            FD.GoogleLat AS GoogleLat ,
                            FD.GoogleLong AS GoogleLong ,
                            FD.PostCode AS PostCode ,
                            CASE WHEN ISNULL(FF.FamilyFavoritesId, 0) <> 0 AND FF.IsFavoritesForFamily=1
                                 THEN CAST(1 AS BIT)
                                 ELSE CAST(0 AS BIT)
                            END AS IsFavourite ,
                            CASE WHEN ISNULL(FD.ProfileImage, '') = '' THEN 'app/images/avtar1Large.png'
								WHEN ISNULL(FD.ProfileImage,'')='female.png' THEN 'app/images/femaleLarge.png'
								WHEN ISNULL(FD.ProfileImage,'')='male.png' THEN 'app/images/maleLarge.png'
                                 ELSE @APIUrl + 'Uploads/' + FD.ProfileImage
                            END AS ProfileImage ,
							 CASE WHEN ISNULL(FD.ChildrenAge1,'-1')='-1' AND FD.ChildrenGender1 IS NULL THEN
							CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS IsChildren1,
							CASE WHEN ISNULL(FD.ChildrenAge2,'-1')='-1' AND FD.ChildrenGender2 IS NULL THEN
							CAST(0 AS BIT) ELSE CAST(1 AS BIT) END AS IsChildren2,
							ISNULL(FD.ChildrenAge1,'0') AS ChildrenAge1,
							FD.ChildrenGender1 AS ChildrenGender1,
							FD.ChildrenAge2 AS ChildrenAge2,
							FD.ChildrenGender2 AS ChildrenGender2,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY FD.FamilyDetailsId DESC ) AS RowNum,
							ISNULL(CM.CountryMasterName,'') AS CountryMasterName,
							ROUND(nan.fnGetLatLongDistanceMiles(@lat,
                                                              @Long,
                                                              FD.GoogleLat,
                                                              FD.GoogleLong),1) AS Distance
                  FROM      nan.FamilyDetails AS FD
                            LEFT JOIN nan.FamilyFavorites AS FF ON FF.FamilyDetailsId = @FamilyDetailId
                                                              AND FF.TargetFamilyDetailsId = FD.FamilyDetailsId							
							LEFT JOIN nan.CountryMaster AS CM ON CM.CountryMasterId = FD.CountryMasterId
                  WHERE     FD.IsDeleted = 0
							AND ISNULL(FD.IsActiveProfile,1)=1 AND ISNULL(FD.IsDeleteProfile,0)=0
                            AND FD.FamilyDetailsId != @FamilyDetailId
							AND CASE WHEN (SELECT COUNT(1) FROM nan.FamilySubscription AS FS WHERE FS.FamilyDetailsId=FD.FamilyDetailsId AND ISNULL(FS.IsDeleted,0)=0 AND CAST(FS.StartDate AS DATE)<= CAST(GETUTCDATE() AS DATE) AND CAST(FS.EndDate AS DATE)>=CAST(GETUTCDATE() AS DATE))>0 THEN 1 ELSE 0 END =1
                            AND CASE WHEN ISNULL(@IsFavourite, 0) = 0 THEN 0
                                     ELSE ( CASE WHEN ISNULL(FF.FamilyFavoritesId,
                                                             0) <> 0 THEN 1
                                                 ELSE 0
                                            END )
                                END = ISNULL(@IsFavourite, 0)
							AND CASE WHEN ISNULL(@IsFavourite,0)=0 THEN 0 ELSE
							 ( CASE WHEN ISNULL(FF.FamilyFavoritesId,
                                                          0) <> 0 THEN FF.IsFavoritesForFamily
                                                 ELSE 0
                                            END ) END = ISNULL(@IsFavourite,0)   
				
                            AND CASE WHEN ISNULL(@HaveNanny, -1) = -1 THEN -1
                                     ELSE FD.HaveNanny
                                END = ISNULL(@HaveNanny, -1)
                            AND CASE WHEN ISNULL(@NannyRequired, -1) = -1
                                     THEN -1
                                     ELSE FD.NannyRequired
                                END = ISNULL(@NannyRequired, -1)
                            AND CASE WHEN ISNULL(@NoOfChildren, 0) = 0 THEN 0
                                     ELSE FD.NoOfChildren
                                END = ISNULL(@NoOfChildren, 0)
						
                            AND ( CASE WHEN ISNULL(@NannySharingStartDate, '') = ''
                                       THEN 1
                                       ELSE DATEDIFF(DAY,
                                                     @NannySharingStartDate,FD.NannyAvailableDate)
                                  END >= 0
                                
                                )
                            AND CASE WHEN ISNULL(@Distance, 0) = 0 THEN 0
                                     ELSE nan.fnGetLatLongDistanceMiles(@lat,
                                                              @Long,
                                                              FD.GoogleLat,
                                                              FD.GoogleLong)
                                END <= ISNULL(@Distance, 0)
      
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End
		ORDER BY T.Distance ASC
	
    END;