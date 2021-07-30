-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <05 Sep 2017>
-- Description:	<nan.GetFamilyStatus>
-- Call SP    :	nan.GetFamilyStatus 45
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyStatus]
    @FamilDetailsId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

			
        DECLARE @IsSubscribed BIT ,@IsFree BIT =0,
            @ProfileCompletion INT= 0,@RegisterBy VARCHAR(50);
        SELECT  @ProfileCompletion += ISNULL( (SELECT   CASE WHEN 
														  --ISNULL(FD.FirstName,
                --                                              '') <> ''
                --                                          AND ISNULL(FD.LastName,
                --                                              '') <> ''
                --                                          AND 
														  ISNULL(FD.FamilyDetailsName,
                                                              '') <> ''
                                                          AND ISNULL(FD.Address1,
                                                              '') <> ''
                                                          AND ISNULL(FD.Address2,
                                                              '') <> ''
                                                          AND ISNULL(FD.CountryMasterId,
                                                              0) <> 0
                                                          AND ISNULL(FD.PostCode,
                                                              '') <> ''
                                                          AND ISNULL(FD.CountyName,
                                                              '') <> ''
                                                     THEN 25
                                                END
                                       FROM     nan.FamilyDetails AS FD
                                       WHERE    FD.FamilyDetailsId = @FamilDetailsId ),0
                                     );
			SELECT @ProfileCompletion+=ISNULL( (SELECT   CASE WHEN ISNULL(FD.PhoneNumber,
                                                              '') <> ''
                                                          AND ISNULL(FD.Mobile,
                                                              '') <> ''                                                      
                                                          AND ISNULL(FD.NoOfChildren,
                                                              0) <> 0
                                                          AND ISNULL(FD.ChildrenAge1,
                                                              '0') <> '0'
                                                          AND ISNULL(FD.ChildrenGender1,
                                                              -1) <> -1
                                                          AND ISNULL(FD.HaveNanny,
                                                              -1) <> -1
                                                          AND ISNULL(FD.NannyRequired,
                                                              -1) <> -1
															
                                                     THEN 25
                                                END
                                       FROM     nan.FamilyDetails AS FD
                                       WHERE    FD.FamilyDetailsId = @FamilDetailsId),0)

			
			  SELECT  @ProfileCompletion+= ISNULL( ( SELECT   CASE WHEN ISNULL(FD.EthnicityChildMasterId,
                                                              0) <> 0
                                                          AND ISNULL(FD.LanguageMasterId,
                                                              '') <> ''                                                          
                                                     THEN 25
                                                END
                                       FROM     nan.FamilyDetails AS FD
                                       WHERE    FD.FamilyDetailsId = @FamilDetailsId),0
                                     );

				SELECT  @ProfileCompletion+= ISNULL( ( SELECT   CASE WHEN ISNULL(FD.HaveSmoker,
                                                              -1) <> -1
                                                          AND ISNULL(FD.HavePet,
                                                              -1) <> -1
															AND CASE WHEN ISNULL(FD.HavePet,-1)= 1 THEN ISNULL(FD.PetDetails,'') ELSE 'PetDetails' END <>''
															AND ISNULL(FD.Description,'')<>'' 
															AND ISNULL(FD.ProfileImage,'')<>''                                                         
                                                     THEN 25
                                                END
                                       FROM     nan.FamilyDetails AS FD
                                       WHERE    FD.FamilyDetailsId =@FamilDetailsId),0
                                     );
					SELECT @RegisterBy=FD.RegisterBy FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@FamilDetailsId
					
					IF @RegisterBy='google' OR @RegisterBy='facebook'
					BEGIN
					    IF @ProfileCompletion<25
						BEGIN
						    SET @ProfileCompletion=25
						END
					END
					ELSE
					BEGIN
					    IF @ProfileCompletion<50
						BEGIN
						    SET @ProfileCompletion=50
						END
					END					

        IF EXISTS ( SELECT  FS.FamilySubscriptionId
                    FROM    nan.FamilySubscription AS FS
                    WHERE   FS.FamilyDetailsId = @FamilDetailsId
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

            END;
        SELECT  ISNULL(FD.FamilyDetailsId, 0) AS FamilyDetailsId ,
                ISNULL(@IsSubscribed, 0) AS IsSubscribed ,
                ISNULL(FD.Email, '') AS Email ,
				ISNULL(@ProfileCompletion,25) AS ProfileCompletion,
                ISNULL(FD.IsActiveProfilebyAdmin, 0) AS IsActiveProfilebyAdmin ,
                ISNULL(FD.IsActiveProfile, 0) AS IsActiveProfile
        FROM    nan.FamilyDetails AS FD
        WHERE   ISNULL(FD.FamilyDetailsId, 0) = @FamilDetailsId;
    END;