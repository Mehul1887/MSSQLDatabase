-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetEmailConfigurationAll>
-- Call SP    :	SearchEmailConfiguration 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchEmailConfiguration]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
	SET NOCOUNT ON
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
              ProfileName NVARCHAR(50) NOT NULL ,
              SMPTServer NVARCHAR(50) NOT NULL ,
              UserName NVARCHAR(50) NOT NULL ,
              Password NVARCHAR(50) NOT NULL ,
              Port INT NOT NULL ,
              EnableSSL BIT NOT NULL ,
              DisplayName NVARCHAR(100) NULL
            );

        SET @Sql = ' SELECT * FROM ( SELECT ROW_NUMBER() OVER (ORDER BY '
            + @Sort
            + ') as RowNum, * FROM (SELECT  nan.[EmailConfiguration].[Id] AS Id , nan.[EmailConfiguration].[ProfileName] AS ProfileName , nan.[EmailConfiguration].[SMPTServer] AS SMPTServer , nan.[EmailConfiguration].[UserName] AS UserName , nan.[EmailConfiguration].[Password] AS Password , nan.[EmailConfiguration].[Port] AS Port , nan.[EmailConfiguration].[EnableSSL] AS EnableSSL , nan.[EmailConfiguration].[DisplayName] AS DisplayName ';
        SET @Table_Definition = ' FROM nan.[EmailConfiguration] 
 WHERE nan.[EmailConfiguration].IsDeleted = 0 '; 

        SET @Filter = ' AND ( ISNULL(nan.[EmailConfiguration].[ProfileName], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailConfiguration].[SMPTServer], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailConfiguration].[UserName], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailConfiguration].[Password], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailConfiguration].[Port], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailConfiguration].[EnableSSL], '''') like ''%'
            + @Search
            + '%'' OR ISNULL(nan.[EmailConfiguration].[DisplayName], '''') like ''%'
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
                ProfileName ,
                SMPTServer ,
                UserName ,
                Password ,
                Port ,
                EnableSSL ,
                DisplayName ,
                ISNULL(@Total, 0) AS Total
        FROM    @Result;

    END;