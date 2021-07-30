-- =============================================
-- Author:		Sanjay Chaudhary
-- Create date: 26-Apr-2017
-- Description:	<UpdateAAAAConfigByKeyName>
-- =============================================
CREATE PROCEDURE [nan].[UpdateAAAAConfigByKeyName]
    @KeyName NVARCHAR(500) ,
    @KeyValue NVARCHAR(500)
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  nan.AAAAConfigSettings
        SET     KeyValue = @KeyValue
        WHERE   KeyName = @KeyName;

    END;