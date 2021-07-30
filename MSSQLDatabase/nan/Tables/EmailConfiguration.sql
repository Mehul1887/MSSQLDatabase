CREATE TABLE [nan].[EmailConfiguration] (
    [Id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [ProfileName] NVARCHAR (50)  NOT NULL,
    [SMPTServer]  NVARCHAR (50)  NOT NULL,
    [UserName]    NVARCHAR (50)  NOT NULL,
    [Password]    NVARCHAR (50)  NOT NULL,
    [Port]        INT            NOT NULL,
    [EnableSSL]   BIT            NOT NULL,
    [DisplayName] NVARCHAR (100) NULL,
    [CreatedOn]   DATETIME       CONSTRAINT [DF_ConsEmailConfiguration_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]   BIGINT         NOT NULL,
    [UpdatedOn]   DATETIME       NULL,
    [UpdatedBy]   BIGINT         NULL,
    [DeletedOn]   DATETIME       NULL,
    [DeletedBy]   BIGINT         NULL,
    [IsDeleted]   BIT            CONSTRAINT [DF_ConsEmailConfiguration_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PKEmailConfiguration] PRIMARY KEY CLUSTERED ([Id] ASC)
);

