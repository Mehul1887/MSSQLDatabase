CREATE TABLE [nan].[Page] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [ModuleId]    NVARCHAR (250) NOT NULL,
    [PageName]    NVARCHAR (50)  NOT NULL,
    [DispalyName] NVARCHAR (50)  NOT NULL,
    [Sequence]    INT            NOT NULL,
    [CreatedOn]   DATETIME       CONSTRAINT [DF_Page_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   BIGINT         NOT NULL,
    [UpdatedOn]   DATETIME       NULL,
    [UpdatedBy]   BIGINT         NULL,
    [DeletedOn]   DATETIME       NULL,
    [DeletedBy]   BIGINT         NULL,
    [IsDeleted]   BIT            CONSTRAINT [DF_Page_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_Page] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_Page_Module] FOREIGN KEY ([ModuleId]) REFERENCES [nan].[Module] ([Id])
);

