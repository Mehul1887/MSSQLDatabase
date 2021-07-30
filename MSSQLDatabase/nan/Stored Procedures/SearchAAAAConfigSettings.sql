-- =============================================
-- Author:		<Author,,Mitesh>
-- Create date: <Create Date,,31 Aug 2017>
-- Description:	<Description,,SearchAAAACongigSetting>
-- Call SP:		nan.SearchAAAAConfigSettings 55,1,'',''
-- =============================================
CREATE PROCEDURE [nan].[SearchAAAAConfigSettings]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page + @Rows; 
        SELECT  RowNum ,
                Total ,
                Id ,
                KeyName ,
                KeyValue ,
                Module
        FROM    ( SELECT    AAAA.Id AS Id ,
                            AAAA.KeyName AS KeyName ,
                              CASE WHEN AAAA.KeyName = 'IsFree'
                                 THEN( CASE WHEN AAAA.KeyValue = '1'
                                           THEN 'Yes'
                                           ELSE 'No'
                                      END)
                                 ELSE AAAA.KeyValue
                            END AS KeyValue ,
                            AAAA.Module AS Module ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'Id ASC'
                                                              THEN AAAA.Id
                                                              ELSE 0
                                                         END ASC , CASE
                                                              WHEN @Sort = 'Id DESC'
                                                              THEN AAAA.Id
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'KeyName ASC'
                                                              THEN AAAA.KeyName
                                                              ELSE ''
                                                              END ASC , CASE
                                                              WHEN @Sort = 'KeyName DESC'
                                                              THEN AAAA.KeyName
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'KeyValue ASC'
                                                              THEN AAAA.KeyValue
                                                              ELSE ''
                                                              END ASC , CASE
                                                              WHEN @Sort = 'KeyValue DESC'
                                                              THEN AAAA.KeyValue
                                                              ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.AAAAConfigSettings AAAA
                  WHERE     AAAA.IsDeleted = 0
                            AND AAAA.IsShow = 1
                            AND AAAA.IsActive = 1
                            AND ( ISNULL(AAAA.KeyName, '') LIKE '%' + @Search
                                  + '%'
                                  OR ISNULL(AAAA.KeyValue, '') LIKE '%'
                                  + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
		        
    END;