CREATE TABLE [nan].[Module] (
    [Id]         NVARCHAR (250) NOT NULL,
    [ModuleName] NVARCHAR (50)  NOT NULL,
    [Sequence]   INT            NOT NULL,
    [CreatedOn]  DATETIME       CONSTRAINT [DF_Module_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  BIGINT         NOT NULL,
    [UpdatedOn]  DATETIME       NULL,
    [UpdatedBy]  BIGINT         NULL,
    [DeletedOn]  DATETIME       NULL,
    [DeletedBy]  BIGINT         NULL,
    [IsDeleted]  BIT            CONSTRAINT [DF_Module_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_User_Module] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [IX_User_Module] UNIQUE NONCLUSTERED ([ModuleName] ASC)
);

