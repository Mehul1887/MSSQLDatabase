-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetSearchCountAll>
-- Call SP    :	SearchSearchCount 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchSearchCount]
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
                SearchCountId ,
                SearchCountName ,
                AgencyDetailsId ,
                FamilyDetailsId
        FROM    ( SELECT    [SearchCount].[SearchCountId] AS SearchCountId ,
                            [SearchCount].[SearchCountName] AS SearchCountName ,
                            [SearchCount].[AgencyDetailsId] AS AgencyDetailsId ,
                            [SearchCount].[FamilyDetailsId] AS FamilyDetailsId ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'SearchCountId Asc'
                                                              THEN [SearchCount].[SearchCountId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'SearchCountId DESC'
                                                              THEN [SearchCount].[SearchCountId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'SearchCountName Asc'
                                                              THEN [SearchCount].[SearchCountName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'SearchCountName DESC'
                                                              THEN [SearchCount].[SearchCountName]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'AgencyDetailsId Asc'
                                                              THEN [SearchCount].[AgencyDetailsId]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'AgencyDetailsId DESC'
                                                              THEN [SearchCount].[AgencyDetailsId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FamilyDetailsId Asc'
                                                              THEN [SearchCount].[FamilyDetailsId]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilyDetailsId DESC'
                                                              THEN [SearchCount].[FamilyDetailsId]
															  ELSE 0
                                                              END DESC ) AS RowNum
                  FROM      nan.[SearchCount]
                  WHERE     [SearchCount].IsDeleted = 0
                            AND ( ISNULL([SearchCount].[SearchCountName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([SearchCount].[AgencyDetailsId],
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL([SearchCount].[FamilyDetailsId],
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;