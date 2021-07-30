-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 27 apr 2017>
-- Description:	<Description,,InsertOrUpdateUser>
-- Call SP    :	InsertOrUpdateUser
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateUser]
    @Id BIGINT ,
    @FirstName NVARCHAR(50) ,
    @SurName NVARCHAR(50) ,
    @MobileNo NVARCHAR(50) ,
    @EmailID NVARCHAR(50) ,
    @UserName NVARCHAR(50) ,
    @Password NVARCHAR(100) ,
    @Address NVARCHAR(500) ,
    @RoleId BIGINT ,
    @IsActive BIT ,
    @IsLogin BIT ,
	@ProfileImage NVARCHAR(500) ,
    @UserId BIGINT ,
    @PageId BIGINT,
	@UserType NVARCHAR(50)
	
AS 
    BEGIN
	
        IF ( @Id = 0 ) 
            BEGIN
                INSERT  INTO [nan].[User]
                        ( [FirstName] ,
                          [SurName] ,
                          [MobileNo] ,
                          [EmailID] ,
                          [UserName] ,
                          [Password] ,
                          [Address] ,
                          [RoleId] ,
                          [IsActive] ,
                          [IsLogin] ,
						  [ProfileImage],
						  [UserType],
						
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted] 
                        )
                VALUES  ( @FirstName ,
                          @SurName ,
                          @MobileNo ,
                          @EmailID ,
                          @UserName ,
                          @Password ,
                          @Address ,
                          @RoleId ,
                          @IsActive ,
                          @IsLogin ,
						  @ProfileImage,
						  @UserType,
					
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        )
                SELECT  @Id = SCOPE_IDENTITY()
                INSERT  INTO [nan].ActivityLog
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
                          'Insert record in table User' ,
                          'User' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        )
            END
        ELSE 
            BEGIN
                UPDATE  u
                SET     u.[FirstName] = @FirstName ,
                        u.[SurName] = @SurName ,
                        u.[MobileNo] = @MobileNo ,
                        u.[EmailID] = @EmailID ,
                        u.[UserName] = @UserName ,
                        u.[Password] = @Password ,
                        u.[Address] = @Address ,
                        u.[RoleId] = @RoleId ,
                        u.[IsActive] = @IsActive ,
                        u.[IsLogin] = @IsLogin ,
						u.[ProfileImage] = @ProfileImage ,
						u.[UserType] = @UserType,
					
                        u.[UpdatedOn] = GETUTCDATE() ,
                        u.[UpdatedBy] = @UserId
						FROM [nan].[User] AS u
                WHERE   [Id] = @Id
                INSERT  INTO [nan].ActivityLog
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
                          'Update record in table User' ,
                          'User' ,
                          @Id ,
                          GETUTCDATE() ,
                          @UserId ,
                          0 
                        )
            END
        SELECT  ISNULL(@Id, 0) AS InsertedId
    END