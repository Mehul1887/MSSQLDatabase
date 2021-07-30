-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetMailBoxAll>
-- Call SP    :	[nan].[GetMailBoxAll]
-- =============================================
CREATE PROCEDURE [nan].[GetMailBoxAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [MB].[MailBoxId] AS MailBoxId ,
                [MB].[MailBoxName] AS MailBoxName ,
				[FD].FamilyDetailsName AS [FROM],
				[FDA].FamilyDetailsName AS [TO],
                [MB].[FromID] AS FromID ,
                [MB].[ToID] AS ToID ,
                [MB].[BodyText] AS BodyText ,
                [MB].[Subject] AS [Subject] ,
                [MB].[IsParent] AS IsParent ,
                [MB].[ParentMailID] AS ParentMailID ,
                [MB].[IsRead] AS IsRead ,
                [MB].[IsTrash] AS IsTrash ,
                [MB].[TrashOn] AS TrashOn ,
                [MB].[MailSentOn] AS MailSentOn,
				[MB].[IsDeleted] AS IsDeleted
        FROM    nan.[MailBox] AS MB
		INNER JOIN nan.[FamilyDetails] AS FD ON [FD].[FamilyDetailsId] = [MB].[FromID] AND [FD].[IsDeleted]=0
		INNER JOIN nan.[FamilyDetails] AS FDA ON [FDA].[FamilyDetailsId] = [MB].[ToID] AND [FDA].[IsDeleted]=0
        WHERE   [MB].IsDeleted = 0 AND [MB].IsTrash = 0;
    END;