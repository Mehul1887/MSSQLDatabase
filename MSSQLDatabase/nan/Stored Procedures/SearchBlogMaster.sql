-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 28 Aug 2017>
-- Description:	<nan.SearchBlogMaster>
-- Call SP    :	nan.SearchBlogMaster 100,1,'',''
-- =============================================
CREATE PROCEDURE [nan].[SearchBlogMaster]
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
                Id ,
                BlogImagePath ,
                BlogTitle 
        FROM    ( SELECT    [nan].[BlogMaster].[Id] AS Id ,
                            [nan].[BlogMaster].[BlogImagePath] AS BlogImagePath ,
                            [nan].[BlogMaster].[BlogTitle] AS BlogTitle ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'Id Asc'
                                                              THEN [BlogMaster].[Id]
                                                              ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'BlogImagePath DESC'
                                                              THEN [BlogMaster].[BlogImagePath]
                                                              ELSE 0
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'BlogTitle DESC'
                                                              THEN [BlogMaster].[BlogTitle]
                                                              ELSE ''
                                                              END DESC,
															  CASE WHEN @Sort=''
															  THEN BlogMaster.Id END ASC) AS RowNum
                  FROM      [nan].[BlogMaster]
                  WHERE     [nan].[BlogMaster].IsDeleted = 0
						AND ( ISNULL([nan].[BlogMaster].[BlogTitle],'') LIKE '%' + @Search + '%')
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;