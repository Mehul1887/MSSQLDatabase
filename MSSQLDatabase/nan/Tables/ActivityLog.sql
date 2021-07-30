CREATE TABLE [nan].[ActivityLog] (
    [Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [UserId]        BIGINT         NOT NULL,
    [PageId]        BIGINT         NOT NULL,
    [AuditComments] NVARCHAR (MAX) NOT NULL,
    [TableName]     NVARCHAR (50)  NOT NULL,
    [RecordId]      BIGINT         NOT NULL,
    [CreatedOn]     DATETIME       CONSTRAINT [DF_ActivityLog_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     BIGINT         NOT NULL,
    [UpdatedOn]     DATETIME       NULL,
    [UpdatedBy]     BIGINT         NULL,
    [DeletedOn]     DATETIME       NULL,
    [DeletedBy]     BIGINT         NULL,
    [IsDeleted]     BIT            CONSTRAINT [DF_ActivityLog_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ActivityLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ActivityLog_Page] FOREIGN KEY ([PageId]) REFERENCES [nan].[Page] ([Id])
);

