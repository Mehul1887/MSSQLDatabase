-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetEmailLogAll>
-- Call SP    :	SearchEmailLog 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchEmailLog]
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
              RelaventId BIGINT NULL ,
              ModuleId BIGINT NOT NULL ,
              ModuleName NVARCHAR(MAX) NULL ,
              MailContent NVARCHAR(MAX) NOT NULL ,
              MailTo NVARCHAR(MAX) NOT NULL ,
              CC NVARCHAR(MAX) NULL ,
              BCC NVARCHAR(MAX) NULL ,
              SentOn DATETIME NOT NULL
            );

        SET @Sql = ' SELECT * FROM ( SELECT ROW_NUMBER() OVER (ORDER BY '
            + @Sort
            + ') as RowNum, * FROM (SELECT  nan.[EmailLog].[Id] AS Id , nan.[EmailLog].[RelaventId] AS RelaventId , nan.[EmailLog].[ModuleId] AS ModuleId , nan.[Module].ModuleName, nan.[EmailLog].[MailContent] AS MailContent , nan.[EmailLog].[MailTo] AS MailTo , nan.[EmailLog].[CC] AS CC , nan.[EmailLog].[BCC] AS BCC , nan.[EmailLog].[SentOn] AS SentOn ';
        SET @Table_Definition = ' FROM nan.[EmailLog] 
INNER JOIN nan.[Module] ON nan.[Module].Id = nan.[EmailLog].ModuleId  WHERE nan.[EmailLog].IsDeleted = 0 '; 

        SET @Filter = ' AND ( ISNULL(nan.[EmailLog].[RelaventId], '''') like ''%'
            + @Search + '%'' OR  nan.[Module].ModuleName like ''%' + @Search
            + '%'' OR ISNULL(nan.[EmailLog].[MailContent], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailLog].[MailTo], '''') like ''%'
            + @Search + '%'' OR ISNULL(nan.[EmailLog].[CC], '''') like ''%'
            + @Search + '%'' OR ISNULL(nan.[EmailLog].[BCC], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailLog].[SentOn], '''') like ''%'
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
                RelaventId ,
                ModuleId ,
                ModuleName ,
                MailContent ,
                MailTo ,
                CC ,
                BCC ,
                SentOn ,
                ISNULL(@Total, 0) AS Total
        FROM    @Result;

    END;