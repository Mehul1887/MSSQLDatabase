CREATE TABLE [nan].[BlogMaster] (
    [Id]              BIGINT         IDENTITY (1, 1) NOT NULL,
    [BlogTitle]       NVARCHAR (100) NULL,
    [BlogImagePath]   NVARCHAR (200) NULL,
    [BlogDescription] NVARCHAR (MAX) NULL,
    [CreatedOn]       DATETIME       CONSTRAINT [DF_BlogMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       BIGINT         NOT NULL,
    [UpdatedOn]       DATETIME       NULL,
    [UpdatedBy]       BIGINT         NULL,
    [DeletedOn]       DATETIME       NULL,
    [DeletedBy]       BIGINT         NULL,
    [IsDeleted]       BIT            CONSTRAINT [DF_BlogMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_BlogMaster] PRIMARY KEY CLUSTERED ([Id] ASC)
);

