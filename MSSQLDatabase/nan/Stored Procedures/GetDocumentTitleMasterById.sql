-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetDocumentTitleMasterById>
-- Call SP    :	GetDocumentTitleMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetDocumentTitleMasterById]
    @DocumentTitleMasterId SMALLINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [DM].[DocumentTitleMasterId] AS DocumentTitleMasterId ,
                [DM].[DocumentTitleMasterName] AS DocumentTitleMasterName
        FROM    nan.[DocumentTitleMaster] AS DM
        WHERE   [DM].[DocumentTitleMasterId] = @DocumentTitleMasterId;
    END;