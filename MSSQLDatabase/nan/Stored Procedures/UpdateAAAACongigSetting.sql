-- =============================================
-- Author:		<Author,,Mitesh>
-- Create date: <Create Date,,31 aug 2017>
-- Description:	<Description,,UpdateAAAACongigSetting>
-- Call SP:		dbo.UpdateAAAACongigSetting
-- =============================================
CREATE PROCEDURE [nan].[UpdateAAAACongigSetting]
    @Id BIGINT ,
    @KeyName NVARCHAR(50) ,
    @KeyValue NVARCHAR(MAX)
AS
    BEGIN
        UPDATE  nan.AAAAConfigSettings
        SET     --KeyName = @KeyName ,
                KeyValue = @KeyValue
        WHERE   Id = @Id;
		SELECT  ISNULL(@Id, 0) AS InsertedId;
    END;