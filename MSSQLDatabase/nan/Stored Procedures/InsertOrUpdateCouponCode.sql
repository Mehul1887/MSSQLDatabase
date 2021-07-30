-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateCouponCode>
-- Call SP    :	InsertOrUpdateCouponCode
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateCouponCode]
    @CouponCodeId BIGINT ,
    @CouponCodeName NVARCHAR(100) ,
    @CouponCode NVARCHAR(30) ,
    @Discount DECIMAL(10, 0) ,
    @StartDate DATETIME ,
    @EndDate DATETIME ,
    @Description NVARCHAR(250) ,
    @TermsCondition NVARCHAR(500) ,
    @IsForAdvert BIT ,
    @IsActive BIT ,
	@IsToAll BIT,
	@RecipientList NVARCHAR(MAX),
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @insertedId BIGINT=-9;
        IF EXISTS ( SELECT  CC.CouponCodeId
                    FROM    nan.CouponCode AS CC
                    WHERE   ( CC.CouponCodeName = @CouponCodeName
                              OR CC.CouponCode = @CouponCode
                            )
                            AND CC.CouponCodeId != @CouponCodeId
                            AND ISNULL(CC.IsDeleted, 0) = 0 )
            BEGIN
                SET @insertedId = -1;               
            END;
        ELSE
            BEGIN		
                IF ( @IsActive = 1 )
                    BEGIN	
                        IF EXISTS ( SELECT  CC.CouponCodeId
                                    FROM    nan.CouponCode AS CC
                                    WHERE   ISNULL(CC.IsDeleted, 0) = 0
                                            AND ISNULL(CC.IsActive, 0) = @IsActive
                                            AND CC.CouponCodeId != @CouponCodeId
                                          --  AND ISNULL(CC.IsForAdvert, 0) = @IsForAdvert 
											)
                            BEGIN
                                SET @insertedId = -2;
                                SELECT  ISNULL(@insertedId, -2) AS InsertedId;
                            END;
                        ELSE
                            BEGIN
                                IF ( @CouponCodeId = 0 )
                                    BEGIN
                                        INSERT  INTO nan.[CouponCode]
                                                ( [CouponCodeName] ,
                                                  [CouponCode] ,
                                                  [Discount] ,
                                                  [StartDate] ,
                                                  [EndDate] ,
                                                  [Description] ,
                                                  [TermsCondition] ,
                                                  [IsForAdvert] ,
                                                  [IsActive] ,
                                                  [CreatedOn] ,
                                                  [CreatedBy] ,
                                                  [IsDeleted]
                                                )
                                        VALUES  ( @CouponCodeName ,
                                                  @CouponCode ,
                                                  @Discount ,
                                                  @StartDate ,
                                                  @EndDate ,
                                                  @Description ,
                                                  @TermsCondition ,
                                                  @IsForAdvert ,
                                                  @IsActive ,
                                                  GETUTCDATE() ,
                                                  @UserId ,
                                                  0
                                                );
                                        SELECT  @insertedId = SCOPE_IDENTITY();

										IF ISNULL(@IsToAll,0)=1
										BEGIN										    										
										EXEC nan.CreateEmail @TemplateTitle = N'New Coupon', -- nvarchar(100)
										    @FamilyIdList = N'', -- nvarchar(max)
										    @RecordId = @insertedId, -- bigint
										    @PageId = @PageId, -- int
										    @UserId = @UserId, -- int
										    @AgencyId = 0 -- int
										END
										ELSE
										BEGIN
										    EXEC nan.SendMailToRecipients @TemplateTitle = N'New Coupon', -- nvarchar(100)
										        @RecordId = @insertedId, -- bigint
										        @PageId = @PageId, -- int
										        @UserId = @UserId, -- int
										        @RecipientList = @RecipientList -- nvarchar(max)
										 END
						
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
                                                  'Insert record in table CouponCode' ,
                                                  'CouponCode' ,
                                                  @CouponCodeId ,
                                                  GETUTCDATE() ,
                                                  @UserId ,
                                                  0
                                                );
                                    END;
                                ELSE
                                    BEGIN
                                        UPDATE  CC
                                        SET     [CouponCodeName] = @CouponCodeName ,
                                                [CouponCode] = @CouponCode ,
                                                [Discount] = @Discount ,
                                                [StartDate] = @StartDate ,
                                                [EndDate] = @EndDate ,
                                                [Description] = @Description ,
                                                [TermsCondition] = @TermsCondition ,
                                                [IsForAdvert] = @IsForAdvert ,
                                                [IsActive] = @IsActive ,
                                                [UpdatedOn] = GETUTCDATE() ,
                                                [UpdatedBy] = @UserId
                                        FROM    nan.[CouponCode] AS CC
                                        WHERE   [CouponCodeId] = @CouponCodeId;
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
                                                  'Update record in table CouponCode' ,
                                                  'CouponCode' ,
                                                  @CouponCodeId ,
                                                  GETUTCDATE() ,
                                                  @UserId ,
                                                  0
                                                );
												  SET @insertedId = @CouponCodeId;   
                                    END;
                                          
                            END;
                    END;
                ELSE
                    BEGIN
                        IF ( @CouponCodeId = 0 )
                            BEGIN
                                INSERT  INTO nan.[CouponCode]
                                        ( [CouponCodeName] ,
                                          [CouponCode] ,
                                          [Discount] ,
                                          [StartDate] ,
                                          [EndDate] ,
                                          [Description] ,
                                          [TermsCondition] ,
                                          [IsForAdvert] ,
                                          [IsActive] ,
                                          [CreatedOn] ,
                                          [CreatedBy] ,
                                          [IsDeleted]
                                        )
                                VALUES  ( @CouponCodeName ,
                                          @CouponCode ,
                                          @Discount ,
                                          @StartDate ,
                                          @EndDate ,
                                          @Description ,
                                          @TermsCondition ,
                                          @IsForAdvert ,
                                          @IsActive ,
                                          GETUTCDATE() ,
                                          @UserId ,
                                          0
                                        );
                                SELECT  @insertedId = SCOPE_IDENTITY();
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
                                          'Insert record in table CouponCode' ,
                                          'CouponCode' ,
                                          @CouponCodeId ,
                                          GETUTCDATE() ,
                                          @UserId ,
                                          0
                                        );										
                            END;
                        ELSE
                            BEGIN
                                UPDATE  CC
                                SET     [CouponCodeName] = @CouponCodeName ,
                                        [CouponCode] = @CouponCode ,
                                        [Discount] = @Discount ,
                                        [StartDate] = @StartDate ,
                                        [EndDate] = @EndDate ,
                                        [Description] = @Description ,
                                        [TermsCondition] = @TermsCondition ,
                                        [IsForAdvert] = @IsForAdvert ,
                                        [IsActive] = @IsActive ,
                                        [UpdatedOn] = GETUTCDATE() ,
                                        [UpdatedBy] = @UserId
                                FROM    nan.[CouponCode] AS CC
                                WHERE   [CouponCodeId] = @CouponCodeId;
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
                                          'Update record in table CouponCode' ,
                                          'CouponCode' ,
                                          @CouponCodeId ,
                                          GETUTCDATE() ,
                                          @UserId ,
                                          0
                                        );
							 SET @insertedId = @CouponCodeId;     
                            END;
                                
                    END;
            END;
        SELECT  ISNULL(@insertedId, 0) AS InsertedId;
    END;