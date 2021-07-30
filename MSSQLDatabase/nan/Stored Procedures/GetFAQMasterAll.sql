-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFAQMasterAll>
-- Call SP    :	GetFAQMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetFAQMasterAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FAQ].[FAQMasterId] AS FAQMasterId ,
                [FAQ].[FAQMasterName] AS FAQMasterName ,
                [FAQ].[FaqQuestion] AS FaqQuestion ,
                [FAQ].[FaqAnswer] AS FaqAnswer
        FROM    nan.[FAQMaster] AS FAQ
        WHERE   [FAQ].IsDeleted = 0
			AND	[FAQ].IsActive = 1
		ORDER BY [FAQ].Sequence
    END;