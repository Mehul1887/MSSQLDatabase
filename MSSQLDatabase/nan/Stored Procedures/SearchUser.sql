-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 27 Apr 2017>
-- Description:	<Description,,GetUserAll>
-- Call SP    :	nan.SearchUser 50, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchUser]
    @Rows INT = 0 ,
    @Page INT = 0 ,
    @Search NVARCHAR(500),
    @Sort NVARCHAR(50) 
AS
    BEGIN
       

        IF ( ISNULL(@Sort, '') = '' )
            BEGIN
                SET @Sort = 'ID asc';
            END;
        SET @Search = REPLACE(@Search, '''', '''''');
        DECLARE @Start AS INT ,
            @End INT ,
            @Total INT;

        SET @Start = ( ( @Page - 1 ) * @Rows ) + 1;
        SET @End = @Start * @Rows;

        DECLARE @Parameter_Definition NVARCHAR(MAX) = N' @Count_out int OUTPUT ';
        DECLARE @Sql NVARCHAR(MAX) ,
            @Filter NVARCHAR(MAX) ,
            @Table_Definition NVARCHAR(MAX);

        DECLARE @Result TABLE
            (
              RowNum INT NOT NULL ,
              Id BIGINT NOT NULL ,
              FirstName NVARCHAR(50) NOT NULL ,
              SurName NVARCHAR(50) NOT NULL ,
              MobileNo NVARCHAR(50) NOT NULL ,
              EmailID NVARCHAR(50) NOT NULL ,
              UserName NVARCHAR(50) NOT NULL ,
              Password NVARCHAR(100) NOT NULL ,
              Address NVARCHAR(500) NOT NULL ,
              RoleId BIGINT NOT NULL ,
              RoleName NVARCHAR(MAX) NOT NULL ,
              IsActive BIT NOT NULL ,
              IsLogin BIT NOT NULL ,
              ProfileImage NVARCHAR(500) NULL ,
              UserType NVARCHAR(50) NULL,
			  CompanyId BIGINT NULL
            );

        SET @Sql = ' SELECT * FROM ( SELECT ROW_NUMBER() OVER (ORDER BY '
            + @Sort
            + ') as RowNum, * FROM (SELECT  [nan].[User].[Id] AS Id , [nan].[User].[FirstName] AS FirstName , [nan].[User].[SurName] AS SurName , [nan].[User].[MobileNo] AS MobileNo , [nan].[User].[EmailID] AS EmailID , [nan].[User].[UserName] AS UserName , [nan].[User].[Password] AS Password , [nan].[User].[Address] AS Address , [nan].[User].[RoleId] AS RoleId , [nan].[Role].RoleName, [nan].[User].[IsActive] AS IsActive , [nan].[User].[IsLogin] AS IsLogin,[nan].[User].[ProfileImage] AS ProfileImage,[nan].[User].[UserType] AS UserType,[nan].[User].[CompanyId] AS CompanyId';
        SET @Table_Definition = ' FROM [nan].[User] 
INNER JOIN [nan].[Role] ON [nan].[Role].Id = [nan].[User].RoleId  WHERE [nan].[User].IsDeleted = 0 '; 

        SET @Filter = ' AND ( ISNULL([nan].[User].[FirstName], '''') like ''%'
            + @Search + '%'' OR ISNULL([nan].[User].[SurName], '''') like ''%'
            + @Search
            + '%'' OR ISNULL([nan].[User].[MobileNo], '''') like ''%'
            + @Search + '%'' OR ISNULL([nan].[User].[EmailID], '''') like ''%'
            + @Search
            + '%'' OR ISNULL([nan].[User].[UserName], '''') like ''%'
            + @Search
            + '%'' OR ISNULL([nan].[User].[Password], '''') like ''%'
            + @Search + '%'' OR ISNULL([nan].[User].[Address], '''') like ''%'
            + @Search + '%'' OR  [nan].[Role].RoleName like ''%' + @Search
            + '%'' OR ISNULL([nan].[User].[IsActive], '''') like ''%'
            + @Search + '%'' OR ISNULL([nan].[User].[IsLogin], '''') like ''%'
            + @Search
            + '%'' OR ISNULL([nan].[User].[ProfileImage], '''') like ''%'
            + @Search + '%''OR ISNULL([nan].[User].[UserType], '''') like ''%'
            + @Search + '%''OR ISNULL([nan].[User].[CompanyId], '''') like ''%'
            + @Search + '%'' )';

        IF @Search <> ''
            BEGIN
                SET @Sql += @Table_Definition + @Filter
                    + ') as T) as R WHERE R.RowNum >= '
                    + CONVERT(NVARCHAR(50), @Start) + '  AND R.RowNum < '
                    + CONVERT(NVARCHAR(50), @End) + ' ';
                SET @Table_Definition += @Filter;
            END;
        ELSE
            BEGIN
                SET @Sql += @Table_Definition
                    + ') as T) as R WHERE R.RowNum >= '
                    + CONVERT(NVARCHAR(50), @Start) + '  AND R.RowNum <= '
                    + CONVERT(NVARCHAR(50), @End) + ' ';
            END;
        SET @Table_Definition = ' SELECT @Count_out = COUNT(*) '
            + @Table_Definition;

        PRINT @Sql;
        EXEC sp_executesql @Table_Definition, @Parameter_Definition,
            @Count_out = @Total OUTPUT;

        INSERT  INTO @Result
                EXEC ( @Sql
                    );
        SELECT  RowNum ,
                Id ,
                FirstName ,
                SurName ,
                MobileNo ,
                EmailID ,
                UserName ,
                Password ,
                Address ,
                RoleId ,
                RoleName ,
                IsActive ,
                IsLogin ,
                ProfileImage ,
                UserType ,
				CompanyId,
                ISNULL(@Total, 0) AS Total
        FROM    @Result;

    END;