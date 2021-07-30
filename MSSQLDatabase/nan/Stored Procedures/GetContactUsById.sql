-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetContactUsById>
-- Call SP    :	nan.GetContactUsById
-- =============================================
CREATE PROCEDURE [nan].[GetContactUsById] @Id BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  CU.ContactUsId ,
                CU.Name ,
                CU.EmailId ,
                CU.BodyText ,
                CU.Subject ,
                CU.IsRead ,               
				ISNULL(CU.IsReply,0) AS IsReply,
                CU.ReplyText ,
                ISNULL(convert(varchar(20),CU.ReplyOn, 103)+' ' + right(convert(varchar(32),CU.ReplyOn,20),8),'') AS REplyOn ,
                ISNULL(convert(varchar(20),CU.CreatedOn, 103)+' ' + right(convert(varchar(32),CU.CreatedOn,20),8),'') AS ReceivedOn
        FROM    nan.ContactUs AS CU
        WHERE   CU.ContactUsId = @Id;
    END;