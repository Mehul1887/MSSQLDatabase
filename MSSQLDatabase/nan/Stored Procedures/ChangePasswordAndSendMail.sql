-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 28-Sep-2017
-- Description:	
-- Call SP    :	
-- =============================================
create PROCEDURE [nan].[ChangePasswordAndSendMail]
    @FamilyDetailsId BIGINT,
	@Password NVARCHAR(50),
	@EncryptedPassword NVARCHAR(50)
AS
    BEGIN
	SET NOCOUNT ON
		DECLARE @TempleteId BIGINT=0,@Subject NVARCHAR(250),@EmailBody NVARCHAR(MAX),@EmailBCC NVARCHAR(100),@EmailCC NVARCHAR(100),@EmailHeader NVARCHAR(MAX),@EmailFooter NVARCHAR(MAX);
		DECLARE @FamilyDetailsName NVARCHAR(200)='',@Email NVARCHAR(100)='';
			SELECT @EmailBCC=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailBCC'  	
		SELECT @EmailCC=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailCC'  	
		SELECT @EmailHeader=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailHeader'  	
		SELECT @EmailFooter=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailFooter'  	

        UPDATE nan.FamilyDetails SET Password=@EncryptedPassword,@FamilyDetailsName=FamilyDetailsName,@Email=Email WHERE FamilyDetailsId=@FamilyDetailsId

				 SELECT  @TempleteId = MP.MailPreferencesId ,
				        @Subject = MP.Subject ,
				        @EmailBody = MP.MailText
				FROM    nan.MailPreferences AS MP
				WHERE   MP.TemplateName = 'Forgot Password';
									
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
                    VALUES  ( @FamilyDetailsId ,
								1,
                              @Subject ,
                              @EmailBody ,
                              @Email ,
                              @EmailBCC ,
                              @EmailCC ,
                              23 ,
							  0,
                              GETUTCDATE() ,
                              @FamilyDetailsId ,
                              0 
			                );    

    END;