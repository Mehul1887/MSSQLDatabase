-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetEthnicityParentMasterById>
-- Call SP    :	GetEthnicityParentMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetEthnicityParentMasterById]
    @EthnicityParentMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [EPM].[EthnicityParentMasterId] AS EthnicityParentMasterId ,
                [EPM].[EthnicityParentMasterName] AS EthnicityParentMasterName
        FROM    nan.[EthnicityParentMaster] AS EPM
        WHERE   [EPM].[EthnicityParentMasterId] = @EthnicityParentMasterId;
    END;