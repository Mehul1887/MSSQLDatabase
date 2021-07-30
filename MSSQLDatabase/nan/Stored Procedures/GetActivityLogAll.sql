-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetActivityLogAll>
-- Call SP    :	GetActivityLogAll
-- =============================================
CREATE PROCEDURE [nan].[GetActivityLogAll]
AS
    BEGIN
	SET NOCOUNT ON 
        SELECT  [AL].[Id] AS Id ,
                [AL].[UserId] AS UserId ,
                [U].UserName ,
                [AL].[PageId] AS PageId ,
                [P].PageName ,
                [AL].[AuditComments] AS AuditComments ,
                [AL].[TableName] AS TableName ,
                [AL].[RecordId] AS RecordId
        FROM    nan.[ActivityLog] AS AL
                INNER JOIN nan.[Page] AS P ON [P].Id = [AL].PageId
                INNER JOIN dbo.[User] AS U ON [U].Id = [AL].UserId
        WHERE   [AL].IsDeleted = 0;
    END;