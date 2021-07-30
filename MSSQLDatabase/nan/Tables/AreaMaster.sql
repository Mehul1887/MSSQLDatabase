CREATE TABLE [nan].[AreaMaster] (
    [AreaMasterId]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [AreaMasterName]  NVARCHAR (50) NULL,
    [CountryMatserId] BIGINT        NULL,
    [CreatedOn]       DATETIME      CONSTRAINT [DF_AreaMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]       BIGINT        NOT NULL,
    [UpdatedOn]       DATETIME      NULL,
    [UpdatedBy]       BIGINT        NULL,
    [DeletedOn]       DATETIME      NULL,
    [DeletedBy]       BIGINT        NULL,
    [IsDeleted]       BIT           CONSTRAINT [DF_AreaMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_AreaMaster] PRIMARY KEY CLUSTERED ([AreaMasterId] ASC),
    CONSTRAINT [FK_AreaMaster_CountryMaster] FOREIGN KEY ([CountryMatserId]) REFERENCES [nan].[CountryMaster] ([CountryMasterId])
);

