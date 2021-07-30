CREATE TABLE [nan].[ContactUs] (
    [ContactUsId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [ContactUsName] NVARCHAR (50)  NOT NULL,
    [Name]          NVARCHAR (50)  NOT NULL,
    [EmailId]       NVARCHAR (50)  NOT NULL,
    [ContactNo]     NVARCHAR (50)  NULL,
    [Subject]       NVARCHAR (50)  NULL,
    [BodyText]      NVARCHAR (MAX) NULL,
    [IsRead]        BIT            NULL,
    [IsReply]       BIT            NULL,
    [IsPayroll]     BIT            NULL,
    [ReplyText]     NVARCHAR (MAX) NULL,
    [ReplyOn]       DATETIME       NULL,
    [CreatedOn]     DATETIME       CONSTRAINT [DF_ContactUs_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     BIGINT         NOT NULL,
    [UpdatedOn]     DATETIME       NULL,
    [UpdatedBy]     BIGINT         NULL,
    [DeletedOn]     DATETIME       NULL,
    [DeletedBy]     BIGINT         NULL,
    [IsDeleted]     BIT            CONSTRAINT [DF_ContactUs_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ContactUs] PRIMARY KEY CLUSTERED ([ContactUsId] ASC)
);

