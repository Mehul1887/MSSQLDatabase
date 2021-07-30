CREATE TABLE [nan].[AAAAConfigSettings] (
    [Id]             BIGINT         IDENTITY (1, 1) NOT NULL,
    [KeyName]        NVARCHAR (100) NOT NULL,
    [KeyValue]       NVARCHAR (MAX) NOT NULL,
    [KeyDescription] NVARCHAR (500) NOT NULL,
    [Module]         NVARCHAR (100) NOT NULL,
    [CreatedOn]      DATETIME       CONSTRAINT [DF_AAAAConfigSettings_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      BIGINT         NOT NULL,
    [UpdatedOn]      DATETIME       NULL,
    [UpdatedBy]      BIGINT         NULL,
    [DeletedOn]      DATETIME       NULL,
    [DeletedBy]      BIGINT         NULL,
    [IsDeleted]      BIT            CONSTRAINT [DF_AAAAConfigSettings_IsDeleted] DEFAULT ((0)) NOT NULL,
    [IsActive]       BIT            NULL,
    [IsShow]         BIT            NULL,
    CONSTRAINT [PKAAAAConfigSettings] PRIMARY KEY CLUSTERED ([Id] ASC)
);

