-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFAQMasterAll>
-- Call SP    :	nan.SearchFAQMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchFAQMaster]
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
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                FAQMasterId ,
                FAQMasterName ,
                FaqQuestion ,
                FaqAnswer,
				SequenceNo,
				IsActive
        FROM    ( SELECT    [FAQMaster].[FAQMasterId] AS FAQMasterId ,
                            [FAQMaster].[FAQMasterName] AS FAQMasterName ,
                            [FAQMaster].[FaqQuestion] AS FaqQuestion ,
                            [FAQMaster].[FaqAnswer] AS FaqAnswer ,
							ISNULL([FAQMaster].[Sequence],0) AS SequenceNo ,
							[FAQMaster].[IsActive] AS IsActive ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'FAQMasterId Asc'
                                                              THEN [FAQMaster].[FAQMasterId]
                                                              ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'FAQMasterId DESC'
                                                              THEN [FAQMaster].[FAQMasterId]
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FAQMasterName Asc'
                                                              THEN [FAQMaster].[FAQMasterName]
                                                              ELSE ''
                                                              END ASC
															  , CASE
                                                              WHEN @Sort = 'FAQMasterName DESC'
                                                              THEN [FAQMaster].[FAQMasterName]
                                                              ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'Sequence Asc'
                                                              THEN [Sequence]
                                                              ELSE 0
                                                              END ASC
															  , CASE
                                                              WHEN @Sort = 'Sequence DESC'
                                                              THEN [Sequence]
                                                              ELSE 0
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'IsActive Asc'
                                                              THEN IsActive
                                                              ELSE 0
                                                              END ASC
															  , CASE
                                                              WHEN @Sort = 'IsActive DESC'
                                                              THEN IsActive
                                                              ELSE 0
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'FaqQuestion Asc'
                                                              THEN [FAQMaster].[FaqQuestion]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FaqQuestion DESC'
                                                              THEN [FAQMaster].[FaqQuestion]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FaqAnswer Asc'
                                                              THEN [FAQMaster].[FaqAnswer]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FaqAnswer DESC'
                                                              THEN [FAQMaster].[FaqAnswer]
                                                              ELSE ''
                                                              END DESC,
															  CASE WHEN @Sort=''
															  THEN FAQMaster.Sequence END ASC) AS RowNum
                  FROM      nan.[FAQMaster]
                  WHERE     [FAQMaster].IsDeleted = 0
                            AND (
							CASE WHEN ISNULL(IsActive,0)=0 THEN 'In Active' ELSE 'Active' END LIKE '%'
                                 + @Search + '%'
                                  OR 
								  ISNULL([FAQMaster].[FaqQuestion], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CAST(Sequence AS VARCHAR(10)), '') LIKE '%'
                                  + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;