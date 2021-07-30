-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetAreaMasterAll>
-- Call SP    :		
-- =============================================
CREATE PROCEDURE [nan].[SearchAreaMaster]
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
                AreaMasterId ,
                AreaMasterName ,
                CountryMatserId,
				CountryMasterName
        FROM    ( SELECT    [AreaMaster].[AreaMasterId] AS AreaMasterId ,
                            [AreaMaster].[AreaMasterName] AS AreaMasterName ,
                            [AreaMaster].[CountryMatserId] AS CountryMatserId ,
							[CM].[CountryMasterName] AS CountryMasterName ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'AreaMasterId Asc'
                                                              THEN [AreaMaster].[AreaMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'AreaMasterId DESC'
                                                              THEN [AreaMaster].[AreaMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'AreaMasterName Asc'
                                                              THEN [AreaMaster].[AreaMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'AreaMasterName DESC'
                                                              THEN [AreaMaster].[AreaMasterName]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'CountryMatserId Asc'
                                                              THEN [AreaMaster].[CountryMatserId]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CountryMatserId DESC'
                                                              THEN [AreaMaster].[CountryMatserId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'CountryMasterName Asc'
                                                              THEN CM.CountryMasterName
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CountryMasterName DESC'
                                                              THEN CM.CountryMasterName
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[AreaMaster] AS AreaMaster
							INNER JOIN nan.CountryMaster AS CM ON CM.CountryMasterId= AreaMaster.CountryMatserId
                  WHERE     [AreaMaster].IsDeleted = 0
                            AND ( ISNULL([AreaMaster].[AreaMasterName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([AreaMaster].[CountryMatserId],
                                            '') LIKE '%' + @Search + '%'
											 OR ISNULL([CM].[CountryMasterName],
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;