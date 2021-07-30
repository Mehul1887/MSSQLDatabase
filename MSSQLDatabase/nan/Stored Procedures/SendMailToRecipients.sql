-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 1 may 2017>
-- Description:	<Description,,nan.SendMailToRecipients>
-- Call SP    :	nan.SendMailToRecipients
-- =============================================
create PROCEDURE [nan].[SendMailToRecipients]
    @TemplateTitle AS NVARCHAR(100),    
    @RecordId AS BIGINT ,
    @PageId AS INT,
    @UserId AS INT ,
    @RecipientList NVARCHAR(MAX)
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
								
			 IF(@TemplateTitle = 'New Coupon' )
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
							SELECT 0,
								1,
							@Subject,
							@EmailBody,
							T.Data,
							@EmailBCC,
							@EmailCC,
							@PageId,
							0,
							GETUTCDATE(),
							@UserId,
							0
							FROM  nan.Split(@RecipientList, ',') AS T WHERE ISNULL(@RecipientList,'')<>''							
			END			
    END;