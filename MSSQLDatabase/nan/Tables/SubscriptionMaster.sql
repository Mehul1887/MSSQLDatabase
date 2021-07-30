CREATE TABLE [nan].[SubscriptionMaster] (
    [SubscriptionMasterId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [SubscriptionMasterName] NVARCHAR (100) NULL,
    [SubscriptionPeriod]     BIGINT         NULL,
    [Price]                  DECIMAL (18)   NULL,
    [CreatedOn]              DATETIME       CONSTRAINT [DF_SubscriptionMaster_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              BIGINT         NOT NULL,
    [UpdatedOn]              DATETIME       NULL,
    [UpdatedBy]              BIGINT         NULL,
    [DeletedOn]              DATETIME       NULL,
    [DeletedBy]              BIGINT         NULL,
    [IsDeleted]              BIT            CONSTRAINT [DF_SubscriptionMaster_IsDeleted] DEFAULT ((0)) NOT NULL,
    [IsActive]               BIT            NULL,
    CONSTRAINT [PK_SubscriptionMaster] PRIMARY KEY CLUSTERED ([SubscriptionMasterId] ASC)
);

