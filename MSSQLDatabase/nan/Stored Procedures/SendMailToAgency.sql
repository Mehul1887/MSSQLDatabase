-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 13-Sep-2017
-- Description:	nan.SendMailToAgency
-- Call SP    :	nan.SendMailToAgency
-- =============================================
CREATE PROCEDURE [nan].[SendMailToAgency]
    @AgencyDetailsId BIGINT,
    @FamilyDetailsId BIGINT,
	@Subject NVARCHAR(200),
	@Description NVARCHAR(MAX)
AS
    BEGIN
        SET NOCOUNT ON;
		DECLARE @templateTitle NVARCHAR(100)='',@BodyText NVARCHAR(MAX)='',@TempleteSubject NVARCHAR(250)='',@EmailFooter NVARCHAR(max)='',@FamilyDetailsName NVARCHAR(100)='',@AgencyDetailsName NVARCHAR(200)='',@FamilyEmail NVARCHAR(100),@AgencyEmail NVARCHAR(100),@EmailLogId BIGINT=0
        	SELECT @EmailFooter=ISNULL(ACS.KeyValue,'') FROM nan.AAAAConfigSettings AS ACS WHERE ISNULL(ACS.KeyName,'')='EmailFooter'  	

			SELECT @FamilyDetailsName=FD.FamilyDetailsName,@FamilyEmail=FD.Email FROM nan.FamilyDetails AS FD WHERE FD.FamilyDetailsId=@FamilyDetailsId
			SELECT @AgencyDetailsName=AD.AgencyDetailsName,@AgencyEmail=AD.Email FROM nan.AgencyDetails AS AD WHERE AD.AgencyDetailsId=@AgencyDetailsId
			 SELECT  
                    @TempleteSubject = MP.Subject ,
                    @BodyText= MP.MailText
            FROM    nan.MailPreferences AS MP
            WHERE   MP.TemplateName = 'Agency Inquiry';

			   SET @BodyText = REPLACE(@BodyText, '##FamilyName##',
                                           @FamilyDetailsName);
				SET @BodyText = REPLACE(@BodyText, '##FamilyEmail##',
                                             @FamilyEmail);
				SET @BodyText = REPLACE(@BodyText, '##AgencyName##',
                                             @AgencyDetailsName);
											 SET @BodyText = REPLACE(@BodyText, '##Description##',
                                             @Description);
				SET @BodyText=CONCAT(@BodyText,@EmailFooter);
				INSERT INTO nan.EmailLog
				        ( RelaventId ,
				          IsFamily ,
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
				VALUES  ( @AgencyDetailsId , -- RelaventId - bigint
				          0 , -- IsFamily - bit
				          CASE WHEN ISNULL(@Subject,'')='' THEN @TempleteSubject ELSE @Subject END, -- Subject - nvarchar(250)
				          @BodyText , -- MailContent - nvarchar(max)
				          @AgencyEmail , -- MailTo - nvarchar(max)
				          N'' , -- CC - nvarchar(max)
				          N'' , -- BCC - nvarchar(max)
				          0 , -- IsSent - bit
				          GETUTCDATE() , -- SentOn - datetime
				          0 , -- IsRead - bit
				          GETUTCDATE() , -- CreatedOn - datetime
				          @FamilyDetailsId , -- CreatedBy - bigint				          
				          0 , -- IsDeleted - bit
				          14  -- PageId - bigint
				        )
				SELECT @EmailLogId= SCOPE_IDENTITY()
				SELECT ISNULL(@EmailLogId,0) AS InsertedId											 
    END;