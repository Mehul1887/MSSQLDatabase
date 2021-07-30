CREATE TABLE [nan].[LanguageMaster] (
    [LanguageMasterId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [LanguageMasterName] NVARCHAR (30) NULL,
    [CreatedOn]          DATETIME      CONSTRAINT [DF_LanguageMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]          BIGINT        NOT NULL,
    [UpdatedOn]          DATETIME      NULL,
    [UpdatedBy]          BIGINT        NULL,
    [DeletedOn]          DATETIME      NULL,
    [DeletedBy]          BIGINT        NULL,
    [IsDeleted]          BIT           CONSTRAINT [DF_LanguageMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_LanguageMaster] PRIMARY KEY CLUSTERED ([LanguageMasterId] ASC)
);

