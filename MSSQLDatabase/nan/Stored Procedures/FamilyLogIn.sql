-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<nan.FamilyLogIn>
-- Call SP    :	nan.FamilyLogIn 'tiberi@gmail.com','123',0
-- =============================================
CREATE PROCEDURE [nan].[FamilyLogIn]
    @Email NVARCHAR(100) ,
    @Password NVARCHAR(100),
	@IsSocial bit
AS
    BEGIN
        SET NOCOUNT ON; 
        DECLARE @FamilyDetailsId BIGINT= 0 ,
            @UserToken NVARCHAR(250)= '' ,
            @IsDeletedByAdmin BIT			 
				DECLARE @APIUrl NVARCHAR(500)= (SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='APIUrl')
		IF(ISNULL(@IsSocial,0)=0)
		BEGIN
        IF EXISTS ( SELECT  FD.FamilyDetailsId
                    FROM    nan.FamilyDetails AS FD
                    WHERE   ISNULL(FD.IsDeleted, 0) = 0
                            AND FD.Email = @Email
                            AND FD.Password = @Password )
            BEGIN
                SELECT  @FamilyDetailsId = FD.FamilyDetailsId ,
                        @IsDeletedByAdmin = FD.IsDeleteProfile 
                FROM    nan.FamilyDetails AS FD
                WHERE   ISNULL(FD.IsDeleted, 0) = 0
                        AND FD.Email = @Email
                        AND FD.Password = @Password;             
                    IF @IsDeletedByAdmin = 1
                        BEGIN                            
										SELECT 
										CAST(-2 AS BIGINT) AS FamilyDetailsId,
										'' AS UserToken,
										'' AS FirstName,
										'' AS LastName,
										'' AS FamilyDetailsName,
										'' AS GoogleLat,
										'' AS GoogleLong,
										'' AS ProfileImageUrl		
                        END;
                    ELSE
                        BEGIN
                            SELECT  @UserToken = NEWID();
                           
                                    INSERT  INTO nan.CustomerAuthentication
                                            ( CustomerId ,
                                              CustomerToken ,
                                              IsFamily ,
                                              CreatedOn ,
                                              CreatedBy ,
                                              IsDeleted
				                            )
                                    VALUES  ( @FamilyDetailsId , -- CustomerId - bigint
                                              @UserToken , -- CustomerToken - nvarchar(250)
                                              1 , -- IsFamily - bit
                                              GETUTCDATE() , -- CreatedOn - datetime
                                              @FamilyDetailsId , -- CreatedBy - bigint				              
                                              0 -- IsDeleted - bit
				                            );
  
								SELECT 
								ISNULL(FD.FamilyDetailsId,0) AS FamilyDetailsId,
								ISNULL(@UserToken,'') AS UserToken,
								ISNULL(FD.FirstName,'') AS FirstName,
								ISNULL(FD.LastName,'') AS LastName,
								ISNULL(FD.FamilyDetailsName,'') AS FamilyDetailsName,
								ISNULL(FD.GoogleLat,'') AS GoogleLat,
								ISNULL(FD.GoogleLong,'') AS GoogleLong,
								CASE WHEN ISNULL(FD.ProfileImage,'')='' THEN 'app/images/avtar1Large.png'
								WHEN ISNULL(FD.ProfileImage,'')='male.png' THEN 'app/images/maleLarge.png'
								WHEN ISNULL(FD.ProfileImage,'')='female.png' THEN 'app/images/femaleLarge.png'
								 ELSE @APIUrl+'Uploads/'+FD.ProfileImage END AS ProfileImageUrl FROM nan.FamilyDetails AS FD
								WHERE FD.FamilyDetailsId= ISNULL(@FamilyDetailsId,0)
                        END;			
            END;
        ELSE
            BEGIN
                SET @FamilyDetailsId = 0;
				SELECT 
								CAST(0 AS BIGINT) AS FamilyDetailsId,
								'' AS UserToken,
								'' AS FirstName,
								'' AS LastName,
								'' AS FamilyDetailsName,
								'' AS GoogleLat,
								'' AS GoogleLong,
								'' AS ProfileImageUrl	
            END;	
			END
			ELSE
			BEGIN
			       IF EXISTS ( SELECT  FD.FamilyDetailsId
                    FROM    nan.FamilyDetails AS FD
                    WHERE   ISNULL(FD.IsDeleted, 0) = 0
                            AND FD.Email = @Email)
            BEGIN
                SELECT  @FamilyDetailsId = FD.FamilyDetailsId ,
                        @IsDeletedByAdmin = FD.IsDeleteProfile 
                FROM    nan.FamilyDetails AS FD
                WHERE   ISNULL(FD.IsDeleted, 0) = 0
                        AND FD.Email = @Email
                        
                    IF @IsDeletedByAdmin = 1
                        BEGIN                            
										SELECT 
										CAST(-2 AS BIGINT) AS FamilyDetailsId,
										'' AS UserToken,
										'' AS FirstName,
										'' AS LastName,
										'' AS FamilyDetailsName,
										'' AS GoogleLat,
										'' AS GoogleLong,
										'' AS ProfileImageUrl		
                        END;
                    ELSE
                        BEGIN
                            SELECT  @UserToken = NEWID()                        
                                   INSERT  INTO nan.CustomerAuthentication
                                            ( CustomerId ,
                                              CustomerToken ,
                                              IsFamily ,
                                              CreatedOn ,
                                              CreatedBy ,
                                              IsDeleted
				                            )
                                    VALUES  ( @FamilyDetailsId , -- CustomerId - bigint
                                              @UserToken , -- CustomerToken - nvarchar(250)
                                              1 , -- IsFamily - bit
                                              GETUTCDATE() , -- CreatedOn - datetime
                                              @FamilyDetailsId , -- CreatedBy - bigint				              
                                              0 -- IsDeleted - bit
				                            );                             
								SELECT 
								ISNULL(FD.FamilyDetailsId,0) AS FamilyDetailsId,
								ISNULL(@UserToken,'') AS UserToken,
								ISNULL(FD.FirstName,'') AS FirstName,
								ISNULL(FD.LastName,'') AS LastName,
								ISNULL(FD.FamilyDetailsName,'') AS FamilyDetailsName,
								ISNULL(FD.GoogleLat,'') AS GoogleLat,
								ISNULL(FD.GoogleLong,'') AS GoogleLong,
								CASE WHEN ISNULL(FD.ProfileImage,'')='' THEN '' ELSE @APIUrl+'Uploads/'+FD.ProfileImage END AS ProfileImageUrl FROM nan.FamilyDetails AS FD
								WHERE FD.FamilyDetailsId= ISNULL(@FamilyDetailsId,0)
                        END;			
            END;
        ELSE
            BEGIN
                SET @FamilyDetailsId = 0;
				SELECT 
								CAST(0 AS BIGINT) AS FamilyDetailsId,
								'' AS UserToken,
								'' AS FirstName,
								'' AS LastName,
								'' AS FamilyDetailsName,
								'' AS GoogleLat,
								'' AS GoogleLong,
								'' AS ProfileImageUrl	
            END;	
			END			
    END;