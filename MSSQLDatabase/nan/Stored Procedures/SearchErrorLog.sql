-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetErrorLogAll>
-- Call SP    :	SearchErrorLog 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchErrorLog]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;
        SET @Search = REPLACE(@Search, '''', '''''');
        DECLARE @Start AS INT ,
            @End INT ,
            @Total INT;

        SET @Start = ( ( @Page - 1 ) * @Rows ) + 1;
        SET @End = @Start + @Rows;

        DECLARE @Parameter_Definition NVARCHAR(MAX) = N' @Count_out int OUTPUT ';
        DECLARE @Sql NVARCHAR(MAX) ,
            @Filter NVARCHAR(MAX) ,
            @Table_Definition NVARCHAR(MAX);

        DECLARE @Result TABLE
            (
              RowNum INT NOT NULL ,
              Id BIGINT NOT NULL ,
              PageId BIGINT NOT NULL ,
              PageName NVARCHAR(MAX) NULL ,
              MethodName NVARCHAR(200) NOT NULL ,
              ErrorType NVARCHAR(MAX) NOT NULL ,
              ErrorMessage NVARCHAR(MAX) NOT NULL ,
              ErrorDetails NVARCHAR(MAX) NULL ,
              ErrorDate DATETIME NOT NULL ,
              UserId BIGINT NOT NULL ,
              UserName NVARCHAR(50) NULL ,
              Solution NVARCHAR(MAX) NULL
            );

        SET @Sql = ' SELECT * FROM ( SELECT ROW_NUMBER() OVER (ORDER BY '
            + @Sort
            + ') as RowNum, * FROM (SELECT  nan.[ErrorLog].[Id] AS Id , nan.[ErrorLog].[PageId] AS PageId , nan.[Page].PageName, nan.[ErrorLog].[MethodName] AS MethodName , nan.[ErrorLog].[ErrorType] AS ErrorType , nan.[ErrorLog].[ErrorMessage] AS ErrorMessage , nan.[ErrorLog].[ErrorDetails] AS ErrorDetails , nan.[ErrorLog].[ErrorDate] AS ErrorDate , nan.[ErrorLog].[UserId] AS UserId, nan.[User].UserName as UserName, nan.[ErrorLog].[Solution] AS Solution ';
        SET @Table_Definition = ' FROM nan.[ErrorLog] 
INNER JOIN nan.[Page] ON nan.[Page].Id = nan.[ErrorLog].PageId
LEFT OUTER JOIN nan.[User] ON nan.[User].Id = nan.[ErrorLog].UserId  WHERE nan.[ErrorLog].IsDeleted = 0 '; 

        SET @Filter = ' AND (  nan.[Page].PageName like ''%' + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[MethodName], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[ErrorType], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[ErrorMessage], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[ErrorDetails], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[ErrorDate], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[UserId], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[ErrorLog].[Solution], '''') like ''%'
            + @Search + '%'
            + '%'' OR ISNULL(nan.[User].[UserName], '''') like ''%' + @Search
            + ')';

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
                    + CONVERT(NVARCHAR(50), @Start) + '  AND R.RowNum < '
                    + CONVERT(NVARCHAR(50), @End) + ' ';
            END;
        SET @Table_Definition = ' SELECT @Count_out = COUNT(*) '
            + @Table_Definition;

        EXEC sp_executesql @Table_Definition, @Parameter_Definition,
            @Count_out = @Total OUTPUT;

        INSERT  INTO @Result
                EXEC ( @Sql
                    );
        SELECT  RowNum ,
                Id ,
                PageId ,
                PageName ,
                MethodName ,
                ErrorType ,
                ErrorMessage ,
                ErrorDetails ,
                ErrorDate ,
                UserId ,
                UserName ,
                Solution ,
                ISNULL(@Total, 0) AS Total
        FROM    @Result;

    END;