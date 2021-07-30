-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateFamilyPaymentHistory>
-- Call SP    :	InsertOrUpdateFamilyPaymentHistory
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateFamilyPaymentHistory]
    @FamilyPaymentHistoryId BIGINT ,
    @FamilyDetailsId BIGINT ,
    @FamilySubscriptionId BIGINT ,
    @IsSuccessful BIT ,
    @CouponCodeId BIGINT ,
    @PaymentFailCode NVARCHAR(50) ,
    @PaymentFailDescription NVARCHAR(500) ,
    @PaymentTypeId BIGINT ,
    @ReceiptNumber NVARCHAR(50) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @CouponCode NVARCHAR(50)= '' ,
            @CouponDiscount DECIMAL(18, 2)= 0 ,
            @SubscriptionAmount DECIMAL(18, 2)= 0 ,
            @SubscriptionName NVARCHAR(100)= '' ,
            @FinalAmount DECIMAL(18, 2);
        SELECT  @CouponCode = CC.CouponCode ,
                @CouponDiscount = ISNULL(CC.Discount, 0)
        FROM    nan.CouponCode AS CC
        WHERE   CC.CouponCodeId = @CouponCodeId;
        SELECT  @SubscriptionAmount = SM.Price ,
                @SubscriptionName = SM.SubscriptionMasterName
        FROM    nan.FamilySubscription AS FS
                INNER JOIN nan.SubscriptionMaster AS SM ON SM.SubscriptionMasterId = FS.SubscriptionMasterId
        WHERE   FS.FamilySubscriptionId = @FamilySubscriptionId;
        IF ( @CouponCodeId = 0 )
            BEGIN
                SET @CouponCodeId = NULL;
            END;
        SET @FinalAmount = @SubscriptionAmount - ( @SubscriptionAmount
                                                   * @CouponDiscount / 100 );

                INSERT  INTO nan.FamilyPaymentHistory
                        ( FamilyPaymentHistoryName ,
                          FamilyDetailsId ,
                          FamilySubscriptionId ,
                          FamilySubscriptionAmount ,
                          IsSuccessful ,
                          CouponCodeId ,
                          CouponCode ,
                          CouponDiscount ,
                          PaymentFailCode ,
                          PaymentFailDescription ,
                          PaymentTypeId ,
                          ReceiptNumber ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted ,
                          FinalAmount
                        )
                VALUES  ( @SubscriptionName , -- FamilyPaymentHistoryName - nvarchar(100)
                          @FamilyDetailsId , -- FamilyDetailsId - bigint
                          @FamilySubscriptionId , -- FamilySubscriptionId - bigint
                          @SubscriptionAmount , -- FamilySubscriptionAmount - decimal
                          @IsSuccessful , -- IsSuccessful - bit
                          @CouponCodeId , -- CouponCodeId - bigint
                          @CouponCode , -- CouponCode - nvarchar(50)
                          @CouponDiscount , -- CouponDiscount - decimal
                          @PaymentFailCode , -- PaymentFailCode - nvarchar(50)
                          @PaymentFailDescription , -- PaymentFailDescription - nvarchar(500)
                          @PaymentTypeId , -- PaymentTypeId - bigint
                          @ReceiptNumber , -- ReceiptNumber - nvarchar(50)
                          GETUTCDATE() , -- CreatedOn - datetime
                          @FamilyDetailsId , -- CreatedBy - bigint  
                          0 ,
                          @FinalAmount  -- FinalAmount - decimal
                        );
                SELECT  @FamilyPaymentHistoryId = SCOPE_IDENTITY();

                IF ( ISNULL(@FamilyPaymentHistoryId, 0) > 0
                     AND @IsSuccessful = 1
                   )
                    BEGIN
                        UPDATE  nan.FamilySubscription
                        SET     IsDeleted = 0
                        WHERE   FamilySubscriptionId = @FamilySubscriptionId;

						EXEC nan.CreateEmail @TemplateTitle = N'Payment', -- nvarchar(100)
						    @FamilyIdList = N'', -- nvarchar(max)
						    @RecordId =@FamilyPaymentHistoryId, -- bigint
						    @PageId = @PageId, -- int
						    @UserId = @UserId, -- int
						    @AgencyId = 0 -- int
						
                    END;
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Insert record in table FamilyPaymentHistory' ,
                          'FamilyPaymentHistory' ,
                          @FamilyPaymentHistoryId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );

			IF(@FamilyPaymentHistoryId>0 AND @FamilyDetailsId>0)
			BEGIN
			    UPDATE nan.FamilyDetails SET IsActiveProfile=1 WHERE FamilyDetailsId=@FamilyDetailsId
			END
               
            SELECT  ISNULL(@FamilyPaymentHistoryId, 0) AS InsertedId;
    END;