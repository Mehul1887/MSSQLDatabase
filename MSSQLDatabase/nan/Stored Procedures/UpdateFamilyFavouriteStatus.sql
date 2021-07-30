-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <23 Aug 2017>
-- Description:	<nan.UpdateFamilyFavouriteStatus>
-- Call SP    :	nan.UpdateFamilyFavouriteStatus 19
-- =============================================
CREATE PROCEDURE [nan].[UpdateFamilyFavouriteStatus]
    @TargetFamilyId BIGINT ,
    @Status BIT ,
    @FamilyDetailsId BIGINT
AS
    BEGIN
	DECLARE @familyFavouriteId BIGINT=0
        SET NOCOUNT ON;
        IF EXISTS ( SELECT  FF.FamilyFavoritesId
                    FROM    nan.FamilyFavorites AS FF
                    WHERE   FF.FamilyDetailsId = @FamilyDetailsId
                            AND FF.TargetFamilyDetailsId = @TargetFamilyId
                            AND ISNULL(FF.IsDeleted, 0) = 0 )
            BEGIN
                UPDATE  nan.FamilyFavorites
                SET     IsFavoritesForFamily = @Status ,
                        UpdatedOn = GETUTCDATE() ,
						@familyFavouriteId=FamilyFavoritesId,
                        UpdatedBy = @FamilyDetailsId
                WHERE   FamilyDetailsId = @FamilyDetailsId
                        AND TargetFamilyDetailsId = @TargetFamilyId;
					
            END;
        ELSE
            BEGIN
                INSERT  INTO nan.FamilyFavorites
                        ( FamilyFavoritesName ,
                          FamilyDetailsId ,
                          TargetFamilyDetailsId ,
                          IsFavoritesForFamily ,
                          CreatedOn ,
                          CreatedBy ,
                          IsDeleted
		                )
                VALUES  ( N'' , -- FamilyFavoritesName - nvarchar(100)
                          @FamilyDetailsId , -- FamilyDetailsId - bigint
                          @TargetFamilyId , -- TargetFamilyDetailsId - bigint
                          @Status , -- IsFavoritesForFamily - bit
                          GETUTCDATE() , -- CreatedOn - datetime
                          @FamilyDetailsId , -- CreatedBy - bigint		              
                          0  -- IsDeleted - bit
		                );
						SELECT @familyFavouriteId=SCOPE_IDENTITY()
            END;
			SELECT ISNULL(@familyFavouriteId,0) AS FavouriteId
    END;