-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetLanguageMasterById>
-- Call SP    :	GetLanguageMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetLanguageMasterById]
    @LanguageMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [LM].[LanguageMasterId] AS LanguageMasterId ,
                [LM].[LanguageMasterName] AS LanguageMasterName
        FROM    nan.[LanguageMaster] AS LM
        WHERE   [LM].[LanguageMasterId] = @LanguageMasterId;
    END;