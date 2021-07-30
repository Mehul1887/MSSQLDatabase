CREATE TABLE [nan].[CustomerAuthentication] (
    [CustomerAuthenticationId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [CustomerAuthenticationName] NVARCHAR (50)  NULL,
    [CustomerId]                 BIGINT         NULL,
    [CustomerToken]              NVARCHAR (250) NULL,
    [IsFamily]                   BIT            NULL,
    [CreatedOn]                  DATETIME       CONSTRAINT [DF_CustomerAuthentication_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]                  BIGINT         NOT NULL,
    [UpdatedOn]                  DATETIME       NULL,
    [UpdatedBy]                  BIGINT         NULL,
    [DeletedOn]                  DATETIME       NULL,
    [DeletedBy]                  BIGINT         NULL,
    [IsDeleted]                  BIT            CONSTRAINT [DF_CustomerAuthentication_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_CustomerAuthentication] PRIMARY KEY CLUSTERED ([CustomerAuthenticationId] ASC)
);

