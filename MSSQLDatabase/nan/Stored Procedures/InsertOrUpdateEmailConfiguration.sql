-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,InsertOrUpdateEmailConfiguration>
-- Call SP    :	InsertOrUpdateEmailConfiguration
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateEmailConfiguration]
    @Id BIGINT ,
    @ProfileName NVARCHAR(50) ,
    @SMPTServer NVARCHAR(50) ,
    @UserName NVARCHAR(50) ,
    @Password NVARCHAR(50) ,
    @Port INT ,
    @EnableSSL BIT ,
    @DisplayName NVARCHAR(100) ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @Id = 0 )
            BEGIN
                INSERT  INTO nan.[EmailConfiguration]
                        ( [ProfileName] ,
                          [SMPTServer] ,
                          [UserName] ,
                          [Password] ,
                          [Port] ,
                          [EnableSSL] ,
                          [DisplayName] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted] 
                        )
                VALUES  ( @ProfileName ,
                          @SMPTServer ,
                          @UserName ,
                          @Password ,
                          @Port ,
                          @EnableSSL ,
                          @DisplayName ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
                SELECT  @Id = SCOPE_IDENTITY();
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted 
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Insert record in table EmailConfiguration' ,
                          'EmailConfiguration' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
            END;
        ELSE
            BEGIN
                UPDATE  EC
                SET     [ProfileName] = @ProfileName ,
                        [SMPTServer] = @SMPTServer ,
                        [UserName] = @UserName ,
                        [Password] = @Password ,
                        [Port] = @Port ,
                        [EnableSSL] = @EnableSSL ,
                        [DisplayName] = @DisplayName ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[EmailConfiguration] AS EC
                WHERE   [Id] = @Id;
                INSERT  INTO nan.ActivityLog
                        ( UserId ,
                          PageId ,
                          AuditComments ,
                          TableName ,
                          RecordId ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted 
                        )
                VALUES  ( @UserId ,
                          @PageId ,
                          'Update record in table EmailConfiguration' ,
                          'EmailConfiguration' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        );
            END;
        SELECT  ISNULL(@Id, 0) AS InsertedId;
    END;