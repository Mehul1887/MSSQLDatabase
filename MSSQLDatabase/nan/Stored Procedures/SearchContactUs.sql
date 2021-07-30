-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetContactUsAll>
-- Call SP    :	nan.SearchContactUs 1, 1, '', 'id ASC'
-- =============================================
CREATE PROCEDURE [nan].[SearchContactUs]
  @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50),
	@Status INT,
	@IsPayroll BIT
AS
    BEGIN
		SET NOCOUNT ON
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
				ContactUsId,
				ContactUsName,
				Name,
				EmailId,
				ContactNo,
				Subject,
				BodyText,
				IsRead,
				IsReply,
				ReplyText,
				ReplyOn,
				CreatedOn
        FROM    ( SELECT    
							CU.ContactUsId,
							CU.ContactUsName,
							CU.Name,
							CU.EmailId,
							CU.Subject,
							CU.BodyText,
							CU.ContactNo,
							CU.IsRead,
							CU.IsReply,
							CU.ReplyText,							
							 ISNULL(convert(varchar(20),CU.ReplyOn, 103)+' ' + right(convert(varchar(32),CU.ReplyOn,100),8),'') AS ReplyOn ,
                ISNULL(convert(varchar(20),CU.CreatedOn, 103)+' ' + right(convert(varchar(32),CU.CreatedOn,100),8),'') AS CreatedOn,
						
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY CASE WHEN @Sort = 'ContactUsId Asc'
                                                              THEN CU.ContactUsId
															  ELSE 0
                                                         END ASC, CASE
                                                              WHEN @Sort = 'ContactUsId DESC'
                                                              THEN CU.ContactUsId
															  ELSE 0
                                                              END DESC, CASE
                                                              WHEN @Sort = 'ContactUsName Asc'
                                                              THEN CU.ContactUsName
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ContactUsName DESC'
                                                              THEN CU.ContactUsName
                                                              ELSE ''
															  END DESC, CASE
                                                              WHEN @Sort = 'Name Asc'
                                                              THEN CU.Name
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Name DESC'
                                                              THEN CU.Name
															  ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'ContactNo Asc'
                                                              THEN CU.ContactNo
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ContactNo DESC'
                                                              THEN CU.ContactNo
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'EmailId Asc'
                                                              THEN CU.EmailId
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'EmailId DESC'
                                                              THEN CU.EmailId
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'Subject Asc'
                                                              THEN CU.[Subject]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'Subject DESC'
                                                              THEN CU.[Subject]
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'BodyText Asc'
                                                              THEN CU.BodyText
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'BodyText DESC'
                                                              THEN CU.BodyText
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsRead Asc'
                                                              THEN CU.IsRead
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsRead DESC'
                                                              THEN cu.IsRead
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'IsReply Asc'
                                                              THEN CU.IsReply
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'IsReply DESC'
                                                              THEN CU.IsReply
															  ELSE ''
                                                              END DESC, CASE
                                                              WHEN @Sort = 'ReplyText Asc'
                                                              THEN CU.ReplyText
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ReplyText DESC'
                                                              THEN CU.ReplyText
															  ELSE ''
                                                              END DESC
															  
															  , CASE
                                                              WHEN @Sort = 'ReplyOn Asc'
                                                              THEN CU.ReplyOn
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'ReplyOn DESC'
                                                              THEN CU.ReplyOn
															  ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'CreatedOn Asc'
                                                              THEN CU.CreatedOn
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'CreatedOn DESC'
                                                              THEN CU.CreatedOn
															  ELSE ''
                                                              END DESC ) AS RowNum
                  FROM      nan.ContactUs AS CU
                  WHERE     [CU].IsDeleted = 0
							AND CASE WHEN ISNULL(@Status,-1)=-1 THEN -1 ELSE CU.IsRead END = ISNULL(@Status,0)
							AND ISNULL(CU.IsPayroll,0)= ISNULL(@IsPayroll,0)
                            AND ( ISNULL(CU.ContactUsName,
                                         '') LIKE '%' + @Search + '%'
                                  OR ISNULL(CU.Name, '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CU.EmailId, '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CU.Subject,
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(CU.ContactNo,
                                            '') LIKE '%' + @Search + '%'
                                 
                                  OR ISNULL(CU.ReplyOn, '') LIKE '%'
                                  + @Search + '%'
                                  OR ISNULL(CU.CreatedOn, '') LIKE '%'
                                  + @Search + '%'
                               
                                  OR  ISNULL(convert(varchar(20),CU.ReplyOn, 103)+' ' + right(convert(varchar(32),CU.ReplyOn,100),8),'') 
                 LIKE '%' + @Search + '%'
											 OR ISNULL(convert(varchar(20),CU.CreatedOn, 103)+' ' + right(convert(varchar(32),CU.CreatedOn,100),8),'') LIKE '%' + @Search + '%'
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;