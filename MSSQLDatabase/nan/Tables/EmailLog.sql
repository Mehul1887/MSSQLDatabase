CREATE TABLE [nan].[EmailLog] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [RelaventId]  BIGINT         NULL,
    [IsFamily]    BIT            NULL,
    [Subject]     NVARCHAR (250) NOT NULL,
    [MailContent] NVARCHAR (MAX) NOT NULL,
    [MailTo]      NVARCHAR (MAX) NOT NULL,
    [CC]          NVARCHAR (MAX) NULL,
    [BCC]         NVARCHAR (MAX) NULL,
    [IsSent]      BIT            NULL,
    [SentOn]      DATETIME       NULL,
    [IsRead]      BIT            NULL,
    [CreatedOn]   DATETIME       CONSTRAINT [DF_EmailLog_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   BIGINT         NOT NULL,
    [UpdatedOn]   DATETIME       NULL,
    [UpdatedBy]   BIGINT         NULL,
    [DeletedOn]   DATETIME       NULL,
    [DeletedBy]   BIGINT         NULL,
    [IsDeleted]   BIT            CONSTRAINT [DF_EmailLog_IsDeleted] DEFAULT ((0)) NOT NULL,
    [PageId]      BIGINT         NULL,
    CONSTRAINT [PKEmailLog] PRIMARY KEY CLUSTERED ([Id] ASC)
);

