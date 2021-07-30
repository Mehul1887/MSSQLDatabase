-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <05 Sep 2017>
-- Description:	<GetFamilyDetailsByEmail>
-- Call SP    :	nan.GetFamilyDetailsByEmail 'darpan@darpan.com'
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyDetailsByEmail]
   @Email NVARCHAR(100)
AS
    BEGIN
	DECLARE @FamilyDetailsId BIGINT=0,@IsActive BIT =0,@Password NVARCHAR(100)='',@OTPNumber NVARCHAR(20)=''
		IF EXISTS(SELECT FD.FamilyDetailsId FROM nan.FamilyDetails AS FD WHERE ISNULL(FD.IsDeleteProfile,0)=0 AND ISNULL(FD.IsDeleted,0)=0 AND ISNULL(FD.Email,'')=ISNULL(@Email,'') AND ISNULL(FD.Email,'')<>'')
		BEGIN
		    SELECT @FamilyDetailsId=FD.FamilyDetailsId,@IsActive=FD.IsActiveProfile,@Password=FD.Password FROM nan.FamilyDetails AS FD WHERE FD.Email=@Email AND ISNULL(FD.Email,'')<>''	
			IF @IsActive=1 
			BEGIN
					IF(ISNULL(@Password,'')='')
					BEGIN						
						SELECT FD.FamilyDetailsId,
						FD.Email,
						CAST(CONVERT(VARCHAR(10) ,CAST(RAND() * 1000000 AS INT)) AS NVARCHAR(50)) AS Password,
						ISNULL(CAST(1 AS bit),1) AS IsGenerated						
						FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@FamilyDetailsId
					END
					ELSE
					BEGIN
					    SELECT FD.FamilyDetailsId,
						FD.Email,
						FD.Password,
						ISNULL(CAST(0 AS bit),0) AS IsGenerated						
						FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@FamilyDetailsId
					END							
			END
			ELSE
			BEGIN
				SELECT	 CAST(-2 AS BIGINT) AS FamilyDetailsId,					
						 '' AS Email,
						 '' AS Password,
						 ISNULL(CAST(0 AS bit),0) AS IsGenerated		 						
			END											
		END
		ELSE
		BEGIN
		    SELECT	 CAST(-1 AS BIGINT) AS FamilyDetailsId,					
						 '' AS Email,
						 '' AS Password,
						 ISNULL(CAST(0 AS bit),0) AS IsGenerated		 
		END
		
    END;