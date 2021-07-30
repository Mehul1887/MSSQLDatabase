-- =============================================    
-- Author:  <Author,,ADMIN>    
-- Create date: <Create Date,, 24 Apr 2017>    
-- Description: <Description,,GetFamilyDetailsAll>    
-- Call SP    : nan.SearchFamilyDetails 50, 1, '', '',5,'51.7499025','-1.256551','','',-1,1,''    
-- =============================================    
CREATE PROCEDURE [nan].[SearchFamilyDetails]    
    @Rows INT ,    
    @Page INT ,    
    @Search NVARCHAR(500) ,    
    @Sort NVARCHAR(50) ,    
    @Distance FLOAT ,    
    @lat NVARCHAR(30) ,    
    @Long NVARCHAR(30) ,    
    @RegistrationStartDate DATETIME ,    
	@RegistrationEndDate DATETIME ,    
    @NannyRequired INT ,    
	@IsSubscribed INT,    
    @PostalCode NVARCHAR(10)    
AS    
    BEGIN    
	   DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SET NOCOUNT ON;   
		SELECT 
		FamilyDetailsId,
		FamilyDetailsName,
		Email ,   
		IsActiveProfile,
		RowNum ,
        Total   
		FROM 		 
		( SELECT    FD.[FamilyDetailsId] AS FamilyDetailsId ,    
                            FD.[FamilyDetailsName] AS FamilyDetailsName ,                                                    
                            FD.[Email] AS Email ,                            
                            FD.[IsActiveProfile] AS IsActiveProfile , 
							COUNT(*) OVER ( PARTITION BY 1 ) AS Total  ,
							  ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'FamilyDetailsId Asc'
                                                              THEN  FD.[FamilyDetailsId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'FamilyDetailsId DESC'
                                                              THEN  FD.[FamilyDetailsId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FamilyDetailsName Asc'
                                                              THEN FD.[FamilyDetailsName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilyDetailsName DESC'
                                                              THEN FD.[FamilyDetailsName]
															  ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'Email Asc'
                                                              THEN FD.Email
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Email DESC'
                                                              THEN FD.Email
															  ELSE ''
                                                              END DESC
															   , CASE
                                                              WHEN @Sort = 'IsActiveProfile Asc'
                                                              THEN FD.IsActiveProfile
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsActiveProfile DESC'
                                                              THEN FD.IsActiveProfile
															  ELSE 0
                                                              END DESC ) AS RowNum                          
                  FROM      nan.[FamilyDetails] AS FD    
                            LEFT JOIN nan.EthnicityChildMaster AS ECM ON ECM.EthnicityChildMasterId = FD.EthnicityChildMasterId    
                            LEFT JOIN nan.CountryMaster AS CM ON CM.CountryMasterId = FD.CountryMasterId           
                  WHERE     FD.IsDeleted = 0     
							AND CASE WHEN ISNULL(@IsSubscribed,-1)=-1 THEN -1 ELSE (CASE WHEN (SELECT COUNT(1) FROM nan.FamilySubscription AS FS WHERE FS.FamilyDetailsId=FD.FamilyDetailsId AND CAST(FS.EndDate AS DATE)>=CAST(GETUTCDATE() AS DATE))>0 THEN 1 ELSE 0 END) END = ISNULL(@IsSubscribed,-1)                 
                            AND ( ISNULL(FD.[FamilyDetailsName], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[HaveNanny], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(ECM.[EthnicityChildMasterName], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[Email], '') LIKE '%' + @Search    
                                  + '%'    
                                  OR ISNULL(FD.[PhoneNumber], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[Mobile], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[ContactTime], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[PhoneNumberVisible], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[Address1], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[Address2], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[GoogleLat], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[GoogleLong], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(CM.[CountryMasterName], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(REPLACE(FD.[PostCode],' ',''), '') LIKE '%'    
                                  + REPLACE(@Search,' ','') + '%'    
                                  OR ISNULL(FD.[IsDeleteProfile], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(nan.ChangeDateFormat(FD.[DeleteProfileDateTime],    
                                                              'yyyy-MM-dd'),    
                                            '') LIKE '%' + @Search + '%'    
                                  OR ISNULL(FD.[IsActiveProfilebyAdmin], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[IsActiveProfile], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(nan.ChangeDateFormat(FD.[ActiveProfileDateTime],    
                                                              'yyyy-MM-dd'),    
                                            '') LIKE '%' + @Search + '%'    
                                  OR ISNULL(FD.[CheckedTerms], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(FD.[IsSubscribeNewsletter], '') LIKE '%'    
                                  + @Search + '%'    
                                  OR ISNULL(nan.ChangeDateFormat(FD.[LastLoginTime],    
                                                              'yyyy-MM-dd'),    
                                            '') LIKE '%' + @Search + '%'    
                                )    
                            AND CASE WHEN ISNULL(@Distance, 0) = 0 OR ISNULL(@lat,'0')= '0' OR ISNULL(@Long,'0')='0'  THEN ISNULL(@Distance, 0)    
                                     ELSE nan.fnGetLatLongDistanceMiles(@lat,    
                                                              @Long,    
                                                              FD.GoogleLat,    
                                                              FD.GoogleLong)    
                                END <= ISNULL(@Distance, 0)    
						AND CASE WHEN ISNULL(@RegistrationStartDate,'')='' THEN CAST(@RegistrationStartDate AS DATE) ELSE CAST(FD.CreatedOn AS DATE) END >= CAST(@RegistrationStartDate AS DATE)                        
						AND CASE WHEN ISNULL(@RegistrationEndDate,'')='' THEN CAST(@RegistrationEndDate AS DATE) ELSE CAST(FD.CreatedOn AS DATE) END <= CAST(@RegistrationEndDate AS DATE)                              
                            AND CASE WHEN ISNULL(@NannyRequired, -1) = -1    
                                     THEN -1    
                                     ELSE FD.HaveNanny    
                                END = ISNULL(@NannyRequired, -1)                                
        
	   ) AS T
	    WHERE   RowNum BETWEEN @Start AND @End;
    END;