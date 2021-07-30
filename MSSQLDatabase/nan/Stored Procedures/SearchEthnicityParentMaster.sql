-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetEthnicityParentMasterAll>
-- Call SP    :	SearchEthnicityParentMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchEthnicityParentMaster]
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
                EthnicityParentMasterId ,
                EthnicityParentMasterName
        FROM    ( SELECT    [EthnicityParentMaster].[EthnicityParentMasterId] AS EthnicityParentMasterId ,
                            [EthnicityParentMaster].[EthnicityParentMasterName] AS EthnicityParentMasterName ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'EthnicityParentMasterId Asc'
                                                              THEN [EthnicityParentMaster].[EthnicityParentMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'EthnicityParentMasterId DESC'
                                                              THEN [EthnicityParentMaster].[EthnicityParentMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'EthnicityParentMasterName Asc'
                                                              THEN [EthnicityParentMaster].[EthnicityParentMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'EthnicityParentMasterName DESC'
                                                              THEN [EthnicityParentMaster].[EthnicityParentMasterName]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[EthnicityParentMaster]
                  WHERE     [EthnicityParentMaster].IsDeleted = 0
                            AND ( ISNULL([EthnicityParentMaster].[EthnicityParentMasterName],
                                         '') LIKE '%' + @Search + '%' )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;