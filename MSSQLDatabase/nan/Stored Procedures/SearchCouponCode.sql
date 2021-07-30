-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCouponCodeAll>
-- Call SP    :	nan.SearchCouponCode 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchCouponCode]
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
                CouponCodeId ,
                CouponCodeName ,
                CouponCode ,
                Discount ,
                StartDate ,
                EndDate ,
                Description ,
                TermsCondition,
				IsForAdvert,
				IsActive
        FROM    ( SELECT    [CouponCode].[CouponCodeId] AS CouponCodeId ,
                            [CouponCode].[CouponCodeName] AS CouponCodeName ,
                            [CouponCode].[CouponCode] AS CouponCode ,
                            [CouponCode].[Discount] AS Discount ,							
                           ISNULL(convert(varchar(20),[CouponCode].[StartDate], 103) ,'') AS StartDate ,
                            ISNULL(convert(varchar(20),[CouponCode].EndDate, 103) ,'') AS EndDate ,
                            [CouponCode].[Description] AS Description ,
                            [CouponCode].[TermsCondition] AS TermsCondition ,
							[CouponCode].[IsForAdvert] AS IsForAdvert,
							[CouponCode].[IsActive] AS IsActive,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'CouponCodeId Asc'
                                                              THEN [CouponCode].[CouponCodeId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'CouponCodeId DESC'
                                                              THEN [CouponCode].[CouponCodeId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'CouponCodeName Asc'
                                                              THEN [CouponCode].[CouponCodeName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CouponCodeName DESC'
                                                              THEN [CouponCode].[CouponCodeName]
                                                              ELSE ''
															  END DESC
															  , CASE
                                                              WHEN @Sort = 'IsForAdvert Asc'
                                                              THEN [CouponCode].IsForAdvert
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsForAdvert DESC'
                                                              THEN [CouponCode].[IsForAdvert]
                                                              ELSE ''
															  END DESC
															   , CASE
                                                              WHEN @Sort = 'IsActive Asc'
                                                              THEN [CouponCode].IsActive
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsActive DESC'
                                                              THEN [CouponCode].IsActive
                                                              ELSE ''
															  END DESC
															  , CASE
                                                              WHEN @Sort = 'CouponCode Asc'
                                                              THEN [CouponCode].[CouponCode]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CouponCode DESC'
                                                              THEN [CouponCode].[CouponCode]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Discount Asc'
                                                              THEN [CouponCode].[Discount]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Discount DESC'
                                                              THEN [CouponCode].[Discount]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'StartDate Asc'
                                                              THEN [CouponCode].[StartDate]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'StartDate DESC'
                                                              THEN [CouponCode].[StartDate]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'EndDate Asc'
                                                              THEN [CouponCode].[EndDate]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'EndDate DESC'
                                                              THEN [CouponCode].[EndDate]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Description Asc'
                                                              THEN [CouponCode].[Description]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Description DESC'
                                                              THEN [CouponCode].[Description]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'TermsCondition Asc'
                                                              THEN [CouponCode].[TermsCondition]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'TermsCondition DESC'
                                                              THEN [CouponCode].[TermsCondition]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[CouponCode]
                  WHERE     [CouponCode].IsDeleted = 0
                            AND ( ISNULL([CouponCode].[CouponCodeName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([CouponCode].[CouponCode], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CONVERT(NVARCHAR(50), [CouponCode].[Discount]),
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(convert(varchar(20),[CouponCode].[StartDate], 103) ,'') LIKE '%' + @Search + '%'
                                  OR ISNULL(convert(varchar(20),[CouponCode].[StartDate], 103) ,'') LIKE '%' + @Search + '%'
                                  OR CASE WHEN ISNULL([CouponCode].[IsActive], 0)=0 THEN 'In Active' ELSE 'Active' END LIKE '%'
                                  + @Search + '%'
								  OR CASE WHEN ISNULL([CouponCode].[IsForAdvert], 0)=0 THEN 'No' ELSE 'Yes' END LIKE '%'
                                  + @Search + '%'                               
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;