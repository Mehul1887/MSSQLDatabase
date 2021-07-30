-- =============================================
-- Author:		<Author,,Mitesh>
-- Create date: <Create Date,,31 Aug 2017>
-- Description:	<Description,,SearchAAAACongigSetting>
-- Call SP:		nan.SearchAAAAConfigSettings 55,1,'',''
-- =============================================
CREATE PROCEDURE [nan].[GetAAAACongigSettingById] @Id BIGINT
AS
    BEGIN 
        SET NOCOUNT ON;
        SELECT  Id ,
              KeyName AS KeyName ,
                KeyValue ,
                KeyDescription ,
                Module 
        FROM    nan.AAAAConfigSettings
        WHERE   Id = @Id;
    END;