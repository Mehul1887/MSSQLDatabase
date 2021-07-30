CREATE TABLE [nan].[MailBox] (
    [MailBoxId]    BIGINT          IDENTITY (1, 1) NOT NULL,
    [MailBoxName]  NVARCHAR (100)  NULL,
    [FromID]       BIGINT          NULL,
    [ToID]         BIGINT          NULL,
    [BodyText]     NVARCHAR (1000) NULL,
    [Subject]      NVARCHAR (100)  NULL,
    [IsParent]     BIT             NULL,
    [IsDraft]      BIT             NULL,
    [ParentMailID] BIGINT          NULL,
    [IsRead]       BIT             NULL,
    [IsTrash]      BIT             NULL,
    [TrashOn]      DATETIME        NULL,
    [MailSentOn]   DATETIME        NULL,
    [CreatedOn]    DATETIME        CONSTRAINT [DF_MailBox_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]    BIGINT          NOT NULL,
    [UpdatedOn]    DATETIME        NULL,
    [UpdatedBy]    BIGINT          NULL,
    [DeletedOn]    DATETIME        NULL,
    [DeletedBy]    BIGINT          NULL,
    [IsDeleted]    BIT             CONSTRAINT [DF_MailBox_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MailBox] PRIMARY KEY CLUSTERED ([MailBoxId] ASC)
);

