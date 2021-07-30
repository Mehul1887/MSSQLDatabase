-- =============================================  
-- Author:  <Author,,ADMIN>  
-- Create date: <Create Date,, 24 Apr 2017>  
-- Description: <Description,,GetEthnicityChildMasterAll>  
-- Call SP    : nan.GetEthnicityChildMasterAll  
-- =============================================  
CREATE PROCEDURE [nan].[GetEthnicityChildMasterAll]  
AS  
    BEGIN  
 SET NOCOUNT ON;  
        SELECT  [ECM].[EthnicityChildMasterId] AS EthnicityChildMasterId ,  
                [ECM].[EthnicityChildMasterName] AS EthnicityChildMasterName   
               
        FROM    nan.[EthnicityChildMaster]AS ECM  
        WHERE   [ECM].IsDeleted = 0 order by EthnicityChildMasterName;  
    END;