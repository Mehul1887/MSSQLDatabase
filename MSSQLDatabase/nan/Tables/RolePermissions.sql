CREATE TABLE [nan].[RolePermissions] (
    [Id]           BIGINT   IDENTITY (1, 1) NOT NULL,
    [RoleId]       BIGINT   NOT NULL,
    [PageId]       BIGINT   NOT NULL,
    [View_Right]   BIT      CONSTRAINT [DF_RolePermissions_View_Right] DEFAULT ((0)) NOT NULL,
    [Add_Right]    BIT      CONSTRAINT [DF_RolePermissions_Add_Right] DEFAULT ((0)) NOT NULL,
    [Edit_Right]   BIT      CONSTRAINT [DF_RolePermissions_Edit_Right] DEFAULT ((0)) NOT NULL,
    [Delete_Right] BIT      CONSTRAINT [DF_RolePermissions_Delete_Right] DEFAULT ((0)) NOT NULL,
    [Export_Right] BIT      CONSTRAINT [DF_RolePermissions_Export_Right] DEFAULT ((0)) NOT NULL,
    [CreatedOn]    DATETIME CONSTRAINT [DF_RolePermissions_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    BIGINT   NOT NULL,
    [UpdatedOn]    DATETIME NULL,
    [UpdatedBy]    BIGINT   NULL,
    [DeletedOn]    DATETIME NULL,
    [DeletedBy]    BIGINT   NULL,
    [IsDeleted]    BIT      CONSTRAINT [DF_RolePermissions_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_RolePermissions] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_RolePermissions_Page] FOREIGN KEY ([PageId]) REFERENCES [nan].[Page] ([Id]),
    CONSTRAINT [FK_RolePermissions_Role] FOREIGN KEY ([RoleId]) REFERENCES [nan].[Role] ([Id])
);

