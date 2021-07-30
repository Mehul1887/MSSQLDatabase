CREATE TABLE [nan].[AboutUs] (
    [Id]                BIGINT         IDENTITY (1, 1) NOT NULL,
    [AboutUsName]       NVARCHAR (MAX) NULL,
    [PrivacyPolicy]     NVARCHAR (MAX) NULL,
    [WorkPolicy]        NVARCHAR (MAX) NULL,
    [AppUseInstruction] NVARCHAR (MAX) NULL,
    [CreatedOn]         DATETIME       CONSTRAINT [DF_AboutUs_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]         BIGINT         NOT NULL,
    [UpdatedOn]         DATETIME       NULL,
    [UpdatedBy]         BIGINT         NULL,
    [DeletedOn]         DATETIME       NULL,
    [DeletedBy]         BIGINT         NULL,
    [IsDeleted]         BIT            CONSTRAINT [DF_AboutUs_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ConfigurationSettings] PRIMARY KEY CLUSTERED ([Id] ASC)
);

