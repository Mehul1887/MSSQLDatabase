-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 28 Aug 2017>
-- Description:	<nan.GetBlogMasterById>
-- Call SP    :	nan.GetBlogMasterById 17
-- =============================================
CREATE PROCEDURE [nan].[GetBlogMasterById] @Id BIGINT
AS
    BEGIN
	SET NOCOUNT ON;

		DECLARE @APIUrl NVARCHAR(250)
		SELECT @APIUrl =(SELECT ACS.KeyValue FROM nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName='APIUrl')

        SELECT  [BLOG].[Id] AS Id ,
                [BLOG].[BlogTitle] AS BlogTitle ,
                [BLOG].[BlogImagePath] AS BlogImagePath ,
                [BLOG].[BlogDescription] AS BlogDescription,
				CASE WHEN ISNULL([BLOG].[BlogImagePath],'')='' THEN '' ELSE @APIUrl+'UploadBlogs/'+[BLOG].[BlogImagePath] END AS BlogImagePathUrl
        FROM    [nan].[BlogMaster] AS BLOG
        WHERE   [BLOG].[Id] = @Id;
    END;