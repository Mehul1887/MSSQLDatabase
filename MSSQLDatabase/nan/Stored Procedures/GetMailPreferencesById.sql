-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetMailPreferencesById>
-- Call SP    :	GetMailPreferencesById
-- =============================================
CREATE PROCEDURE [nan].[GetMailPreferencesById]
    @MailPreferencesId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        SELECT  [MP].[MailPreferencesId] AS MailPreferencesId ,
                [MP].[MailPreferencesName] AS MailPreferencesName ,
                [MP].[Description] AS Description ,
                [MP].[MailText] AS MailText ,
                [MP].[IsMail] AS IsMail ,
                [MP].[Subject] AS Subject ,
                [MP].[PageName] AS PageName ,
                [MP].IsActive AS IsActive
        FROM    nan.[MailPreferences] AS MP
        WHERE   [MP].[MailPreferencesId] = @MailPreferencesId;
    END;