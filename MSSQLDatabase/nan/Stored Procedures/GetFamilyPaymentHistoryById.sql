-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyPaymentHistoryById>
-- Call SP    :	nan.GetFamilyPaymentHistoryById 9
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyPaymentHistoryById]
    @FamilyPaymentHistoryId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FH].[FamilyPaymentHistoryId] AS FamilyPaymentHistoryId ,
                [FH].[FamilyPaymentHistoryName] AS FamilyPaymentHistoryName ,
                [FH].[FamilyDetailsId] AS FamilyDetailsId ,
                [FH].[FamilySubscriptionId] AS FamilySubscriptionId ,
                [FH].[IsSuccessful] AS IsSuccessful ,
                [FH].[CouponCodeId] AS CouponCodeId ,
                [FH].[CouponDiscount] AS CouponDiscount ,
                [FH].[PaymentFailCode] AS PaymentFailCode ,
                [FH].[PaymentFailDescription] AS PaymentFailDescription ,
                [FH].[PaymentTypeId] AS PaymentTypeId ,
                [FH].[ReceiptNumber] AS ReceiptNumber
        FROM    nan.[FamilyPaymentHistory] AS FH
        WHERE   [FH].[FamilyPaymentHistoryId] = @FamilyPaymentHistoryId;
    END;