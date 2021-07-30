-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCountryMasterById>
-- Call SP    :	GetCountryMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetCountryMasterById]
    @CountryMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON 
        SELECT  [CM].[CountryMasterId] AS CountryMasterId ,
                [CM].[CountryMasterName] AS CountryMasterName
        FROM    nan.[CountryMaster] AS CM
        WHERE   [CM].[CountryMasterId] = @CountryMasterId;
    END;