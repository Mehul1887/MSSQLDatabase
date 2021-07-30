-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <26 Apr 2017>
-- Description:	<Get Area By Country Id>
-- Call SP    :	nan.GetAreaMasterByCountryId
-- =============================================
CREATE PROCEDURE [nan].[GetAreaMasterByCountryId] @CountryId BIGINT
AS
    BEGIN
        SELECT  AM.AreaMasterId ,
                AM.AreaMasterName
        FROM    nan.AreaMaster AS AM
        WHERE   AM.CountryMatserId = @CountryId
		AND ISNULL(AM.IsDeleted,0)=0
        ORDER BY AM.AreaMasterName ASC;
    END;