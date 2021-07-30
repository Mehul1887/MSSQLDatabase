CREATE TABLE [nan].[ErrorLog] (
    [Id]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [PageId]       BIGINT         NOT NULL,
    [MethodName]   NVARCHAR (200) NOT NULL,
    [ErrorType]    NVARCHAR (MAX) NOT NULL,
    [ErrorMessage] NVARCHAR (MAX) NOT NULL,
    [ErrorDetails] NVARCHAR (MAX) NULL,
    [ErrorDate]    DATETIME       CONSTRAINT [DF_ErrorLog_ErrorDate] DEFAULT (getdate()) NOT NULL,
    [UserId]       BIGINT         NOT NULL,
    [Solution]     NVARCHAR (MAX) NULL,
    [CreatedOn]    DATETIME       CONSTRAINT [DF_ErrorLog_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    BIGINT         NOT NULL,
    [UpdatedOn]    DATETIME       NULL,
    [UpdatedBy]    BIGINT         NULL,
    [DeletedOn]    DATETIME       NULL,
    [DeletedBy]    BIGINT         NULL,
    [IsDeleted]    BIT            CONSTRAINT [DF_ErrorLog_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PKErrorLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FK_ErrorLog_Module] FOREIGN KEY ([PageId]) REFERENCES [nan].[Page] ([Id])
);

