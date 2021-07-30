-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <02 Sep 2017>
-- Description:	<nan.GetEmailListToSend>
-- Call SP    :	nan.GetEmailListToSend
-- =============================================
CREATE PROCEDURE [nan].[GetEmailListToSend]
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  EL.Id,
				EL.RelaventId AS RelaventId,
				EL.Subject AS Subject ,
                EL.MailContent AS MailContent,
				EL.MailTo AS MailTo
        FROM    nan.EmailLog AS EL
				WHERE ISNULL(EL.IsSent,0)=0 AND ISNULL(EL.IsDeleted,0)=0                
    END;