-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetEthnicityChildMasterAll>
-- Call SP    :	SearchEthnicityChildMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchEthnicityChildMaster]
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
                EthnicityChildMasterId ,
                EthnicityChildMasterName 
        FROM    ( SELECT    [EthnicityChildMaster].[EthnicityChildMasterId] AS EthnicityChildMasterId ,
                            [EthnicityChildMaster].[EthnicityChildMasterName] AS EthnicityChildMasterName ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'EthnicityChildMasterId Asc'
                                                              THEN [EthnicityChildMaster].[EthnicityChildMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'EthnicityChildMasterId DESC'
                                                              THEN [EthnicityChildMaster].[EthnicityChildMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'EthnicityChildMasterName Asc'
                                                              THEN [EthnicityChildMaster].[EthnicityChildMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'EthnicityChildMasterName DESC'
                                                              THEN [EthnicityChildMaster].[EthnicityChildMasterName]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[EthnicityChildMaster] AS EthnicityChildMaster
                  WHERE     [EthnicityChildMaster].IsDeleted = 0
                            AND ( ISNULL([EthnicityChildMaster].[EthnicityChildMasterName],
                                         '') LIKE '%' + @Search + '%'
                                 
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;