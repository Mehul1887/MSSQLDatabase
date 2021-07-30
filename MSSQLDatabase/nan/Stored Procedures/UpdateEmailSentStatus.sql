-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <02 Sep 2017>
-- Description:	<nan.GetEmailListToSend>
-- Call SP    :	nan.GetEmailListToSend
-- =============================================
CREATE PROCEDURE [nan].[UpdateEmailSentStatus]
    @StrIdList NVARCHAR(MAX)
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE  nan.EmailLog
        SET     IsSent = 1 ,
                SentOn = GETUTCDATE()
        WHERE   Id IN ( SELECT  Data
                        FROM    nan.Split(@StrIdList, ',') );
    END;