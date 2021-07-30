CREATE TABLE [nan].[EthnicityChildMaster] (
    [EthnicityChildMasterId]   BIGINT        IDENTITY (1, 1) NOT NULL,
    [EthnicityChildMasterName] NVARCHAR (30) NULL,
    [CreatedOn]                DATETIME      CONSTRAINT [DF_EthnicityChildMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                BIGINT        NOT NULL,
    [UpdatedOn]                DATETIME      NULL,
    [UpdatedBy]                BIGINT        NULL,
    [DeletedOn]                DATETIME      NULL,
    [DeletedBy]                BIGINT        NULL,
    [IsDeleted]                BIT           CONSTRAINT [DF_EthnicityChildMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_EthnicityChildMaster] PRIMARY KEY CLUSTERED ([EthnicityChildMasterId] ASC)
);

