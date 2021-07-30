CREATE TABLE [nan].[CountryMaster] (
    [CountryMasterId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [CountryMasterName] NVARCHAR (100) NULL,
    [CreatedOn]         DATETIME       CONSTRAINT [DF_CountryMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         BIGINT         NOT NULL,
    [UpdatedOn]         DATETIME       NULL,
    [UpdatedBy]         BIGINT         NULL,
    [DeletedOn]         DATETIME       NULL,
    [DeletedBy]         BIGINT         NULL,
    [IsDeleted]         BIT            CONSTRAINT [DF_CountryMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CountryMaster] PRIMARY KEY CLUSTERED ([CountryMasterId] ASC)
);

