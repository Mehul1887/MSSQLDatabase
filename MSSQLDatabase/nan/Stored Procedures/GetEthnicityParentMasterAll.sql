-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetEthnicityParentMasterAll>
-- Call SP    :	GetEthnicityParentMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetEthnicityParentMasterAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [EPM].[EthnicityParentMasterId] AS EthnicityParentMasterId ,
                [EPM].[EthnicityParentMasterName] AS EthnicityParentMasterName
        FROM    nan.[EthnicityParentMaster] AS EPM
        WHERE   [EPM].IsDeleted = 0;
    END;