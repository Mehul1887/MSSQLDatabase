-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilyFavoritesAll>
-- Call SP    :	GetFamilyFavoritesAll
-- =============================================
CREATE PROCEDURE [nan].[GetFamilyFavoritesAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [FF].[FamilyFavoritesId] AS FamilyFavoritesId ,
                [FF].[FamilyFavoritesName] AS FamilyFavoritesName ,
                [FF].[FamilyDetailsId] AS FamilyDetailsId ,
                [FF].[IsFavoritesForFamily] AS IsFavoritesForFamily
        FROM    nan.[FamilyFavorites] AS FF
        WHERE   [FF].IsDeleted = 0;
    END;