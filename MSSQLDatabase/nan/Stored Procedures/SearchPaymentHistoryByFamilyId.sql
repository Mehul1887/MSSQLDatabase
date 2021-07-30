-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <21 Aug 2017>
-- Description:	<SearchPaymentHistoryByFamilyId>
-- Call SP    :	nan.SearchPaymentHistoryByFamilyId 100, 0, '', 'FamilyPayment',24
-- =============================================
CREATE PROCEDURE [nan].[SearchPaymentHistoryByFamilyId]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50),
	@FamilyDetailsId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
              FamilyPaymentHistoryId,
			  FamilyPaymentHistoryName,
			  FamilySubscriptionAmount,
			  IsSuccessful,
			  CouponCode,
			  CouponDiscount,
			  FinalAmount,
			  PeriodInDays,
			  PaymentDate
        FROM    ( SELECT  FPH.FamilyPaymentHistoryId AS FamilyPaymentHistoryId,
		FPH.FamilyPaymentHistoryName AS FamilyPaymentHistoryName,
		FPH.FamilySubscriptionAmount AS FamilySubscriptionAmount,
		FPH.IsSuccessful AS IsSuccessful,
		FPH.CouponCode AS CouponCode,
		FPH.CouponDiscount AS CouponDiscount,
		FPH.FinalAmount AS FinalAmount,
		DATEDIFF(DAY,FS.StartDate,FS.EndDate) AS PeriodInDays,
		ISNULL(convert(varchar(20),FPH.CreatedOn, 103),'') AS PaymentDate,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY FPH.FamilyPaymentHistoryId DESC ) AS RowNum
                 FROM    nan.FamilyPaymentHistory AS FPH
		                INNER JOIN nan.FamilySubscription AS FS ON FS.FamilySubscriptionId = FPH.FamilySubscriptionId							
                  WHERE     [FPH].IsDeleted = 0 AND FPH.FamilyDetailsId=@FamilyDetailsId
				  AND ISNULL(FPH.IsSuccessful,0)=1         					
                ) AS T
				ORDER BY T.FamilyPaymentHistoryId DESC       
    END;