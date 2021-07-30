-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCountryMasterAll>
-- Call SP    :	GetCountryMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetCountryMasterAll]
AS
    BEGIN
        SELECT  [CM].[CountryMasterId] AS CountryMasterId ,
                [CM].[CountryMasterName] AS CountryMasterName
        FROM    nan.[CountryMaster] AS CM
        WHERE   [CM].IsDeleted = 0;
    END;