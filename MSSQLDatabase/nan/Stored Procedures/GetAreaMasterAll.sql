-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetAreaMasterAll>
-- Call SP    :	GetAreaMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetAreaMasterAll]
AS
    BEGIN
	SET NOCOUNT ON
        SELECT  [AM].[AreaMasterId] AS AreaMasterId ,
                [AM].[AreaMasterName] AS AreaMasterName ,
                [AM].[CountryMatserId] AS CountryMatserId
        FROM    nan.[AreaMaster] AS AM
        WHERE   [AM].IsDeleted = 0;
    END;