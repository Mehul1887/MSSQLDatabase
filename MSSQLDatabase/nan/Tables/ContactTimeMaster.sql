CREATE TABLE [nan].[ContactTimeMaster] (
    [ContactTimeMasterId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [ContactTimeMasterName] NVARCHAR (50) NULL,
    [ContactTime]           NVARCHAR (20) NULL,
    [CreatedOn]             DATETIME      CONSTRAINT [DF_ContactTimeMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]             BIGINT        NOT NULL,
    [UpdatedOn]             DATETIME      NULL,
    [UpdatedBy]             BIGINT        NULL,
    [DeletedOn]             DATETIME      NULL,
    [DeletedBy]             BIGINT        NULL,
    [IsDeleted]             BIT           CONSTRAINT [DF_ContactTimeMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_ContactTimeMaster] PRIMARY KEY CLUSTERED ([ContactTimeMasterId] ASC)
);

