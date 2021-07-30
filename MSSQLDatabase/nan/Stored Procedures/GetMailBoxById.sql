-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetMailBoxById>
-- Call SP    :	nan.GetMailBoxById 1
-- =============================================
CREATE PROCEDURE [nan].[GetMailBoxById] @MailBoxId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;	
        SELECT  [MB].[MailBoxId] AS MailBoxId ,
                [MB].[MailBoxName] AS MailBoxName ,
                [MB].[FromID] AS FromID ,
                [MB].[ToID] AS ToID ,
                [FD].[FamilyDetailsName] AS [MailFrom] ,			
				FD.FamilyDetailsName AS FromFamilyDetailsName,
                [FDA].[FamilyDetailsName] AS [MailTo] ,
				FDA.FamilyDetailsName AS ToFamilyDetailsName,
				[FD].[Email] AS [MailIdFrom],
				[FDA].[Email] AS [MailIdTo],
                [FD].[PhoneNumber] AS [PhoneNumber] ,
                [FD].[Mobile] AS [Mobile] ,
                [FD].[Address1] AS [Address1] ,
                [MB].[BodyText] AS BodyText ,
                [MB].[Subject] AS Subject ,
                [MB].[IsParent] AS IsParent ,
                [MB].[ParentMailID] AS ParentMailID ,
                [MB].[IsRead] AS IsRead ,
                [MB].[IsTrash] AS IsTrash ,
                [MB].[TrashOn] AS TrashOn ,
                [MB].[MailSentOn] AS MailSentOn				
        FROM    nan.[MailBox] AS MB
                INNER JOIN nan.[FamilyDetails] AS FD ON [FD].[FamilyDetailsId] = [MB].[FromID]
                                                        AND [FD].[IsDeleted] = 0
                INNER JOIN nan.[FamilyDetails] AS FDA ON [FDA].[FamilyDetailsId] = [MB].[ToID]
                                                         AND [FDA].[IsDeleted] = 0
        WHERE   [MB].[MailBoxId] = @MailBoxId             
    END;