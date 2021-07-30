-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCountryMasterAll>
-- Call SP    :	SearchCountryMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchCountryMaster]
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
                CountryMasterId ,
                CountryMasterName
        FROM    ( SELECT    [CountryMaster].[CountryMasterId] AS CountryMasterId ,
                            [CountryMaster].[CountryMasterName] AS CountryMasterName ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'CountryMasterId Asc'
                                                              THEN [CountryMaster].[CountryMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'CountryMasterId DESC'
                                                              THEN [CountryMaster].[CountryMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'CountryMasterName Asc'
                                                              THEN [CountryMaster].[CountryMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CountryMasterName DESC'
                                                              THEN [CountryMaster].[CountryMasterName]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[CountryMaster]
                  WHERE     [CountryMaster].IsDeleted = 0
                            AND ( ISNULL([CountryMaster].[CountryMasterName],
                                         '') LIKE '%' + @Search + '%' )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;