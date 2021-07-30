-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetAgencyDetailsAll>
-- Call SP    :	nan.SearchAgencyDetails 10, 1, '', '',-1
-- =============================================
CREATE PROCEDURE [nan].[SearchAgencyDetails]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50) ,
    @IsReviewed INT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                AgencyDetailsId ,
                AgencyDetailsName ,
                Address1 ,
                Address2 ,
                GoogleLat ,
                GoogleLong ,
                AreaName ,
                CountryName,
				 PostCode ,
                Phone ,
                Email ,
                Website ,
                ContactForm ,
                IsProfileReviewed ,
                IsDeleteProfile ,
                DeleteProfileDateTime ,
                IsActiveProfilebyAdmin ,
                IsActiveProfile ,
                ActiveProfileDateTime ,
                CheckedTerms ,
                IsSubscribeNewsletter ,
                LastLoginTime
        FROM    ( SELECT    [AgencyDetails].[AgencyDetailsId] AS AgencyDetailsId ,
                            [AgencyDetails].[AgencyDetailsName] AS AgencyDetailsName ,
                            [AgencyDetails].[Address1] AS Address1 ,
                            [AgencyDetails].[Address2] AS Address2 ,
                            [AgencyDetails].[GoogleLat] AS GoogleLat ,
                            [AgencyDetails].[GoogleLong] AS GoogleLong ,
                            [AM].[AreaMasterName] AS AreaName ,
                            [CM].[CountryMasterName] AS CountryName ,
                            [AgencyDetails].[PostCode] AS PostCode ,
                            [AgencyDetails].[Phone] AS Phone ,
                            [AgencyDetails].[Email] AS Email ,
                            [AgencyDetails].[Website] AS Website ,
                            [AgencyDetails].[ContactForm] AS ContactForm ,
                            [AgencyDetails].[IsProfileReviewed] AS IsProfileReviewed ,
                            [AgencyDetails].[IsDeleteProfile] AS IsDeleteProfile ,
                            [AgencyDetails].[DeleteProfileDateTime] AS DeleteProfileDateTime ,
                            [AgencyDetails].[IsActiveProfilebyAdmin] AS IsActiveProfilebyAdmin ,
                            [AgencyDetails].[IsActiveProfile] AS IsActiveProfile ,
                            [AgencyDetails].[ActiveProfileDateTime] AS ActiveProfileDateTime ,
                            [AgencyDetails].[CheckedTerms] AS CheckedTerms ,
                            [AgencyDetails].[IsSubscribeNewsletter] AS IsSubscribeNewsletter ,
                            [AgencyDetails].[LastLoginTime] AS LastLoginTime ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'AgencyDetailsId Asc'
                                                              THEN [AgencyDetails].[AgencyDetailsId]
                                                              ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'AgencyDetailsId DESC'
                                                              THEN [AgencyDetails].[AgencyDetailsId]
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'AgencyDetailsName Asc'
                                                              THEN [AgencyDetails].[AgencyDetailsName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'AgencyDetailsName DESC'
                                                              THEN [AgencyDetails].[AgencyDetailsName]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Address1 Asc'
                                                              THEN [AgencyDetails].[Address1]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Address1 DESC'
                                                              THEN [AgencyDetails].[Address1]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Address2 Asc'
                                                              THEN [AgencyDetails].[Address2]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Address2 DESC'
                                                              THEN [AgencyDetails].[Address2]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'AreaName Asc'
                                                              THEN [AM].[AreaMasterName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'AreaName DESC'
                                                              THEN [AM].[AreaMasterName]
                                                              ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'Country Asc'
                                                              THEN [CM].[CountryMasterName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Country DESC'
                                                              THEN [CM].[CountryMasterName]
                                                              ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'PostCode Asc'
                                                              THEN [AgencyDetails].[PostCode]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PostCode DESC'
                                                              THEN [AgencyDetails].[PostCode]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Phone Asc'
                                                              THEN [AgencyDetails].[Phone]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Phone DESC'
                                                              THEN [AgencyDetails].[Phone]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Email Asc'
                                                              THEN [AgencyDetails].[Email]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Email DESC'
                                                              THEN [AgencyDetails].[Email]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Website Asc'
                                                              THEN [AgencyDetails].[Website]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Website DESC'
                                                              THEN [AgencyDetails].[Website]
                                                              ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'CreatedOn Asc'
                                                              THEN [AgencyDetails].[CreatedOn]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CreatedOn DESC'
                                                              THEN [AgencyDetails].[CreatedOn]
                                                              ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[AgencyDetails] AS AgencyDetails
                            LEFT JOIN nan.AreaMaster AS AM ON AM.AreaMasterId = AgencyDetails.AreaId
                            LEFT JOIN nan.CountryMaster AS CM ON CM.CountryMasterId = AM.CountryMatserId
                  WHERE     [AgencyDetails].IsDeleted = 0
                            AND CASE WHEN ISNULL(@IsReviewed, -1) = -1 THEN -1
                                     ELSE AgencyDetails.IsProfileReviewed
                                END = ISNULL(@IsReviewed, -1)
                            AND ( ISNULL([AgencyDetails].[AgencyDetailsName],
                                         '') LIKE '%' + @Search + '%'
                                  --OR ISNULL([AgencyDetails].[Address1], '') LIKE '%'
                                  --+ @Search + '%'
                                  --OR ISNULL([AgencyDetails].[Address2], '') LIKE '%'
                                  --+ @Search + '%'
                                  --OR ISNULL([AgencyDetails].[GoogleLat], '') LIKE '%'
                                  --+ @Search + '%'
                                  --OR ISNULL([AgencyDetails].[GoogleLong], '') LIKE '%'
                                  --+ @Search + '%'
                                  --OR ISNULL([AgencyDetails].[AreaId], '') LIKE '%'
                                  --+ @Search + '%'
                                  OR ISNULL([AM].[AreaMasterName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([CM].[CountryMasterName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([AgencyDetails].[PostCode], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([AgencyDetails].[Phone], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([AgencyDetails].[Email], '') LIKE '%'
                                  + @Search + '%'
								   OR CASE WHEN ISNULL([AgencyDetails].[IsActiveProfilebyAdmin],0)=0 THEN 'In Active' ELSE 'Active' END LIKE '%'
                                  + @Search + '%'
                                  --OR ISNULL([AgencyDetails].[Website], '') LIKE '%'
                                  --+ @Search + '%'
                                  --OR ISNULL([AgencyDetails].[ContactForm], '') LIKE '%'
                                  --+ @Search + '%'
                                  --OR ISNULL(nan.ChangeDateFormat([AgencyDetails].[LastLoginTime],
                                  --                            'yyyy-MM-dd'),
                                  --          '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;