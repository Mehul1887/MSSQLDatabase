-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetMailPreferencesAll>
-- Call SP    :	SearchMailPreferences 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchMailPreferences]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
        SET NOCOUNT ON;
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                MailPreferencesId ,
                MailPreferencesName ,
                Description ,
                MailText ,
                IsMail ,
                Subject ,
                PageName ,
                IsActive
        FROM    ( SELECT    [MailPreferences].[MailPreferencesId] AS MailPreferencesId ,
                            [MailPreferences].[MailPreferencesName] AS MailPreferencesName ,
                            [MailPreferences].[Description] AS Description ,
                            [MailPreferences].[MailText] AS MailText ,
                            [MailPreferences].[IsMail] AS IsMail ,
                            [MailPreferences].[Subject] AS Subject ,
                            [MailPreferences].[PageName] AS PageName ,
                            [MailPreferences].[IsActive] AS IsActive ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'MailPreferencesId Asc'
                                                              THEN [MailPreferences].[MailPreferencesId]
                                                              ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'MailPreferencesId DESC'
                                                              THEN [MailPreferences].[MailPreferencesId]
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'MailPreferencesName Asc'
                                                              THEN [MailPreferences].[MailPreferencesName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'MailPreferencesName DESC'
                                                              THEN [MailPreferences].[MailPreferencesName]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Description Asc'
                                                              THEN [MailPreferences].[Description]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Description DESC'
                                                              THEN [MailPreferences].[Description]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'MailText Asc'
                                                              THEN [MailPreferences].[MailText]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'MailText DESC'
                                                              THEN [MailPreferences].[MailText]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsMail Asc'
                                                              THEN [MailPreferences].[IsMail]
                                                              ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsMail DESC'
                                                              THEN [MailPreferences].[IsMail]
                                                              ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Subject Asc'
                                                              THEN [MailPreferences].[Subject]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Subject DESC'
                                                              THEN [MailPreferences].[Subject]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'PageName Asc'
                                                              THEN [MailPreferences].[PageName]
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PageName DESC'
                                                              THEN [MailPreferences].[PageName]
                                                              ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsActive Asc'
                                                              THEN [MailPreferences].IsActive
                                                              ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsActive DESC'
                                                              THEN [MailPreferences].IsActive
                                                              ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[MailPreferences]
                  WHERE     [MailPreferences].IsDeleted = 0
                            AND ( ISNULL([MailPreferences].[MailPreferencesName],
                                         '') LIKE '%' + @Search + '%'
                                  OR ISNULL([MailPreferences].[Description],
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL([MailPreferences].[MailText], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailPreferences].[IsMail], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailPreferences].[Subject], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailPreferences].[PageName], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([MailPreferences].[IsActive], '') LIKE '%'
                                  + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;