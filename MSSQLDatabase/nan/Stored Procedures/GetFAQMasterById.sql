-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFAQMasterById>
-- Call SP    :	GetFAQMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetFAQMasterById] @FAQMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FAQ].[FAQMasterId] AS FAQMasterId ,
                [FAQ].[FAQMasterName] AS FAQMasterName ,
                [FAQ].[FaqQuestion] AS FaqQuestion ,
                [FAQ].[FaqAnswer] AS FaqAnswer,
				[FAQ].[Sequence] AS SequenceNo,
				[FAQ].[IsActive] AS IsActive

        FROM    nan.[FAQMaster] AS FAQ
        WHERE   [FAQ].[FAQMasterId] = @FAQMasterId;
    END;