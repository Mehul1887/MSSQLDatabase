CREATE TABLE [nan].[UserLog] (
    [Id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [UserId]     BIGINT         NOT NULL,
    [PageId]     BIGINT         NOT NULL,
    [Action]     NVARCHAR (200) NOT NULL,
    [IpAddress]  NVARCHAR (50)  NOT NULL,
    [AccessType] NVARCHAR (50)  NOT NULL,
    [Location]   NVARCHAR (50)  NOT NULL,
    [AccessOn]   NVARCHAR (50)  NOT NULL,
    [CreatedOn]  DATETIME       CONSTRAINT [DF_UserLog_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]  BIGINT         NOT NULL,
    [UpdatedOn]  DATETIME       NULL,
    [UpdatedBy]  BIGINT         NULL,
    [DeletedOn]  DATETIME       NULL,
    [DeletedBy]  BIGINT         NULL,
    [IsDeleted]  BIT            CONSTRAINT [DF_UserLog_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PKUserLog] PRIMARY KEY CLUSTERED ([Id] ASC),
    CONSTRAINT [FKUserLogUser] FOREIGN KEY ([UserId]) REFERENCES [nan].[User] ([Id])
);

