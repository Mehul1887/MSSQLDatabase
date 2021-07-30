CREATE TABLE [nan].[FamilySubscription] (
    [FamilySubscriptionId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [FamilySubscriptionName] NVARCHAR (100) NULL,
    [FamilyDetailsId]        BIGINT         NULL,
    [SubscriptionMasterId]   BIGINT         NULL,
    [StartDate]              DATETIME       NULL,
    [EndDate]                DATETIME       NULL,
    [CreatedOn]              DATETIME       CONSTRAINT [DF_FamilySubscription_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              BIGINT         NOT NULL,
    [UpdatedOn]              DATETIME       NULL,
    [UpdatedBy]              BIGINT         NULL,
    [DeletedOn]              DATETIME       NULL,
    [DeletedBy]              BIGINT         NULL,
    [IsDeleted]              BIT            CONSTRAINT [DF_FamilySubscription_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_FamilySubscription] PRIMARY KEY CLUSTERED ([FamilySubscriptionId] ASC),
    CONSTRAINT [FK_FamilySubscription_FamilyDetails] FOREIGN KEY ([FamilyDetailsId]) REFERENCES [nan].[FamilyDetails] ([FamilyDetailsId]),
    CONSTRAINT [FK_FamilySubscription_SubscriptionMaster] FOREIGN KEY ([SubscriptionMasterId]) REFERENCES [nan].[SubscriptionMaster] ([SubscriptionMasterId])
);

