-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateMailPreferences>
-- Call SP    :	InsertOrUpdateMailPreferences
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateMailPreferences]
    @MailPreferencesId BIGINT ,
    @MailPreferencesName NVARCHAR(100) ,
    @Description NVARCHAR(100) ,
    @MailText NVARCHAR(1000) ,
    @IsMail BIT ,
    @Subject NVARCHAR(100) ,
    @PageName NVARCHAR(20) ,
    @IsActive BIT ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;
        IF ( @MailPreferencesId = 0 )
            BEGIN
                INSERT  INTO nan.[MailPreferences]
                        ( [MailPreferencesName] ,
                          [Description] ,
                          [MailText] ,
                          [IsMail] ,
                          [Subject] ,
                          [PageName] ,
                          IsActive ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @MailPreferencesName ,
                          @Description ,
                          @MailText ,
                          @IsMail ,
                          @Subject ,
                          @PageName ,
                          @IsActive ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @MailPreferencesId = SCOPE_IDENTITY();
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
                          'Insert record in table MailPreferences' ,
                          'MailPreferences' ,
                          @MailPreferencesId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  MailPreferences
                SET     [MailPreferencesName] = @MailPreferencesName ,
                        [Description] = @Description ,
                        [MailText] = @MailText ,
                        [IsMail] = @IsMail ,
                        [Subject] = @Subject ,
                        [PageName] = @PageName ,
                        [IsActive] = @IsActive ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
                FROM    nan.[MailPreferences] AS MailPreferences
                WHERE   [MailPreferencesId] = @MailPreferencesId;
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
                          'Update record in table MailPreferences' ,
                          'MailPreferences' ,
                          @MailPreferencesId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@MailPreferencesId, 0) AS InsertedId;
    END;