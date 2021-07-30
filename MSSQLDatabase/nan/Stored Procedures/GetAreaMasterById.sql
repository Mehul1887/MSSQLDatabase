-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetAreaMasterById>
-- Call SP    :	GetAreaMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetAreaMasterById] @AreaMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        SELECT  [AM].[AreaMasterId] AS AreaMasterId ,
                [AM].[AreaMasterName] AS AreaMasterName ,
                [AM].[CountryMatserId] AS CountryMasterId,
				CM.CountryMasterName AS CountryMasterName
        FROM    nan.[AreaMaster] AS AM
		INNER JOIN nan.CountryMaster AS CM ON CM.CountryMasterId=AM.CountryMatserId
        WHERE   AM.[AreaMasterId] = @AreaMasterId;
    END;