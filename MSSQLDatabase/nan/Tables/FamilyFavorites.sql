CREATE TABLE [nan].[FamilyFavorites] (
    [FamilyFavoritesId]     BIGINT         IDENTITY (1, 1) NOT NULL,
    [FamilyFavoritesName]   NVARCHAR (100) NULL,
    [FamilyDetailsId]       BIGINT         NULL,
    [TargetFamilyDetailsId] BIGINT         NULL,
    [IsFavoritesForFamily]  BIT            NOT NULL,
    [CreatedOn]             DATETIME       CONSTRAINT [DF_FamilyFavorites_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             BIGINT         NOT NULL,
    [UpdatedOn]             DATETIME       NULL,
    [UpdatedBy]             BIGINT         NULL,
    [DeletedOn]             DATETIME       NULL,
    [DeletedBy]             BIGINT         NULL,
    [IsDeleted]             BIT            CONSTRAINT [DF_FamilyFavorites_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_FamilyFavorites] PRIMARY KEY CLUSTERED ([FamilyFavoritesId] ASC),
    CONSTRAINT [FK_FamilyFavorites_FamilyDetails] FOREIGN KEY ([FamilyDetailsId]) REFERENCES [nan].[FamilyDetails] ([FamilyDetailsId])
);

