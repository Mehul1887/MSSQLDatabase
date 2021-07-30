-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,InsertOrUpdateFamilyFavorites>
-- Call SP    :	InsertOrUpdateFamilyFavorites
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateFamilyFavorites]
    @FamilyFavoritesId BIGINT ,
    @FamilyFavoritesName NVARCHAR(100) ,
    @FamilyDetailsId BIGINT ,
    @IsFavoritesForFamily BIT ,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON
        IF ( @FamilyFavoritesId = 0 )
            BEGIN
                INSERT  INTO nan.[FamilyFavorites]
                        ( [FamilyFavoritesName] ,
                          [FamilyDetailsId] ,
                          [IsFavoritesForFamily] ,
                          [CreatedOn] ,
                          [CreatedBy] ,
                          [IsDeleted]
                        )
                VALUES  ( @FamilyFavoritesName ,
                          @FamilyDetailsId ,
                          @IsFavoritesForFamily ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
                SELECT  @FamilyFavoritesId = SCOPE_IDENTITY();
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
                          'Insert record in table FamilyFavorites' ,
                          'FamilyFavorites' ,
                          @FamilyFavoritesId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        ELSE
            BEGIN
                UPDATE  FF
                SET     [FamilyFavoritesName] = @FamilyFavoritesName ,
                        [FamilyDetailsId] = @FamilyDetailsId ,
                        [IsFavoritesForFamily] = @IsFavoritesForFamily ,
                        [UpdatedOn] = GETUTCDATE() ,
                        [UpdatedBy] = @UserId
						FROM nan.[FamilyFavorites] AS FF
                WHERE   [FamilyFavoritesId] = @FamilyFavoritesId;
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
                          'Update record in table FamilyFavorites' ,
                          'FamilyFavorites' ,
                          @FamilyFavoritesId ,
                          GETUTCDATE() ,
                          @UserId ,
                          0
                        );
            END;
        SELECT  ISNULL(@FamilyFavoritesId, 0) AS InsertedId;
    END;