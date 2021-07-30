-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetDocumentTitleMasterAll>
-- Call SP    :	SearchDocumentTitleMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchDocumentTitleMaster]
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
                DocumentTitleMasterId ,
                DocumentTitleMasterName
        FROM    ( SELECT    [DocumentTitleMaster].[DocumentTitleMasterId] AS DocumentTitleMasterId ,
                            [DocumentTitleMaster].[DocumentTitleMasterName] AS DocumentTitleMasterName ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'DocumentTitleMasterId Asc'
                                                              THEN [DocumentTitleMaster].[DocumentTitleMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'DocumentTitleMasterId DESC'
                                                              THEN [DocumentTitleMaster].[DocumentTitleMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'DocumentTitleMasterName Asc'
                                                              THEN [DocumentTitleMaster].[DocumentTitleMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'DocumentTitleMasterName DESC'
                                                              THEN [DocumentTitleMaster].[DocumentTitleMasterName]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[DocumentTitleMaster]
                  WHERE     [DocumentTitleMaster].IsDeleted = 0
                            AND ( ISNULL([DocumentTitleMaster].[DocumentTitleMasterName],
                                         '') LIKE '%' + @Search + '%' )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;