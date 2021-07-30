CREATE TABLE [nan].[UploadDocuments] (
    [UploadDocumentsId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [UploadDocumentsName] NVARCHAR (100) NULL,
    [FamilyDetailsId]     BIGINT         NULL,
    [DocumentPath]        NVARCHAR (250) NULL,
    [CreatedOn]           DATETIME       CONSTRAINT [DF_UploadDocuments_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]           BIGINT         NOT NULL,
    [UpdatedOn]           DATETIME       NULL,
    [UpdatedBy]           BIGINT         NULL,
    [DeletedOn]           DATETIME       NULL,
    [DeletedBy]           BIGINT         NULL,
    [IsDeleted]           BIT            CONSTRAINT [DF_UploadDocuments_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_UploadDocuments] PRIMARY KEY CLUSTERED ([UploadDocumentsId] ASC)
);

