-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetMailBoxAll>
-- Call SP    :	nan.SearchMailBox 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchMailBox]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
	SET NOCOUNT ON
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page + @Rows; 
        SELECT  RowNum ,
                Total ,
                MailBoxId ,
                --MailBoxName ,
                FromID ,
                ToID ,
				[MailFrom],
				[MailTo],
				[MailIdFrom],
				[MailIdTo],
				[PhoneNumber],
				[Mobile],
				[Address1],
                BodyText ,
                Subject ,
                IsParent ,
                ParentMailID ,
                IsRead ,
                IsTrash ,
                TrashOn ,
                MailSentOn
        FROM    ( SELECT    [MailBox].[MailBoxId] AS MailBoxId ,
                            [MailBox].[FromID] AS FromID ,
                            [MailBox].[ToID] AS ToID ,
							[FD].[FamilyDetailsName] AS [MailFrom],
							[FDA].[FamilyDetailsName] AS [MailTo],
							[FD].[Email] AS [MailIdFrom],
							[FDA].[Email] AS [MailIdTo],
							[FD].[PhoneNumber] AS [PhoneNumber],
							[FD].[Mobile] AS [Mobile],
							[FD].[Address1] AS [Address1],
                            [MailBox].[BodyText] AS BodyText ,
                            [MailBox].[Subject] AS Subject ,
                            [MailBox].[IsParent] AS IsParent ,
                            [MailBox].[ParentMailID] AS ParentMailID ,
                            [MailBox].[IsRead] AS IsRead ,
                            [MailBox].[IsTrash] AS IsTrash ,
                            [MailBox].[TrashOn] AS TrashOn ,                            
							CONVERT(VARCHAR(10),[MailBox].[MailSentOn],103) + ' ' + CONVERT(VARCHAR(10),[MailBox].[MailSentOn],108) AS MailSentOn,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'MailBoxId Asc'
                                                              THEN [MailBox].[MailBoxId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'MailBoxId DESC'
                                                              THEN [MailBox].[MailBoxId]
															  ELSE 0
                                                              END DESC,
															  CASE
                                                              WHEN @Sort = 'FromID Asc'
                                                              THEN [MailBox].[FromID]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FromID DESC'
                                                              THEN [MailBox].[FromID]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'ToID Asc'
                                                              THEN [MailBox].[ToID]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ToID DESC'
                                                              THEN [MailBox].[ToID]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'BodyText Asc'
                                                              THEN [MailBox].[BodyText]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'BodyText DESC'
                                                              THEN [MailBox].[BodyText]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Subject Asc'
                                                              THEN [MailBox].[Subject]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Subject DESC'
                                                              THEN [MailBox].[Subject]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsParent Asc'
                                                              THEN [MailBox].[IsParent]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsParent DESC'
                                                              THEN [MailBox].[IsParent]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'ParentMailID Asc'
                                                              THEN [MailBox].[ParentMailID]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ParentMailID DESC'
                                                              THEN [MailBox].[ParentMailID]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsRead Asc'
                                                              THEN [MailBox].[IsRead]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsRead DESC'
                                                              THEN [MailBox].[IsRead]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsTrash Asc'
                                                              THEN [MailBox].[IsTrash]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsTrash DESC'
                                                              THEN [MailBox].[IsTrash]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'TrashOn Asc'
                                                              THEN [MailBox].[TrashOn]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'TrashOn DESC'
                                                              THEN [MailBox].[TrashOn]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'MailSentOn Asc'
                                                              THEN [MailBox].[MailSentOn]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'MailSentOn DESC'
                                                              THEN [MailBox].[MailSentOn]
															  ELSE 0
                                                              END DESC ) AS RowNum
                  FROM nan.[MailBox]
										    INNER JOIN nan.[FamilyDetails] AS FD ON [FD].[FamilyDetailsId] = nan.[MailBox].[FromID] AND [FD].[IsDeleted]=0
					    					INNER JOIN nan.[FamilyDetails] AS FDA ON [FDA].[FamilyDetailsId] = nan.[MailBox].[ToID] AND [FDA].[IsDeleted]=0
					        
                  WHERE     [MailBox].IsDeleted = 0 AND [MailBox].IsTrash = 0
                            AND ( ISNULL([MailBox].[MailBoxName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[FromID], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[ToID], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[BodyText], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[Subject], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[IsParent], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[ParentMailID], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[IsRead], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailBox].[IsTrash], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(nan.ChangeDateFormat([MailBox].[TrashOn],
                                                              'yyyy-MM-dd'),
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(nan.ChangeDateFormat([MailBox].[MailSentOn],
                                                              'yyyy-MM-dd'),
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;