-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCMSPageMasterAll>
-- Call SP    :	nan.SearchCMSPageMaster 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchCMSPageMaster]
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
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                CMSPageMasterId ,
                CMSPageMasterName ,
                PageContent ,
                PageMasterId ,
                Title ,
                Keywords ,
                Description
        FROM    ( SELECT    [CMSPageMaster].[CMSPageMasterId] AS CMSPageMasterId ,
                            [CMSPageMaster].[CMSPageMasterName] AS CMSPageMasterName ,
                            [CMSPageMaster].[PageContent] AS PageContent ,
                            [CMSPageMaster].[PageMasterId] AS PageMasterId ,
                            [CMSPageMaster].[Title] AS Title ,
                            [CMSPageMaster].[Keywords] AS Keywords ,
                            [CMSPageMaster].[Description] AS Description ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'CMSPageMasterId Asc'
                                                              THEN [CMSPageMaster].[CMSPageMasterId]
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'CMSPageMasterId DESC'
                                                              THEN [CMSPageMaster].[CMSPageMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'CMSPageMasterName Asc'
                                                              THEN [CMSPageMaster].[CMSPageMasterName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CMSPageMasterName DESC'
                                                              THEN [CMSPageMaster].[CMSPageMasterName]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'PageContent Asc'
                                                              THEN [CMSPageMaster].[PageContent]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PageContent DESC'
                                                              THEN [CMSPageMaster].[PageContent]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'PageMasterId Asc'
                                                              THEN [CMSPageMaster].[PageMasterId]
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PageMasterId DESC'
                                                              THEN [CMSPageMaster].[PageMasterId]
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Title Asc'
                                                              THEN [CMSPageMaster].[Title]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Title DESC'
                                                              THEN [CMSPageMaster].[Title]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Keywords Asc'
                                                              THEN [CMSPageMaster].[Keywords]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Keywords DESC'
                                                              THEN [CMSPageMaster].[Keywords]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Description Asc'
                                                              THEN [CMSPageMaster].[Description]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Description DESC'
                                                              THEN [CMSPageMaster].[Description]
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.[CMSPageMaster]
                  WHERE     [CMSPageMaster].IsDeleted = 0
                            AND ( ISNULL([CMSPageMaster].[CMSPageMasterName],
                                         '') LIKE '%' + @Search + '%'
                                  OR ISNULL([CMSPageMaster].[PageContent],
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL([CMSPageMaster].[PageMasterId],
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL([CMSPageMaster].[Title], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([CMSPageMaster].[Keywords], '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL([CMSPageMaster].[Description],
                                            '') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;