-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 31 May 2017>
-- Description:	<Description,,GetMailBoxAll>
-- Call SP    :	nan.SearchMailBoxPortal null, null, '', '','sent',9
-- =============================================
CREATE PROCEDURE [nan].[SearchMailBoxPortal]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50),
	@IsFor NVARCHAR(50),
	@FamilyDetailsId BIGINT
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
               Subject,
			   FromID,ToID,FromFamily,ToFamily,FromEmail,ToEmail,ReceivedOn,TrashOn,SentOn,IsTrash,IsDraft,IsRead
        FROM    ( SELECT  MB.MailBoxId ,
							MB.Subject ,
							MB.FromID,
							MB.ToID,
							CASE WHEN MB.FromID=-1 THEN 'Aouto Generated' ELSE FD.FamilyDetailsName END AS FromFamily,
							FD2.FamilyDetailsName AS ToFamily,
							CASE WHEN MB.FromID=-1 THEN 'Aouto Generated' ELSE FD.Email END AS FromEmail,
							FD2.Email AS ToEmail,
							ISNULL(convert(varchar(20),MB.CreatedOn, 103) + right(convert(varchar(32),MB.CreatedOn,100),8),'') AS ReceivedOn,
							ISNULL(convert(varchar(20),MB.TrashOn, 103) + right(convert(varchar(32),MB.TrashOn,100),8),'') AS TrashOn,
							ISNULL(convert(varchar(20),MB.MailSentOn, 103) + right(convert(varchar(32),MB.MailSentOn,100),8),'') AS SentOn,
							ISNULL(MB.IsTrash,0) AS IsTrash,
							ISNULL(MB.IsDraft,0) AS IsDraft,
							ISNULL(MB.IsRead,0) AS IsRead,
							ISNULL(@IsFor,'') AS IsFor,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY MB.CreatedOn DESC) AS RowNum
                 FROM    nan.MailBox AS MB
                          LEFT JOIN nan.FamilyDetails AS FD ON FD.FamilyDetailsId = MB.FromID
                          LEFT JOIN nan.FamilyDetails AS FD2 ON FD2.FamilyDetailsId = MB.ToID
                          WHERE ISNULL(FD.IsDeleted,0)=0 AND
                          MB.IsDeleted=0 AND
                            -------------trash-------------------------
                            CASE WHEN @IsFor='trash' THEN ISNULL(MB.IsTrash,0) ELSE 1 END=1  
                            AND (CASE WHEN @IsFor='trash' THEN MB.ToID  ELSE @FamilyDetailsId END=@FamilyDetailsId OR CASE WHEN @IsFor='trash' THEN MB.FromID  ELSE @FamilyDetailsId END=@FamilyDetailsId)							
                            -----------draft------------------------
                            AND CASE WHEN @IsFor='draft' THEN ISNULL(MB.IsDraft,0) ELSE 1 END=1
                            AND CASE WHEN @IsFor='draft' THEN ISNULL(MB.IsTrash,0) ELSE 0 END=0
                            AND CASE WHEN @IsFor='draft' THEN MB.FromID ELSE @FamilyDetailsId END=@FamilyDetailsId
                            -----------Sent ---------------------------------
                            AND CASE WHEN @IsFor='sent' THEN MB.FromID ELSE @FamilyDetailsId END= @FamilyDetailsId
                            AND CASE WHEN @IsFor='sent' THEN ISNULL(MB.IsDraft,0) ELSE 0 END= 0
                            AND CASE WHEN @IsFor='sent' THEN ISNULL(MB.IsTrash,0) ELSE 0 END= 0
                            -----------inbox----------------------------------
                            AND CASE WHEN @IsFor='inbox' THEN MB.ToID ELSE @FamilyDetailsId END=@FamilyDetailsId
                            AND CASE WHEN @IsFor='inbox' THEN ISNULL(MB.IsTrash,0) ELSE 0 END=0
                            AND CASE WHEN @IsFor='inbox' THEN ISNULL(MB.IsDraft,0) ELSE 0 END=0
                           
                ) AS T
      --  WHERE   RowNum BETWEEN @Start AND @End;
    END;