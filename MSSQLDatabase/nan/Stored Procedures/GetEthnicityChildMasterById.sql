-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetEthnicityChildMasterById>
-- Call SP    :	GetEthnicityChildMasterById
-- =============================================
CREATE PROCEDURE [nan].[GetEthnicityChildMasterById]
    @EthnicityChildMasterId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [ECM].[EthnicityChildMasterId] AS EthnicityChildMasterId ,
                [ECM].[EthnicityChildMasterName] AS EthnicityChildMasterName
        FROM    nan.[EthnicityChildMaster] AS ECM
        WHERE   [ECM].[EthnicityChildMasterId] = @EthnicityChildMasterId;
    END;