-- =============================================
-- Author		:Anand Upadhyay
-- Create date	:08-05-2017
-- Description	:Update Sent Mail To Delete
-- Call			:
-- =============================================
CREATE PROCEDURE [nan].[UpdateSentMailBoxToDelete]
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
                        SET     MB.IsDeleted = 1,
								MB.IsTrash = 1,
                                MB.UpdatedBy = @UserId ,
                                MB.UpdatedOn = GETUTCDATE()
                        FROM    nan.MailBox AS MB
                        WHERE   MailBoxId = @Id AND IsParent=1;
                        SET @UpdatedId = @UpdatedId + ','
                            + CAST(@Id AS VARCHAR(5));
                        SET @Start += 1;
                    END;
            END;
        SELECT  @UpdatedId AS UpdatedId;
    END;