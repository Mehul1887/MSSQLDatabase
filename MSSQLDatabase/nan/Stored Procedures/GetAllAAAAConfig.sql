-- =============================================
-- Author:		<Author,,Darpan>
-- Create date: <Create Date,, 26 april 2017>
-- Description:	<Description,,GetAllAAAAConfig>
-- Call SP    :	GetAllAAAAConfig
-- =============================================
CREATE PROCEDURE [nan].[GetAllAAAAConfig]
AS
    BEGIN
       SET NOCOUNT ON
        SELECT  [AC].Id ,
                [AC].KeyName ,
                [AC].KeyValue ,
                [AC].KeyDescription ,
                [AC].Module 
        FROM    [nan].AAAAConfigSettings AS AC
        WHERE   ISNULL(AC.IsDeleted, 0) = 0
       
				
    END;