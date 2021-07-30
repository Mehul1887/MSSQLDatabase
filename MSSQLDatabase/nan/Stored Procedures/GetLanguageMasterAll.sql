-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetLanguageMasterAll>
-- Call SP    :	nan.GetLanguageMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetLanguageMasterAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [LM].[LanguageMasterId] AS LanguageMasterId ,
                [LM].[LanguageMasterName] AS LanguageMasterName
        FROM    nan.[LanguageMaster] AS LM
        WHERE   [LM].IsDeleted = 0;
    END;