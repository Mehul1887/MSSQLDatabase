CREATE TABLE [nan].[CMSPageMaster] (
    [CMSPageMasterId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [CMSPageMasterName] NVARCHAR (50)  NULL,
    [PageContent]       NVARCHAR (MAX) NULL,
    [PageMasterId]      BIGINT         NULL,
    [Title]             NVARCHAR (50)  NULL,
    [Keywords]          NVARCHAR (100) NULL,
    [Description]       NVARCHAR (200) NULL,
    [CreatedOn]         DATETIME       CONSTRAINT [DF_CMSPageMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         BIGINT         NOT NULL,
    [UpdatedOn]         DATETIME       NULL,
    [UpdatedBy]         BIGINT         NULL,
    [DeletedOn]         DATETIME       NULL,
    [DeletedBy]         BIGINT         NULL,
    [IsDeleted]         BIT            CONSTRAINT [DF_CMSPageMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CMSPageMaster] PRIMARY KEY CLUSTERED ([CMSPageMasterId] ASC),
    CONSTRAINT [FK_CMSPageMaster_Page] FOREIGN KEY ([PageMasterId]) REFERENCES [nan].[Page] ([Id])
);

