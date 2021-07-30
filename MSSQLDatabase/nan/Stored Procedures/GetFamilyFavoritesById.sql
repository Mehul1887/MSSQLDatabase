-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyFavoritesById>
-- Call SP    :	GetFamilyFavoritesById
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyFavoritesById]
    @FamilyFavoritesId BIGINT
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FF].[FamilyFavoritesId] AS FamilyFavoritesId ,
                [FF].[FamilyFavoritesName] AS FamilyFavoritesName ,
                [FF].[FamilyDetailsId] AS FamilyDetailsId ,
                [FF].[IsFavoritesForFamily] AS IsFavoritesForFamily
        FROM    nan.[FamilyFavorites] AS FF
        WHERE   [FF].[FamilyFavoritesId] = @FamilyFavoritesId;
    END;