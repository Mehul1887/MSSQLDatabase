-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyPaymentHistoryAll>
-- Call SP    :	nan.SearchFamilyPaymentHistory 100, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchFamilyPaymentHistory]
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
                FamilyPaymentHistoryId ,
                FamilyPaymentHistoryName ,
                FamilySubscriptionAmount ,
                IsSuccessful ,
                CouponCode ,
                CouponDiscount ,
                FinalAmount ,
                PeriodInDays ,
                PaymentDate ,
                FamilyDetailsName
        FROM    ( SELECT    FPH.FamilyPaymentHistoryId AS FamilyPaymentHistoryId ,
                            FPH.FamilyPaymentHistoryName AS FamilyPaymentHistoryName ,
                            FPH.FamilySubscriptionAmount AS FamilySubscriptionAmount ,
                            FPH.IsSuccessful AS IsSuccessful ,
                            FPH.CouponCode AS CouponCode ,
                            CASE WHEN ISNULL(FPH.CouponDiscount,0)=0 THEN NULL ELSE FPH.CouponDiscount END  AS CouponDiscount ,
                            FPH.FinalAmount AS FinalAmount ,
                            DATEDIFF(DAY, FS.StartDate, FS.EndDate) AS PeriodInDays ,
                            ISNULL(CONVERT(VARCHAR(20), FPH.CreatedOn, 103),
                                   '') AS PaymentDate ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            FD.FamilyDetailsName AS FamilyDetailsName ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'FamilyPaymentHistoryId Asc'
                                                              THEN [FPH].[FamilyPaymentHistoryId]
                                                              ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'FamilyPaymentHistoryId DESC'
                                                              THEN [FPH].[FamilyPaymentHistoryId]
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FamilyPaymentHistoryName Asc'
                                                              THEN [FPH].[FamilyPaymentHistoryName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilyPaymentHistoryName DESC'
                                                              THEN [FPH].[FamilyPaymentHistoryName]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FamilyDetailsName Asc'
                                                              THEN [FD].[FamilyDetailsName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilyDetailsName DESC'
                                                              THEN [FD].[FamilyDetailsName]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'PeriodInDays Asc'
                                                              THEN DATEDIFF(DAY,
                                                              FS.StartDate,
                                                              FS.EndDate)
                                                              ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PeriodInDays DESC'
                                                              THEN DATEDIFF(DAY,
                                                              FS.StartDate,
                                                              FS.EndDate)
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FamilySubscriptionAmount Asc'
                                                              THEN FPH.FamilySubscriptionAmount
                                                              ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilySubscriptionAmount DESC'
                                                              THEN FPH.FamilySubscriptionAmount
                                                              ELSE 0
                                                              END DESC
															 
															  , CASE
                                                              WHEN @Sort = 'CouponCode Asc'
                                                              THEN FPH.CouponCode
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CouponCode DESC'
                                                              THEN FPH.CouponCode
                                                              ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'CouponDiscount Asc'
                                                              THEN FPH.CouponDiscount
                                                              ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CouponDiscount DESC'
                                                              THEN FPH.CouponDiscount
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'PaymentDate Asc'
                                                              THEN ISNULL(CONVERT(VARCHAR(20), FPH.CreatedOn, 103),
                                                              '')
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PaymentDate DESC'
                                                              THEN ISNULL(CONVERT(VARCHAR(20), FPH.CreatedOn, 103),
                                                              '')
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'FinalAmount Asc'
                                                              THEN FPH.FinalAmount
                                                              ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FinalAmount DESC'
                                                              THEN FPH.FinalAmount
                                                              ELSE 0
                                                              END DESC ) AS RowNum
                  FROM      nan.[FamilyPaymentHistory] AS FPH
                            INNER JOIN nan.FamilyDetails AS FD ON FD.FamilyDetailsId = FPH.FamilyDetailsId
                            INNER JOIN nan.FamilySubscription AS FS ON FS.FamilySubscriptionId = FPH.FamilySubscriptionId
                  WHERE     [FPH].IsDeleted = 0
                            AND ISNULL(FPH.IsSuccessful, 0) = 1
                            AND ( ISNULL([FPH].[FamilyPaymentHistoryName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([FD].[FamilyDetailsName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(FPH.CouponCode, '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CONVERT(NVARCHAR(50), DATEDIFF(DAY,
                                                              FS.StartDate,
                                                              FS.EndDate)), '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CONVERT(NVARCHAR(50), FPH.FamilySubscriptionAmount),
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(CONVERT(NVARCHAR(50), FPH.CouponDiscount),
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(ISNULL(CONVERT(VARCHAR(20), FPH.CreatedOn, 103),
                                                   ''), '') LIKE '%' + @Search
                                  + '%'
                                  OR ISNULL(CAST([FPH].[FinalAmount] AS VARCHAR(10)),
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;