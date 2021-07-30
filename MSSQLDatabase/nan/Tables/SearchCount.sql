CREATE TABLE [nan].[SearchCount] (
    [SearchCountId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [SearchCountName] NVARCHAR (100) NULL,
    [AgencyDetailsId] BIGINT         NULL,
    [FamilyDetailsId] BIGINT         NULL,
    [CreatedOn]       DATETIME       CONSTRAINT [DF_SearchCount_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       BIGINT         NOT NULL,
    [UpdatedOn]       DATETIME       NULL,
    [UpdatedBy]       BIGINT         NULL,
    [DeletedOn]       DATETIME       NULL,
    [DeletedBy]       BIGINT         NULL,
    [IsDeleted]       BIT            CONSTRAINT [DF_SearchCount_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_SearchCount] PRIMARY KEY CLUSTERED ([SearchCountId] ASC),
    CONSTRAINT [FK_SearchCount_AgencyDetails] FOREIGN KEY ([AgencyDetailsId]) REFERENCES [nan].[AgencyDetails] ([AgencyDetailsId]),
    CONSTRAINT [FK_SearchCount_FamilyDetails] FOREIGN KEY ([FamilyDetailsId]) REFERENCES [nan].[FamilyDetails] ([FamilyDetailsId])
);

