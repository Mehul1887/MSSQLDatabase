CREATE TABLE [nan].[EthnicityParentMaster] (
    [EthnicityParentMasterId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [EthnicityParentMasterName] NVARCHAR (30) NULL,
    [CreatedOn]                 DATETIME      CONSTRAINT [DF_EthnicityParentMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                 BIGINT        NOT NULL,
    [UpdatedOn]                 DATETIME      NULL,
    [UpdatedBy]                 BIGINT        NULL,
    [DeletedOn]                 DATETIME      NULL,
    [DeletedBy]                 BIGINT        NULL,
    [IsDeleted]                 BIT           CONSTRAINT [DF_EthnicityParentMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EthnicityParentMaster] PRIMARY KEY CLUSTERED ([EthnicityParentMasterId] ASC)
);

