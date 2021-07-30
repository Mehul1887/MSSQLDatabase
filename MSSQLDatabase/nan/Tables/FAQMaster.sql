CREATE TABLE [nan].[FAQMaster] (
    [FAQMasterId]   BIGINT          IDENTITY (1, 1) NOT NULL,
    [FAQMasterName] NVARCHAR (100)  NULL,
    [FaqQuestion]   NVARCHAR (500)  NULL,
    [FaqAnswer]     NVARCHAR (1000) NULL,
    [CreatedOn]     DATETIME        CONSTRAINT [DF_FAQMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]     BIGINT          NOT NULL,
    [UpdatedOn]     DATETIME        NULL,
    [UpdatedBy]     BIGINT          NULL,
    [DeletedOn]     DATETIME        NULL,
    [DeletedBy]     BIGINT          NULL,
    [IsDeleted]     BIT             CONSTRAINT [DF_FAQMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    [IsActive]      BIT             NULL,
    [Sequence]      INT             NULL,
    CONSTRAINT [PK_FAQMaster] PRIMARY KEY CLUSTERED ([FAQMasterId] ASC)
);

