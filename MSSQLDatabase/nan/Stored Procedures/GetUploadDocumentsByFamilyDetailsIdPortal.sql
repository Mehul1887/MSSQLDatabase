-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <18 Aug 2017>
-- Description:	<nan.GetUploadDocumentsByFamilyId>
-- Call SP    :	nan.GetUploadDocumentsByFamilyDetailsIdPortal 19
-- =============================================
CREATE PROCEDURE [nan].[GetUploadDocumentsByFamilyDetailsIdPortal]
@FamilyDetailsId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
	DECLARE @APIUrl NVARCHAR(250) = (SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='APIUrl')
        SELECT  [UD].[UploadDocumentsId] AS UploadDocumentsId ,
                [UD].[UploadDocumentsName] AS UploadDocumentsName ,                
                [UD].[DocumentPath] AS ImageName,
				@APIUrl+'Uploads/'+ [UD].[DocumentPath] AS ImageUrl,
				UD.FamilyDetailsId AS FamilyDetailsId
        FROM    nan.[UploadDocuments] AS UD
        WHERE   [UD].IsDeleted = 0
		AND UD.FamilyDetailsId=@FamilyDetailsId
		ORDER BY UploadDocumentsId DESC;
    END;