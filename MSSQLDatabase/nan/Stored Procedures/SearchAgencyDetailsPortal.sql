-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<nan.SearchAgencyDetailsForPortal>
-- Call SP    :	nan.SearchAgencyDetailsPortal '',0,0,'',''
-- =============================================
CREATE PROCEDURE [nan].[SearchAgencyDetailsPortal]
    @PostCode NVARCHAR(20) ,
    @AreaMasterId BIGINT ,
    @Distence BIGINT,
	@Lat NVARCHAR(20),
	@Long NVARCHAR(20),
	@FamilyDetailsId BIGINT
AS
    BEGIN
        SET NOCOUNT ON; 	
			
		--insert into tblLogs values ( @lat,@long,@postcode,@Distence);

		DECLARE @FamilyLate NVARCHAR(50)='',@FamilyLong NVARCHAR(50)=''
		IF ISNULL(@Lat,'')='' AND ISNULL(@Long,'')='' AND ISNULL(@FamilyDetailsId,0)>0
		BEGIN
		    SELECT @Lat=FD.GoogleLat,@Lat=FD.GoogleLong FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@FamilyDetailsId
		END		
        SELECT  AD.AgencyDetailsId AS AgencyDetailsId ,
                ISNULL(AD.AgencyDetailsName,'') AS  AgencyDetailsName,
                ISNULL(AD.Address1,'') AS  Address1,
                ISNULL(AD.Address2,'') AS  Address2,
                ISNULL(AD.GoogleLat,'') AS  GoogleLat,
                ISNULL(AD.GoogleLong,'') AS  GoogleLong,
                ISNULL(AD.AreaId,'') AS AreaId ,
                ISNULL(AD.PostCode,'') AS  PostCode,
                ISNULL(AD.Phone,'') AS Phone ,
                ISNULL(AD.Email,'') AS  Email,
                ISNULL(AD.Website,'') AS Website ,
                CASE WHEN ISNULL(@lat,'')!='' AND ISNULL(@Long,'')!='' THEN ISNULL(nan.fnGetLatLongDistanceMiles(@lat, @Long, AD.GoogleLat, AD.GoogleLong),0) ELSE 0 END AS Distence
        FROM    nan.AgencyDetails AS AD
        WHERE   ISNULL(AD.IsDeleted, 0) = 0
                AND ISNULL(AD.IsActiveProfile, 0) = 1
                AND ISNULL(AD.IsDeleteProfile, 0) = 0
				AND ISNULL(AD.IsProfileReviewed,0)=1
				--AND CASE WHEN ISNULL(@PostCode,'')='' THEN '' ELSE AD.PostCode END=ISNULL(@PostCode,'')
			--	AND CASE WHEN ISNULL(@AreaMasterId,0)=0 THEN 0 ELSE AD.AreaId END=ISNULL(@AreaMasterId,0)
			AND  nan.fnGetLatLongDistanceMiles(@lat,
                                                              @Long,
                                                              AD.GoogleLat,
                                                              AD.GoogleLong)
															 <= ISNULL(@Distence,0) 	
															 order by Distence
				--AND  CASE WHEN ISNULL(@lat,'')!='0' AND ISNULL(@Long,'')!='0' THEN nan.fnGetLatLongDistanceMiles(@lat,
    --                                                          @Long,
    --                                                          AD.GoogleLat,
    --                                                          AD.GoogleLong)
				--											  ELSE 
				--											           ISNULL(@Distence,0)
															       
				--											    END <= ISNULL(@Distence,0) 	
    END;