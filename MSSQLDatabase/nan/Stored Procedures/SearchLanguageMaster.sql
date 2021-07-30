-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetLanguageMasterAll>
-- Call SP    :	SearchLanguageMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchLanguageMaster]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
	SET NOCOUNT ON
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                LanguageMasterId ,
                LanguageMasterName
        FROM    ( SELECT    [LanguageMaster].[LanguageMasterId] AS LanguageMasterId ,
                            [LanguageMaster].[LanguageMasterName] AS LanguageMasterName ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'LanguageMasterId Asc'
                                                              THEN [LanguageMaster].[LanguageMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'LanguageMasterId DESC'
                                                              THEN [LanguageMaster].[LanguageMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'LanguageMasterName Asc'
                                                              THEN [LanguageMaster].[LanguageMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'LanguageMasterName DESC'
                                                              THEN [LanguageMaster].[LanguageMasterName]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[LanguageMaster]
                  WHERE     [LanguageMaster].IsDeleted = 0
                            AND ( ISNULL([LanguageMaster].[LanguageMasterName],
                                         '') LIKE '%' + @Search + '%' )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;