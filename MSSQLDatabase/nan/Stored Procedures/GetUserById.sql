-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetUserById>
-- Call SP    :	nan.GetUserById 1
-- =============================================
CREATE PROCEDURE [nan].[GetUserById] @Id BIGINT
AS 
    BEGIN

        SELECT  u.[Id] AS Id ,
                u.[FirstName] AS FirstName ,
                u.[SurName] AS SurName ,
                u.[MobileNo] AS MobileNo ,
                u.[EmailID] AS EmailID ,
                u.[UserName] AS UserName ,
                u.[Password] AS Password ,
                u.[Address] AS Address ,
                u.[RoleId] AS RoleId ,
                u.[IsActive] AS IsActive ,
                u.[IsLogin] AS IsLogin,
				u.[ProfileImage] AS ProfileImage				
        FROM    [nan].[User] u
        WHERE   u.[Id] = @Id AND ISNULL( u.IsDeleted,0)=0 
		--AND ISNULL(u.IsActive,0)=1
    END