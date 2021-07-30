CREATE TABLE [nan].[Role] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [RoleName]    NVARCHAR (50)  NOT NULL,
    [Description] NVARCHAR (500) NULL,
    [CreatedOn]   DATETIME       CONSTRAINT [DF_Role_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   BIGINT         NOT NULL,
    [UpdatedOn]   DATETIME       NULL,
    [UpdatedBy]   BIGINT         NULL,
    [DeletedOn]   DATETIME       NULL,
    [DeletedBy]   BIGINT         NULL,
    [IsDeleted]   BIT            CONSTRAINT [DF_Role_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED ([Id] ASC)
);

