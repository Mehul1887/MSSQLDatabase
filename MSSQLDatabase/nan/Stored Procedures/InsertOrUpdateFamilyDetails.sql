-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateFamilyDetails>
-- Call SP    :	nan.InsertOrUpdateFamilyDetails
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateFamilyDetails]
    @FamilyDetailsId BIGINT ,
    @FamilyDetailsName NVARCHAR(100) ,
	@FirstName NVARCHAR(100),
	@LastName NVARCHAR(100),
    @HaveNanny INT ,
    @EthnicityChildMasterId INT ,
    @LanguageMasterId NVARCHAR(500) ,
    @Email NVARCHAR(50) ,
    @PhoneNumber NVARCHAR(50) ,
    @Mobile NVARCHAR(20) ,
    @Password NVARCHAR(100) ,
    @ContactTime NVARCHAR(100) ,
    @PhoneNumberVisible BIT ,
    @Address1 NVARCHAR(250) ,
    @Address2 NVARCHAR(250) ,
    @GoogleLat NVARCHAR(20) ,
    @GoogleLong NVARCHAR(20) ,
	@CityName NVARCHAR(100),
	@CountyName NVARCHAR(100),
    @CountryMasterId BIGINT ,
    @PostCode NVARCHAR(20) ,
    @IsDeleteProfile BIT ,
    @IsActiveProfilebyAdmin BIT ,
    @IsActiveProfile BIT ,
    @CheckedTerms BIT ,
    @IsSubscribeNewsletter BIT ,
    @HaveSmoker BIT ,
    @NoOfChildren INT ,
    @ChildrenAge1 NVARCHAR(50) ,
    @ChildrenGender1 BIT ,
    @ChildrenAge2 NVARCHAR(50) ,
    @ChildrenGender2 BIT ,
    @NannyAvailableDate DATETIME ,
    @NannyRequired INT ,
    @HavePet BIT ,
    @PetDetails NVARCHAR(500) ,
	@Description nvarchar(500),
	@ProfileImage NVARCHAR(500),   
	@RegisterBy VARCHAR(10),
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

		DECLARE @IsFree BIT =  CAST((SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='IsFree') AS BIT)
		DECLARE @SubscriptionDays INT =  CAST((SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='FreeSubscriptionInDays') AS INT)
		IF(@GoogleLat='')
		BEGIN
		    SET @GoogleLat='0'
		END
		IF(@GoogleLong='')
		BEGIN
		    SET @GoogleLong='0'
		END
		  IF @IsFree=0 AND @FamilyDetailsId=0
		  BEGIN
		      SET @IsActiveProfile=0
		  END
		  ELSE IF @IsFree=1 AND @FamilyDetailsId =0
		  BEGIN
		     SET @IsActiveProfile=1
		  END
		IF NOT EXISTS(SELECT FD.FamilyDetailsId FROM nan.FamilyDetails AS FD WHERE ISNULL(FD.FamilyDetailsName,'')=ISNULL(@FamilyDetailsName,'') AND ISNULL(FD.FamilyDetailsId,0)!=ISNULL(@FamilyDetailsId,0) AND ISNULL(FD.IsDeleted,0)=0)
		BEGIN
		  		
        IF ( @FamilyDetailsId = 0 )
            BEGIN
                INSERT  INTO nan.FamilyDetails
                        ( FamilyDetailsName ,
							FirstName,
							LastName,
                          HaveNanny ,
                          EthnicityChildMasterId ,
                          LanguageMasterId ,
                          Email ,
                          PhoneNumber ,
                          Mobile ,
                          Password ,
                          ContactTime ,
                          PhoneNumberVisible ,
                          Address1 ,
                          Address2 ,
                          GoogleLat ,
                          GoogleLong ,
						  CityName,
                          CountryMasterId,
						  CountyName,
                          HaveSmoker ,
                          NoOfChildren ,
                          ChildrenAge1 ,
                          ChildrenGender1 ,
                        --  ChildrenAge2 ,
                        --  ChildrenGender2 ,
                          NannyAvailableDate ,
                          NannyRequired ,
                          HavePet ,
                          PetDetails ,
                          PostCode ,
                          IsDeleteProfile ,
                          IsActiveProfilebyAdmin ,
                          IsActiveProfile ,                     
                          CheckedTerms ,
                          IsSubscribeNewsletter ,
                          Description ,  
						  ProfileImage,
						  RegisterBy,                      
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
                        )
                VALUES  ( @FamilyDetailsName , -- FamilyDetailsName - nvarchar(100)
							@FirstName,
							@LastName,
                          @HaveNanny , -- HaveNanny - int
                          @EthnicityChildMasterId , -- EthnicityChildMasterId - bigint
                          @LanguageMasterId , -- LanguageMasterId - bigint
                          @Email , -- Email - nvarchar(50)
                          @PhoneNumber , -- PhoneNumber - nvarchar(50)
                          @Mobile , -- Mobile - nvarchar(20)
                          @Password , -- Password - nvarchar(100)
                          @ContactTime , -- ContactTime - nvarchar(100)
                          @PhoneNumberVisible , -- PhoneNumberVisible - bit
                          @Address1 , -- Address1 - nvarchar(250)
                          @Address2 , -- Address2 - nvarchar(250)
                          @GoogleLat , -- GoogleLat - nvarchar(20)
                          @GoogleLong , -- GoogleLong - nvarchar(20)
						  @CityName,
                          @CountryMasterId ,
						  @CountyName, -- AreaMasterId - bigint
                          @HaveSmoker , -- HaveSmoker - bit
                          @NoOfChildren , -- NoOfChildren - int
                          @ChildrenAge1 , -- ChildrenAge1 - int
                          @ChildrenGender1 , -- ChildrenGender1 - bit
                        --  @ChildrenAge2 , -- ChildrenAge2 - int
                       --   @ChildrenGender2 , -- ChildrenGender2 - bit
                          CASE WHEN @NannyRequired=0 THEN @NannyAvailableDate ELSE NULL END , -- NannyAvailableDate - datetime
                          @NannyRequired , -- NannyRequired - int
                          @HavePet , -- HavePet - bit
                          @PetDetails , -- PetDetails - nvarchar(500)
                          @PostCode , -- PostCode - nvarchar(20)
                          0 , -- IsDeleteProfile - bit
                          1 , -- IsActiveProfilebyAdmin - bit
                          @IsActiveProfile , -- IsActiveProfile - bit
                          @CheckedTerms , -- CheckedTerms - bit
                          1 , -- IsSubscribeNewsletter - bit
                          @Description , -- Description - nvarchar(500)   
						  @ProfileImage, 
						  ISNULL(@RegisterBy,'portal'),
                          GETUTCDATE() , -- CreatedOn - datetime
                          @UserId , -- CreatedBy - bigint     
                          0  -- IsDeleted - bit
                        );
                SELECT  @FamilyDetailsId = SCOPE_IDENTITY();
                DECLARE @IdList NVARCHAR(MAX) ,
                    @SearchingDistence FLOAT;
                SET @SearchingDistence = ( SELECT   CAST(ACS.KeyValue AS FLOAT)
                                           FROM     nan.AAAAConfigSettings AS ACS
                                           WHERE    ACS.KeyName = 'SearchingDistence'
                                         );
                SELECT  @IdList = STUFF(( SELECT    ','
                                                    + ISNULL(CAST(FD.FamilyDetailsId AS VARCHAR(5)),
                                                             '')
                                          FROM      nan.FamilyDetails AS FD
                                          WHERE     FD.FamilyDetailsId <> @FamilyDetailsId
                                                    AND ISNULL(FD.IsDeleted, 0) = 0
                                                    AND ISNULL(FD.IsActiveProfile,
                                                              0) = 1
                                                    AND ISNULL(FD.IsSubscribeNewsletter,
                                                              0) = 1
                                                    AND ISNULL(FD.GoogleLat,
                                                              '') <> ''
                                                    AND ISNULL(FD.GoogleLong,
                                                              '') <> ''
                                                    AND nan.fnGetLatLongDistanceMiles(@GoogleLat,
                                                              @GoogleLong,
                                                              FD.GoogleLat,
                                                              FD.GoogleLong) <= @SearchingDistence
                                        FOR
                                          XML PATH('')
                                        ), 1, 1, '');
						
						
                EXEC nan.CreateEmail @TemplateTitle = N'New Family Register', -- nvarchar(100)
                    @FamilyIdList = @IdList, -- nvarchar(max)
                     @RecordId= @FamilyDetailsId, -- bigint
                    @PageId = @PageId, -- int
                    @UserId = @UserId, -- int
                    @AgencyId = NULL; -- int

					EXEC nan.CreateEmail @TemplateTitle = N'Welcome Mail', -- nvarchar(100)
					    @FamilyIdList = N'', -- nvarchar(max)
					    @RecordId = @FamilyDetailsId, -- bigint
					    @PageId = @PageId, -- int
                    @UserId = @UserId, -- int
                    @AgencyId = NULL; -- int

					IF(@IsFree=1)
					BEGIN
					    INSERT INTO nan.FamilySubscription
					            ( FamilySubscriptionName ,
					              FamilyDetailsId ,
					              SubscriptionMasterId ,
					              StartDate ,
					              EndDate ,
					              CreatedOn ,
					              CreatedBy ,					            
					              IsDeleted
					            )
					    VALUES  ( N'Free For '+CAST(@SubscriptionDays AS VARCHAR(5)) , -- FamilySubscriptionName - nvarchar(100)
					              @FamilyDetailsId , -- FamilyDetailsId - bigint
					              NULL , -- SubscriptionMasterId - bigint
					              GETUTCDATE() , -- StartDate - datetime
					              DATEADD(DAY,@SubscriptionDays,GETUTCDATE() ) , -- EndDate - datetime
					              GETUTCDATE() , -- CreatedOn - datetime
					              @UserId , -- CreatedBy - bigint					              
					              0 -- IsDeleted - bit
					            )
					END
											
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Insert record in table FamilyDetails' ,
                          'FamilyDetails' ,
                          @FamilyDetailsId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  FD
                SET              FD.FamilyDetailsName= @FamilyDetailsName,
									FD.FirstName = @FirstName,
									FD.LastName=@LastName,	
                                 FD.HaveNanny    = @HaveNanny  ,
                                 FD.EthnicityChildMasterId   = @EthnicityChildMasterId  ,
                                 FD.LanguageMasterId   = @LanguageMasterId  ,
                                 FD.Email   = @Email  ,
                                 FD.PhoneNumber   = @PhoneNumber  ,
                                 FD.Mobile   = @Mobile  ,
								 FD.CityName =@CityName,
								 FD.CountyName = @CountyName,
                                 FD.Password   = @Password  ,
                                 FD.ContactTime   = @ContactTime  ,
                                 FD.PhoneNumberVisible   = @PhoneNumberVisible  ,
                                 FD.Address1   = @Address1  ,
                                 FD.Address2   = @Address2 ,
                                 FD.GoogleLat   = @GoogleLat  ,
                                 FD.GoogleLong   = @GoogleLong ,
								 FD.CountryMasterId   = @CountryMasterId ,
                                 FD.PostCode   = @PostCode  ,
                              --   FD.IsDeleteProfile   = @IsDeleteProfile  ,
                              --   FD.IsActiveProfilebyAdmin   = @IsActiveProfilebyAdmin  ,
                                FD.IsActiveProfile   = @IsActiveProfile  ,
                                 FD.CheckedTerms   = @CheckedTerms  ,
                           
                                 FD.HaveSmoker   = @HaveSmoker  ,
                                 FD.NoOfChildren   = @NoOfChildren  ,
                                 FD.ChildrenAge1   = @ChildrenAge1  ,
                                 FD.ChildrenGender1   = @ChildrenGender1  ,
                                -- FD.ChildrenAge2   = @ChildrenAge2  ,
                                -- FD.ChildrenGender2   = @ChildrenGender2  ,
                                 FD.NannyAvailableDate   = CASE WHEN @NannyRequired=0 THEN @NannyAvailableDate ELSE NULL END  ,
                                 FD.NannyRequired   = @NannyRequired  ,
                                 FD.HavePet   = @HavePet  ,
								 FD.IsSubscribeNewsletter=@IsSubscribeNewsletter,
                                 FD.PetDetails  = @PetDetails  ,
	                             FD.Description   =  @Description , 
								 FD.ProfileImage =@ProfileImage,                               
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
                FROM    nan.[FamilyDetails] AS FD
                WHERE   [FamilyDetailsId] = @FamilyDetailsId;
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Update record in table FamilyDetails' ,
                          'FamilyDetails' ,
                          @FamilyDetailsId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@FamilyDetailsId, 0) AS InsertedId;
		END
		ELSE
		BEGIN
		    SELECT  CAST(ISNULL(-1, -1) AS BIGINT) AS InsertedId;
		END
    END;