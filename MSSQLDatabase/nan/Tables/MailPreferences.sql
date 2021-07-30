CREATE TABLE [nan].[MailPreferences] (
    [MailPreferencesId]   BIGINT          IDENTITY (1, 1) NOT NULL,
    [TemplateName]        NVARCHAR (200)  NULL,
    [MailPreferencesName] NVARCHAR (100)  NULL,
    [Description]         NVARCHAR (100)  NULL,
    [MailText]            NVARCHAR (1000) NULL,
    [IsMail]              BIT             NULL,
    [Subject]             NVARCHAR (100)  NULL,
    [PageName]            NVARCHAR (20)   NULL,
    [IsActive]            BIT             NULL,
    [CreatedOn]           DATETIME        CONSTRAINT [DF_MailPreferences_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           BIGINT          NOT NULL,
    [UpdatedOn]           DATETIME        NULL,
    [UpdatedBy]           BIGINT          NULL,
    [DeletedOn]           DATETIME        NULL,
    [DeletedBy]           BIGINT          NULL,
    [IsDeleted]           BIT             CONSTRAINT [DF_MailPreferences_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_MailPreferences] PRIMARY KEY CLUSTERED ([MailPreferencesId] ASC)
);

