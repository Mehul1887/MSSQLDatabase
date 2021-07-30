-- =============================================    
-- Author:  <Author,,ADMIN>    
-- Create date: <Create Date,, 24 Apr 2017>    
-- Description: <Description,,GetFamilyDetailsAll>    
-- Call SP    : nan.GetFamilyDetailsAll 50, 1, '', '',5,'51.7499025','-1.256551','','',-1,1,''    
-- =============================================    
CREATE PROCEDURE [nan].[GetFamilyDetailsAllForExport]
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
        SET NOCOUNT ON;    
							SELECT    FD.[FamilyDetailsId] AS FamilyDetailsId ,    
                            FD.[FamilyDetailsName] AS FamilyDetailsName ,    
                            FD.[HaveNanny] AS HaveNanny ,    
                            ECM.[EthnicityChildMasterName] AS EthnicityChildMasterName ,    
                            STUFF(( SELECT  ',' + LM.LanguageMasterName    
                                    FROM    nan.LanguageMaster AS LM    
                                    WHERE   LM.LanguageMasterId IN (    
                                            SELECT  Data    
                                            FROM    nan.Split(FD.LanguageMasterId,    
                                                              ',') )    
                                  FOR    
                                    XML PATH('')    
                                  ), 1, 1, '') AS LanguageMasterName ,    
                            FD.[Email] AS Email ,    
                            FD.[PhoneNumber] AS PhoneNumber ,    
                            FD.[Mobile] AS Mobile ,    
                            FD.[ContactTime] AS ContactTime ,    
                            FD.[PhoneNumberVisible] AS PhoneNumberVisible ,    
                            FD.[Address1] AS Address1 ,    
                            FD.[Address2] AS Address2 ,    
                            FD.[GoogleLat] AS GoogleLat ,    
                            FD.[GoogleLong] AS GoogleLong ,    
                            CM.[CountryMasterName] AS CountryMasterName ,    
                            FD.[PostCode] AS PostCode ,    
                            FD.[IsDeleteProfile] AS IsDeleteProfile ,    
                            FD.[DeleteProfileDateTime] AS DeleteProfileDateTime ,    
                            FD.[IsActiveProfilebyAdmin] AS IsActiveProfilebyAdmin ,    
                            FD.[IsActiveProfile] AS IsActiveProfile ,    
                            FD.[ActiveProfileDateTime] AS ActiveProfileDateTime ,    
                            FD.[CheckedTerms] AS CheckedTerms ,    
                            FD.[IsSubscribeNewsletter] AS IsSubscribeNewsletter ,                              
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total,    
       ROW_NUMBER() OVER ( ORDER BY FD.FamilyDetailsId DESC) AS RowNum ,    
       FD.FirstName AS FirstName,    
       FD.LastName AS LastName ,    
       CASE WHEN (SELECT COUNT(1) FROM nan.FamilySubscription AS FS WHERE FS.FamilyDetailsId=FD.FamilyDetailsId AND CAST(FS.EndDate AS DATE)>=CAST(GETUTCDATE() AS DATE))>0 THEN CAST(1 AS bit) ELSE CAST(0 AS BIT) END AS IsSubscribed,           
       (SELECT SUM(FPH.FinalAmount) FROM nan.FamilyPaymentHistory AS FPH WHERE FPH.FamilyDetailsId=FD.FamilyDetailsId) AS TotalAmount,    
       (SELECT COUNT(1) FROM nan.CustomerAuthentication AS CA WHERE CA.CustomerId=FD.FamilyDetailsId AND DATEDIFF(DAY,CA.CreatedOn,GETUTCDATE())<=60) AS NoOfLogIn,          
       (SELECT TOP 1 ISNULL(convert(varchar(20),CA.CreatedOn, 103) + right(convert(varchar(32),CA.CreatedOn,100),8),'') FROM nan.CustomerAuthentication AS CA WHERE CA.CustomerId=FD.FamilyDetailsId ORDER BY CA.CustomerAuthenticationId DESC) AS LastLoginTime     
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
       ORDER BY FD.[FamilyDetailsName] ASC    
    END;