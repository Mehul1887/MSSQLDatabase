-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetContactUsById>
-- Call SP    :	nan.GetContactUsById
-- =============================================
CREATE PROCEDURE [nan].[UpdateContactUsStatus] @Id BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        UPDATE nan.ContactUs SET IsRead=1,UpdatedOn=GETUTCDATE() WHERE ContactUsId=@Id
    END;