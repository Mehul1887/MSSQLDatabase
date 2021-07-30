-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <18 Aug 2017>
-- Description:	<GetFamilyListForMailBoxPortal>
-- Call SP    :	nan.GetFamilyListForMailBoxPortal 45,46
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyListForMailBoxPortal]
    @FamilyDetailsId BIGINT,
	@ToFamilyDetails BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  [FD].[FamilyDetailsId] AS FamilyDetailsId ,
                [FD].[FamilyDetailsName] AS FamilyDetailsName ,
                [FD].[Email] AS Email ,
                [FD].[PhoneNumber] AS PhoneNumber ,
                [FD].[Mobile] AS Mobile
        FROM    nan.[FamilyDetails] AS FD
        WHERE   ISNULL([FD].IsDeleted, 0) = 0
                --AND ISNULL(FD.IsActiveProfile, 0) = 1
                AND ISNULL(FD.IsDeleteProfile, 0) = 0
				--AND CASE WHEN (SELECT COUNT(1) FROM nan.FamilySubscription AS FS WHERE FS.FamilyDetailsId=FD.FamilyDetailsId AND ISNULL(FS.IsDeleted,0)=0 AND CAST(FS.StartDate AS DATE)<= CAST(GETUTCDATE() AS DATE) AND CAST(FS.EndDate AS DATE)>=CAST(GETUTCDATE() AS DATE))>0 THEN 1 ELSE 0 END =1
                AND CASE WHEN ISNULL(@FamilyDetailsId, 0) = 0 THEN 1
                         ELSE FD.FamilyDetailsId
                    END <> ISNULL(@FamilyDetailsId, 0)
     --   ORDER BY FamilyDetailsName ASC ,
             --   Email ASC
			UNION
			SELECT [FD].[FamilyDetailsId] AS FamilyDetailsId ,
                [FD].[FamilyDetailsName] AS FamilyDetailsName ,
                [FD].[Email] AS Email ,
                [FD].[PhoneNumber] AS PhoneNumber ,
                [FD].[Mobile] AS Mobile FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@ToFamilyDetails
				ORDER BY FamilyDetailsName,Email	
    END;