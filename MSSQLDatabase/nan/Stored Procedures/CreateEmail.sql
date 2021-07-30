-- =============================================
-- Author:  <Author,,ADMIN>
-- Create date: <Create Date,, 1 may 2017>
-- Description: <Description,,nan.CreateEmail>
-- Call SP    : nan.CreateEmail 'New Family','9,10',8,1,1,null
-- =============================================
create PROCEDURE [nan].[CreateEmail]
    @TemplateTitle AS NVARCHAR(100),
    @FamilyIdList AS NVARCHAR(MAX) ,
    @RecordId AS BIGINT ,
    @PageId AS INT,
    @UserId AS INT ,
    @AgencyId AS INT = NULL
AS
    BEGIN
        DECLARE @Subject NVARCHAR(500) ,
            @EmailBody NVARCHAR(MAX) ,
            @TempleteId BIGINT ,
            @FamilyName NVARCHAR(50) ,
            @NewFamilyName NVARCHAR(50) ,
            @FamilyEmail NVARCHAR(100) ,
            @Start BIGINT= 1 ,
            @Total BIGINT= 0 ,
            @Id BIGINT= 0,
   @EmailCC NVARCHAR(50),
   @EmailBCC NVARCHAR(50),
   @EmailHeader NVARCHAR(MAX),
   @EmailFooter NVARCHAR(MAX);

  SELECT @EmailBCC=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailBCC'   
  SELECT @EmailCC=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailCC'   
  SELECT @EmailHeader=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailHeader'   
  SELECT @EmailFooter=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailFooter'   



   IF ( @TemplateTitle = 'Welcome Mail' )
   BEGIN
     SELECT  @TempleteId = MP.MailPreferencesId ,
                    @Subject = MP.Subject ,
                    @EmailBody = MP.MailText
            FROM    nan.MailPreferences AS MP
            WHERE   MP.TemplateName = @TemplateTitle;

   DECLARE @NewFamilyEmail NVARCHAR(100)='',@NewFamilyId BIGINT=0
   SELECT  @NewFamilyName = FD.FamilyDetailsName,@NewFamilyEmail=FD.Email
            FROM    nan.FamilyDetails AS FD
            WHERE   FD.FamilyDetailsId = @RecordId;    
   SET @EmailBody = REPLACE(@EmailBody, '##FamilyName##',
                                             @NewFamilyName);
    SET @EmailBody=CONCAT(@EmailHeader,@EmailBody,@EmailFooter);    
    INSERT  INTO nan.EmailLog
                            ( RelaventId ,
        IsFamily,
                              Subject ,
                              MailContent ,
                              MailTo ,
                              BCC ,
                              CC ,
                              PageId ,
                              CreatedOn ,
                              CreatedBy ,
                              IsDeleted
                   )
                    VALUES  ( @NewFamilyId ,
                1,
                              @Subject ,
                              @EmailBody ,
                              @NewFamilyEmail ,
                              @EmailBCC ,
                              @EmailCC ,
                              @PageId ,
                              GETUTCDATE() ,
                              @UserId ,
                              0 
                   );  
   END

           ELSE IF ( @TemplateTitle = 'New Family Register' )
   BEGIN
                DECLARE @Tbl TABLE
                    (
                      Id INT NOT NULL ,
                      Data INT NOT NULL
                    );

   IF(ISNULL(@FamilyIdList,'')!='')
   BEGIN
   INSERT  INTO @Tbl
                    ( Id ,
                      Data
                    )
                    SELECT  Id ,
                            Data
                    FROM    nan.Split(@FamilyIdList, ',');
        END
            SELECT  @NewFamilyName = FD.FamilyDetailsName
            FROM    nan.FamilyDetails AS FD
            WHERE   FD.FamilyDetailsId = @RecordId;    



            SELECT  @Total = COUNT(1)
            FROM    @Tbl;
            WHILE @Start <= @Total
                BEGIN
     SELECT  @TempleteId = MP.MailPreferencesId ,
                    @Subject = MP.Subject ,
                    @EmailBody = MP.MailText
            FROM    nan.MailPreferences AS MP
            WHERE   MP.TemplateName = @TemplateTitle;
                    SELECT  @Id = Data
                    FROM    @Tbl
                    WHERE   Id = @Start;    
                    SELECT  @FamilyName = FD.FamilyDetailsName ,
                            @FamilyEmail = FD.Email
                    FROM    nan.FamilyDetails AS FD
                    WHERE   FD.FamilyDetailsId = @Id;   
                    SET @EmailBody = REPLACE(@EmailBody, '##FamilyName##',
                                             @FamilyName);
                    SET @EmailBody = REPLACE(@EmailBody, '##NewFamilyName##',
                                             @NewFamilyName);
                    --SET @EmailBody = ISNULL(@EmailHeader, '') + @EmailBody
                    --    + ISNULL(@EmailFooter, '');  
     SET @EmailBody=CONCAT(ISNULL(@EmailHeader,''),@EmailBody,ISNULL(@EmailFooter,''));
                    INSERT  INTO nan.EmailLog
                            ( RelaventId ,
        IsFamily,
                              Subject ,
                              MailContent ,
                              MailTo ,
                              BCC ,
                              CC ,
                              PageId ,
                              CreatedOn ,
                              CreatedBy ,
                              IsDeleted
                   )
                    VALUES  ( @Id ,
        1,
                              @Subject ,
                              @EmailBody ,
                              @FamilyEmail ,
                              @EmailBCC ,
                              @EmailCC ,
                              @PageId ,
                              GETUTCDATE() ,
                              @UserId ,
                              0 
                   );    

                    SET @Start += 1;
                END;
    END

   ELSE IF(@TemplateTitle = 'New Coupon' )
   BEGIN

    DECLARE @CouponName NVARCHAR(250)='',@CouponCode NVARCHAR(100)='',@StartDate NVARCHAR(100)='',@EndDate NVARCHAR(100)=''
            SELECT  @TempleteId = MP.MailPreferencesId ,
            @Subject = MP.Subject ,
            @EmailBody = MP.MailText
    FROM    nan.MailPreferences AS MP
    WHERE   MP.TemplateName = @TemplateTitle;


    SELECT @CouponName=CC.CouponCodeName,@CouponCode=CC.CouponCode,@StartDate=ISNULL(convert(varchar(50),CC.StartDate, 106),''),
    @EndDate=ISNULL(convert(varchar(50),CC.EndDate, 106),'') 
     FROM nan.CouponCode AS CC WHERE CC.CouponCodeId=@RecordId

       SET @EmailBody = REPLACE(@EmailBody, '##CouponName##',
                                             @CouponName);
             SET @EmailBody = REPLACE(@EmailBody, '##CouponCode##',
                                             @CouponCode);
             SET @EmailBody = REPLACE(@EmailBody, '##StartDate##',
                                             @StartDate);
             SET @EmailBody = REPLACE(@EmailBody, '##EndDate##',
                                             @EndDate);
      SET @EmailBody=CONCAT(@EmailHeader,@EmailBody,@EmailFooter);
      INSERT  INTO nan.EmailLog
                            ( RelaventId ,
       IsFamily,
                              Subject ,
                              MailContent ,
                              MailTo ,
                              BCC ,
                              CC ,
                              PageId ,
         IsSent,
                              CreatedOn ,
                              CreatedBy ,
                              IsDeleted
                   )
       SELECT FD.FamilyDetailsId,
        1,
       @Subject,
       @EmailBody,
       FD.Email,
       @EmailBCC,
       @EmailCC,
       @PageId,
       0,
       GETUTCDATE(),
       @UserId,
       0
        FROM nan.FamilyDetails AS FD WHERE ISNULL(FD.IsDeleteProfile,0)=0 
        AND ISNULL(FD.IsDeleted,0)=0
        AND ISNULL(FD.IsSubscribeNewsletter,0)=1
         AND ISNULL(FD.IsActiveProfile,1)=1 AND ISNULL(FD.Email,'')<>''                    
   END

   ELSE  IF ( @TemplateTitle = 'Payment' )
   BEGIN
     SELECT  @TempleteId = MP.MailPreferencesId ,
            @Subject = MP.Subject ,
            @EmailBody = MP.MailText
    FROM    nan.MailPreferences AS MP
    WHERE   MP.TemplateName = @TemplateTitle;

    DECLARE @SubscriptionName NVARCHAR(250)='',
    @SubscriptionEndDate NVARCHAR(100)='',
    @SubscriptionPeriod NVARCHAR(10)='',
    @TotalAmount NVARCHAR(20)='',
    @FamilyDetailsId BIGINT=0

    SELECT @TotalAmount=CAST(FPH.FinalAmount AS NVARCHAR(20)),
         @SubscriptionName=FPH.FamilyPaymentHistoryName,
         @SubscriptionEndDate=ISNULL(convert(varchar(50),FS.EndDate, 106),''),
         @SubscriptionPeriod = CAST(DATEDIFF(DAY,FS.StartDate,FS.EndDate) AS NVARCHAR(20)),
         @FamilyDetailsId = FS.FamilyDetailsId,
         @FamilyEmail=FD.Email
       FROM nan.FamilyPaymentHistory AS FPH 
       INNER JOIN nan.FamilySubscription AS FS ON FS.FamilySubscriptionId = FPH.FamilySubscriptionId
       INNER JOIN nan.FamilyDetails AS FD ON FD.FamilyDetailsId = FPH.FamilyDetailsId
        WHERE FPH.FamilyPaymentHistoryId=@RecordId


        SET @EmailBody = REPLACE(@EmailBody, '##SubscriptionName##',
                                             @SubscriptionName);

         SET @EmailBody = REPLACE(@EmailBody, '##SubscriptionPeriod##',
                                @SubscriptionPeriod);
         SET @EmailBody = REPLACE(@EmailBody, '##TotalAmount##',
                                @TotalAmount);
         SET @EmailBody = REPLACE(@EmailBody, '##SubscriptionEndDate## ',
                             @SubscriptionEndDate);

      SET @EmailBody=CONCAT(@EmailHeader,@EmailBody,@EmailFooter);
       INSERT  INTO nan.EmailLog
                            ( RelaventId ,
        IsFamily,
                              Subject ,
                              MailContent ,
                              MailTo ,
                              BCC ,
                              CC ,
                              PageId ,
         IsSent,
                              CreatedOn ,
                              CreatedBy ,
                              IsDeleted
                   )
                    VALUES  ( @FamilyDetailsId ,
        1,
                              @Subject ,
                              @EmailBody ,
                              @FamilyEmail ,
                              @EmailBCC ,
                              @EmailCC ,
                              @PageId ,
         0,
                              GETUTCDATE() ,
                              @UserId ,
                              0 
                   );    
   END

   ELSE  IF ( @TemplateTitle = 'Contact Us' )
   BEGIN
   DECLARE @EmailId NVARCHAR(100),@ReplyText NVARCHAR(MAX),@ReplySubject NVARCHAR(200)=''
       SELECT @EmailId=CU.EmailId,@ReplyText=CU.ReplyText,@ReplySubject=CU.Subject FROM nan.ContactUs AS CU WHERE CU.ContactUsId=@RecordId
    SELECT @FamilyDetailsId=FD.FamilyDetailsId FROM nan.FamilyDetails AS FD WHERE FD.Email=@EmailId
   SET @ReplyText=CONCAT(@EmailHeader,@ReplyText,@EmailFooter);
    INSERT INTO nan.EmailLog
            ( RelaventId ,
       IsFamily,
              Subject ,
              MailContent ,
              MailTo ,
              CC ,
              BCC ,
              IsSent ,
              SentOn ,
              IsRead ,
              CreatedOn ,
              CreatedBy ,              
              IsDeleted ,
              PageId
            )
    VALUES  ( @FamilyDetailsId, -- RelaventId - bigint
       1,
              @ReplySubject , -- Subject - nvarchar(250)
              @ReplyText , -- MailContent - nvarchar(max)
              @EmailId , -- MailTo - nvarchar(max)
              N'' , -- CC - nvarchar(max)
              N'' , -- BCC - nvarchar(max)
              0 , -- IsSent - bit
              GETUTCDATE() , -- SentOn - datetime
              0 , -- IsRead - bit
              GETUTCDATE() , -- CreatedOn - datetime
              @UserId , -- CreatedBy - bigint              
              0 , -- IsDeleted - bit
              @PageId  -- PageId - bigint
            )
   END

   ELSE  IF ( @TemplateTitle = 'Forgot Password' )
   BEGIN
     SELECT  @TempleteId = MP.MailPreferencesId ,
            @Subject = MP.Subject ,
            @EmailBody = MP.MailText
    FROM    nan.MailPreferences AS MP
    WHERE   MP.TemplateName = @TemplateTitle;
    DECLARE @FamilyDetailsName NVARCHAR(200)='',@Email NVARCHAR(100)='',@Password NVARCHAR(100)=''
     SELECT @FamilyDetailsName=FD.FamilyDetailsName,@Email=FD.Email,@Password=FD.Password FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@RecordId


       SET @EmailBody = REPLACE(@EmailBody, '##FamilyName##',
                             @FamilyDetailsName);
         SET @EmailBody = REPLACE(@EmailBody, '##Password##',
                             @Password);

      SET @EmailBody=CONCAT(@EmailHeader,@EmailBody,@EmailFooter);

       INSERT  INTO nan.EmailLog
                            ( RelaventId ,
        IsFamily,
                              Subject ,
                              MailContent ,
                              MailTo ,
                              BCC ,
                              CC ,
                              PageId ,
         IsSent,
                              CreatedOn ,
                              CreatedBy ,
                              IsDeleted
                   )
                    VALUES  ( @RecordId ,
        1,
                              @Subject ,
                              @EmailBody ,
                              @Email ,
                              @EmailBCC ,
                              @EmailCC ,
                              @PageId ,
         0,
                              GETUTCDATE() ,
                              @UserId ,
                              0 
                   );    
    END
    END;