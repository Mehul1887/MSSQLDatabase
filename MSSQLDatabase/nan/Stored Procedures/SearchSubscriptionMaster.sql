-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetSubscriptionMasterAll>
-- Call SP    :	nan.SearchSubscriptionMaster 50, 1, '', 'SubscriptionMasterName ASC'
-- =============================================
CREATE PROCEDURE [nan].[SearchSubscriptionMaster]
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
                SubscriptionMasterId ,
                SubscriptionMasterName ,
                SubscriptionPeriod ,
                Price,
				IsActive
        FROM    ( SELECT    [SubscriptionMaster].[SubscriptionMasterId] AS SubscriptionMasterId ,
                            [SubscriptionMaster].[SubscriptionMasterName] AS SubscriptionMasterName ,
                            [SubscriptionMaster].[SubscriptionPeriod] AS SubscriptionPeriod ,
                            [SubscriptionMaster].[Price] AS Price ,
							ISNULL([SubscriptionMaster].IsActive,0) AS IsActive,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'SubscriptionMasterId Asc'
                                                              THEN [SubscriptionMaster].[SubscriptionMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'SubscriptionMasterId DESC'
                                                              THEN [SubscriptionMaster].[SubscriptionMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'SubscriptionMasterName Asc'
                                                              THEN [SubscriptionMaster].[SubscriptionMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'SubscriptionMasterName DESC'
                                                              THEN [SubscriptionMaster].[SubscriptionMasterName]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'SubscriptionPeriod Asc'
                                                              THEN [SubscriptionMaster].[SubscriptionPeriod]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'SubscriptionPeriod DESC'
                                                              THEN [SubscriptionMaster].[SubscriptionPeriod]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Price Asc'
                                                              THEN [SubscriptionMaster].[Price]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Price DESC'
                                                              THEN [SubscriptionMaster].[Price]
															  ELSE 0
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'IsActive Asc'
                                                              THEN [SubscriptionMaster].[IsActive]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsActive DESC'
                                                              THEN [SubscriptionMaster].[IsActive]
															  ELSE 0
                                                              END DESC  ) AS RowNum
                  FROM      nan.[SubscriptionMaster]
                  WHERE     [SubscriptionMaster].IsDeleted = 0
                            AND ( ISNULL([SubscriptionMaster].[SubscriptionMasterName],
                                         '') LIKE '%' + @Search + '%'
                                  OR ISNULL([SubscriptionMaster].[SubscriptionPeriod],
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(CONVERT(NVARCHAR(50), [SubscriptionMaster].[Price]),
                                            '') LIKE '%' + @Search + '%'
											OR ISNULL(CASE WHEN ISNULL(IsActive,0)=1 THEN 'Active ' ELSE 'In Active' END,
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;