-- =============================================
-- Author		:Anand Upadhyay
-- Create date	:02-05-2017
-- Description	:update inbox mail to as Read
-- Call			:
-- =============================================
CREATE PROCEDURE [nan].[UpdateInboxMailToRead]
    @IdList NVARCHAR(MAX) ,
    @UserId BIGINT
AS
    BEGIN
        DECLARE @Start INT = 1 ,
            @Total INT ,
            @UpdatedId VARCHAR(MAX)= '' ,
            @Id BIGINT;
        DECLARE @Tbl TABLE
            (
              Id INT NOT NULL ,
              Data INT NULL
            );
       
        IF @IdList <> ''
            BEGIN
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

                        UPDATE  MB
                        SET     MB.IsDeleted = 0 ,
								MB.IsRead = 1,
                                MB.UpdatedBy = @UserId ,
                                MB.UpdatedOn = GETUTCDATE() ,
                                MB.IsTrash = 0
                        FROM    nan.MailBox AS MB
                        WHERE   MailBoxId = @Id;
                        SET @UpdatedId = @UpdatedId + ','
                            + CAST(@Id AS VARCHAR(5));
                        SET @Start += 1;
                    END;
            END;
        SELECT  @UpdatedId AS UpdatedId;
    END;