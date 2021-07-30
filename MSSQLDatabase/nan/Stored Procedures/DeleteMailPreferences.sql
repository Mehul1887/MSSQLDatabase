﻿-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,DeleteMailPreferences>
-- Call SP    :	DeleteMailPreferences
-- =============================================
CREATE PROCEDURE [nan].[DeleteMailPreferences]
    @IdList NVARCHAR(MAX) ,
    @DeletedBy BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        DECLARE @Start INT = 1 ,
            @Total INT ,
            @IsUsed BIT ,
            @Id BIGINT ,
            @Result NVARCHAR(MAX) = '' ,
            @Count INT = 0;
        DECLARE @Tbl TABLE ( Id INT NULL, Data INT NULL);
        INSERT  INTO @Tbl
                ( Id ,
                  Data
                )
                SELECT  Id ,
                        Data
                FROM    nan.Split(@IdList, ',');
        SELECT  @Total = COUNT(1)
        FROM    @Tbl;
        WHILE @Start <= @Total
            BEGIN
                SELECT  @Id = Data
                FROM    @Tbl
                WHERE   Id = @Start;
                EXEC nan.IsReferenceExists N'MailPreferences', @Id,
                    @IsUsed OUTPUT;
                IF @IsUsed = 0
                    BEGIN
                        UPDATE  MP
                        SET     IsDeleted = 1 ,
                                DeletedBy = @DeletedBy ,
                                DeletedOn = GETUTCDATE()
								FROM nan.[MailPreferences] AS MP
                        WHERE   [MailPreferencesId] IN (
                                SELECT  Data
                                FROM    nan.Split(@IdList, ',') );
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
                        VALUES  ( @DeletedBy ,
                                  @PageId ,
                                  'Delete record in table MailPreferences' ,
                                  'MailPreferences' ,
                                  @Id ,
                                  GETUTCDATE() ,
                                  @DeletedBy ,
                                  0
                                );
                    END;
                ELSE
                    BEGIN
                        SET @Count += 1;
                        SELECT  @Result = @Result + ', ' + MailPreferencesName
                        FROM    nan.[MailPreferences]
                        WHERE   [MailPreferencesId] IN (
                                SELECT  Data
                                FROM    nan.Split(@IdList, ',') );
                    END;
                SET @Start += 1;
            END;
        SELECT  ISNULL(@Count, 0) AS TotalReference ,
                SUBSTRING(@Result, 2, LEN(@Result)) AS Name;
    END;