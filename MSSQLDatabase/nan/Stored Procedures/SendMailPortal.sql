-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <18 Aug 2017>
-- Description:	<SendMailPortal>
-- Call SP    :	nan.SendMailPortal 4
-- =============================================
CREATE PROCEDURE [nan].[SendMailPortal]
    @MailBoxId BIGINT,
	@FromId BIGINT,
	@ToId BIGINT,
	@IsReply bit,
	@BodyText NVARCHAR(MAX),
	@Subject NVARCHAR(100)
AS
    BEGIN	
    	
       IF ISNULL(@MailBoxId,0)=0
	   BEGIN
	       INSERT INTO nan.MailBox
	               ( MailBoxName ,
	                 FromID ,
	                 ToID ,
	                 BodyText ,
	                 Subject ,
	                 IsParent ,
	                 IsDraft ,
	                 ParentMailID ,
	                 IsRead ,
	                 IsTrash ,                 
	                 MailSentOn ,
	                 CreatedOn ,
	                 CreatedBy ,                
	                 IsDeleted
	               )
	       VALUES  ( N'' , -- MailBoxName - nvarchar(100)
	                 @FromId , -- FromID - bigint
	                 @ToId , -- ToID - bigint
	                 @BodyText , -- BodyText - nvarchar(1000)
	                 @Subject , -- Subject - nvarchar(100)
	                 1 , -- IsParent - bit
	                 0 , -- IsDraft - bit
	                 0 , -- ParentMailID - bigint
	                 0 , -- IsRead - bit
	                 0 , -- IsTrash - bit                 
	                 GETUTCDATE() , -- MailSentOn - datetime
	                 GETUTCDATE() , -- CreatedOn - datetime
	                 @ToId , -- CreatedBy - bigint	                 
	                 0  -- IsDeleted - bit
	               )
				   SELECT @MailBoxId=SCOPE_IDENTITY()
	   END
	   ELSE  IF ISNULL(@MailBoxId,0)>0 AND ISNULL(@IsReply,0)=1
	   BEGIN
	       INSERT INTO nan.MailBox
	               ( MailBoxName ,
	                 FromID ,
	                 ToID ,
	                 BodyText ,
	                 Subject ,
	                 IsParent ,
	                 IsDraft ,
	                 ParentMailID ,
	                 IsRead ,
	                 IsTrash ,                 
	                 MailSentOn ,
	                 CreatedOn ,
	                 CreatedBy ,                
	                 IsDeleted
	               )
	       VALUES  ( N'' , -- MailBoxName - nvarchar(100)
	                 @FromId , -- FromID - bigint
	                 @ToId , -- ToID - bigint
	                 @BodyText , -- BodyText - nvarchar(1000)
	                 @Subject , -- Subject - nvarchar(100)
	                 0 , -- IsParent - bit
	                 0 , -- IsDraft - bit
	                 @MailBoxId , -- ParentMailID - bigint
	                 0 , -- IsRead - bit
	                 0 , -- IsTrash - bit                 
	                 GETUTCDATE() , -- MailSentOn - datetime
	                 GETUTCDATE() , -- CreatedOn - datetime
	                 @ToId , -- CreatedBy - bigint	                 
	                 0  -- IsDeleted - bit
	               )
				   SELECT @MailBoxId=SCOPE_IDENTITY()
	   END
	   ELSE
	   BEGIN
		DECLARE @IsDraft BIT=1;
			SELECT @IsDraft=MB.IsDraft FROM nan.MailBox AS MB WHERE MB.MailBoxId=@MailBoxId
			IF @IsDraft=1
			BEGIN
			    UPDATE nan.MailBox SET FromID=@FromId,ToID=@ToId,BodyText=@BodyText,Subject=@Subject,MailSentOn=GETUTCDATE(),IsDraft=0,IsRead=0 WHERE MailBoxId=@MailBoxId
			END
			ELSE
			BEGIN			    			
			INSERT INTO nan.MailBox
			        ( MailBoxName ,
			          FromID ,
			          ToID ,
			          BodyText ,
			          Subject ,
			          IsParent ,
			          IsDraft ,
			          ParentMailID ,
			          IsRead ,
			          IsTrash ,			 
			          MailSentOn ,
			          CreatedOn ,
			          CreatedBy ,			          
			          IsDeleted
			        )
			VALUES  ( N'' , -- MailBoxName - nvarchar(100)
			          @ToId , -- FromID - bigint
			          @FromId , -- ToID - bigint
			          @BodyText , -- BodyText - nvarchar(1000)
			          @Subject , -- Subject - nvarchar(100)
			          0 , -- IsParent - bit
			          0 , -- IsDraft - bit
			          @MailBoxId , -- ParentMailID - bigint
			          0 , -- IsRead - bit
			          0 , -- IsTrash - bit			          
			          GETUTCDATE() , -- MailSentOn - datetime
			          GETUTCDATE() , -- CreatedOn - datetime
			          @FromId , -- CreatedBy - bigint			          
			          0 -- IsDeleted - bit
			        )
					SELECT @MailBoxId=SCOPE_IDENTITY()
					END
	   END
	   END
	   SELECT ISNULL(@MailBoxId,0) AS InsertedId