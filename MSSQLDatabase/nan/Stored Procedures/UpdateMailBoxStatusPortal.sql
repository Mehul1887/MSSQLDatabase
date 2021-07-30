-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <17 Aug 2017>
-- Description:	<UpdateMailBoxStatusPortal>
-- Call SP    :	nan.UpdateMailBoxStatusPortal
-- =============================================
CREATE PROCEDURE [nan].[UpdateMailBoxStatusPortal]
    @MailBoxIdList NVARCHAR(500) ,
    @UpdateFor NVARCHAR(50) ,
    @FamilyDetailsId BIGINT
AS
    BEGIN
		DECLARE @IsDone BIT=0
        SET NOCOUNT ON; 
        IF @UpdateFor = 'read'
            BEGIN
                UPDATE  nan.MailBox
                SET     IsRead = 1 ,
						@IsDone=1,
                        UpdatedOn = GETUTCDATE() ,
                        UpdatedBy = @FamilyDetailsId
                WHERE   MailBoxId IN ( SELECT   Data
                                       FROM     nan.Split(@MailBoxIdList, ',') );
            END;
        ELSE
            IF @UpdateFor = 'trash'
                BEGIN
                    UPDATE  nan.MailBox
                    SET     IsTrash = 1 ,
							@IsDone=1,
                            TrashOn = GETUTCDATE() ,
                            UpdatedOn = GETUTCDATE() ,
                            UpdatedBy = @FamilyDetailsId
                    WHERE   MailBoxId IN (
                            SELECT  Data
                            FROM    nan.Split(@MailBoxIdList, ',') );
                END
		ELSE IF @UpdateFor='delete'
		BEGIN
		            UPDATE  nan.MailBox
                    SET     IsDeleted = 1 ,
							@IsDone=1,
                            DeletedOn = GETUTCDATE() ,
                            
                            DeletedBy = @FamilyDetailsId
                    WHERE   MailBoxId IN (
                            SELECT  Data
                            FROM    nan.Split(@MailBoxIdList, ',') );
		END
		ELSE IF @UpdateFor='restore'
		BEGIN
		            UPDATE  nan.MailBox
                    SET     IsTrash = 0 ,
							@IsDone=1,
                            DeletedOn = GETUTCDATE() ,
                            
                            DeletedBy = @FamilyDetailsId
                    WHERE   MailBoxId IN (
                            SELECT  Data
                            FROM    nan.Split(@MailBoxIdList, ',') );
		END
			
			SELECT ISNULL(@IsDone,0) AS IsDone
    END;