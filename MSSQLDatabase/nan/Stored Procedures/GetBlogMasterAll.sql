-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 28 Aug 2017>
-- Description:	<nan.GetBlogMasterAll>
-- Call SP    :	nan.GetBlogMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetBlogMasterAll]
AS
    BEGIN
	DECLARE @APIUrl NVARCHAR(250)
		SELECT @APIUrl =(SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='APIUrl')

	SET NOCOUNT ON;
        SELECT  [BLOG].[Id] AS Id ,
                [BLOG].[BlogTitle] AS BlogTitle ,
                CASE WHEN ISNULL([BLOG].[BlogImagePath],'')='' THEN '' ELSE @APIUrl+'UploadBlogs/'+[BLOG].[BlogImagePath] END AS BlogImagePath ,
                LEFT([BLOG].[BlogDescription],150) AS BlogDescription
        FROM    [nan].[BlogMaster] AS BLOG
        WHERE   [BLOG].IsDeleted = 0;
    END;