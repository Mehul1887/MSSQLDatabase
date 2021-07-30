-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetDocumentTitleMasterAll>
-- Call SP    :	GetDocumentTitleMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetDocumentTitleMasterAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [DM].[DocumentTitleMasterId] AS DocumentTitleMasterId ,
                [DM].[DocumentTitleMasterName] AS DocumentTitleMasterName
        FROM    nan.[DocumentTitleMaster] AS DM
        WHERE   [DM].IsDeleted = 0;
    END;