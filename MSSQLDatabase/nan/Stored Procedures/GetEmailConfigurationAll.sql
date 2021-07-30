-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetEmailConfigurationAll>
-- Call SP    :	GetEmailConfigurationAll
-- =============================================
CREATE PROCEDURE [nan].[GetEmailConfigurationAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [EC].[Id] AS Id ,
                [EC].[ProfileName] AS ProfileName ,
                [EC].[SMPTServer] AS SMPTServer ,
                [EC].[UserName] AS UserName ,
                [EC].[Password] AS Password ,
                [EC].[Port] AS Port ,
                [EC].[EnableSSL] AS EnableSSL ,
                [EC].[DisplayName] AS DisplayName
        FROM    nan.[EmailConfiguration] AS EC
        WHERE   [EC].IsDeleted = 0;
    END;