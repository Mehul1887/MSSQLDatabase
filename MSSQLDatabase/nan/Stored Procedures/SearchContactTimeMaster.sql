-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetContactTimeMasterAll>
-- Call SP    :	SearchContactTimeMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchContactTimeMaster]
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
        SET @End = @Page + @Rows; 
        SELECT  RowNum ,
                Total ,
                ContactTimeMasterId ,
                ContactTimeMasterName ,
                ContactTime
        FROM    ( SELECT    [ContactTimeMaster].[ContactTimeMasterId] AS ContactTimeMasterId ,
                            [ContactTimeMaster].[ContactTimeMasterName] AS ContactTimeMasterName ,
                            [ContactTimeMaster].[ContactTime] AS ContactTime ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'ContactTimeMasterId Asc'
                                                              THEN [ContactTimeMaster].[ContactTimeMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'ContactTimeMasterId DESC'
                                                              THEN [ContactTimeMaster].[ContactTimeMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'ContactTimeMasterName Asc'
                                                              THEN [ContactTimeMaster].[ContactTimeMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ContactTimeMasterName DESC'
                                                              THEN [ContactTimeMaster].[ContactTimeMasterName]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'ContactTime Asc'
                                                              THEN [ContactTimeMaster].[ContactTime]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ContactTime DESC'
                                                              THEN [ContactTimeMaster].[ContactTime]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[ContactTimeMaster]
                  WHERE     [ContactTimeMaster].IsDeleted = 0
                            AND ( ISNULL([ContactTimeMaster].[ContactTimeMasterName],
                                         '') LIKE '%' + @Search + '%'
                                  OR ISNULL([ContactTimeMaster].[ContactTime],
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;