-- =============================================
-- Author:		<Mitesh Rajyaguru>
-- Create date: <05 sept 2017>
-- Description:	<SaveAsDraftPortal>
-- Call SP    :	nan.SaveAsDraftPortal 4
-- =============================================
CREATE PROCEDURE [nan].[SaveAsDraftPortal]
    @MailBoxId BIGINT ,
    @FromId BIGINT ,
    @ToId BIGINT ,
    @BodyText NVARCHAR(MAX) ,
    @Subject NVARCHAR(100)
AS
    BEGIN	
        IF ISNULL(@MailBoxId, 0) = 0
            BEGIN
                INSERT  INTO nan.MailBox
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
                          1 , -- IsDraft - bit
                          0 , -- ParentMailID - bigint
                          0 , -- IsRead - bit
                          0 , -- IsTrash - bit
                          GETUTCDATE() , -- MailSentOn - datetime
                          GETUTCDATE() , -- CreatedOn - datetime
                          @ToId , -- CreatedBy - bigint	                 
                          0  -- IsDeleted - bit
	                    );
                SELECT  @MailBoxId = SCOPE_IDENTITY();
            END;
        ELSE
            BEGIN
                IF EXISTS ( SELECT  MB.MailBoxId
                            FROM    nan.MailBox AS MB
                            WHERE   MB.IsDraft = 1
                                    AND MB.MailBoxId = @MailBoxId )
                    BEGIN
                        UPDATE  nan.MailBox
                        SET     IsDraft = 1 ,
                                FromID = @FromId ,
                                ToID = @ToId ,
                                BodyText = @BodyText ,
                                Subject = @Subject
                        WHERE   MailBoxId = @MailBoxId;
                    END;	   
                ELSE
                    BEGIN		    		
                        INSERT  INTO nan.MailBox
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
                                  1 , -- IsDraft - bit
                                  @MailBoxId , -- ParentMailID - bigint
                                  0 , -- IsRead - bit
                                  0 , -- IsTrash - bit			          
                                  GETUTCDATE() , -- MailSentOn - datetime
                                  GETUTCDATE() , -- CreatedOn - datetime
                                  @FromId , -- CreatedBy - bigint			          
                                  0 -- IsDeleted - bit
			                    );
                        SELECT  @MailBoxId = SCOPE_IDENTITY();
                    END;
            END;
        SELECT  ISNULL(@MailBoxId, 0) AS InsertedId;
    END;