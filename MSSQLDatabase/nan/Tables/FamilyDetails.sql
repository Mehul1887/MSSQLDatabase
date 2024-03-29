﻿CREATE TABLE [nan].[FamilyDetails] (
    [FamilyDetailsId]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [FamilyDetailsName]      NVARCHAR (100) NULL,
    [FirstName]              NVARCHAR (100) NULL,
    [LastName]               NVARCHAR (100) NULL,
    [HaveNanny]              INT            NULL,
    [EthnicityChildMasterId] BIGINT         NULL,
    [LanguageMasterId]       NVARCHAR (500) NULL,
    [Email]                  NVARCHAR (50)  NULL,
    [PhoneNumber]            NVARCHAR (50)  NULL,
    [Mobile]                 NVARCHAR (20)  NULL,
    [Password]               NVARCHAR (100) NULL,
    [ContactTime]            NVARCHAR (100) NULL,
    [PhoneNumberVisible]     BIT            NULL,
    [Address1]               NVARCHAR (250) NULL,
    [Address2]               NVARCHAR (250) NULL,
    [GoogleLat]              NVARCHAR (20)  NULL,
    [GoogleLong]             NVARCHAR (20)  NULL,
    [CityName]               NVARCHAR (100) NULL,
    [CountryMasterId]        BIGINT         NULL,
    [CountyName]             NVARCHAR (100) NULL,
    [HaveSmoker]             BIT            NULL,
    [NoOfChildren]           INT            NULL,
    [ChildrenAge1]           NVARCHAR (50)  NULL,
    [ChildrenGender1]        BIT            NULL,
    [ChildrenAge2]           NVARCHAR (50)  NULL,
    [ChildrenGender2]        BIT            NULL,
    [NannyAvailableDate]     DATETIME       NULL,
    [NannyRequired]          INT            NULL,
    [HavePet]                BIT            NULL,
    [PetDetails]             NVARCHAR (500) NULL,
    [PostCode]               NVARCHAR (20)  NULL,
    [IsDeleteProfile]        BIT            NOT NULL,
    [DeleteProfileDateTime]  DATETIME       NULL,
    [IsActiveProfilebyAdmin] BIT            NULL,
    [IsActiveProfile]        BIT            NULL,
    [ActiveProfileDateTime]  DATETIME       NULL,
    [CheckedTerms]           BIT            NULL,
    [IsSubscribeNewsletter]  BIT            NULL,
    [Description]            NVARCHAR (500) NULL,
    [ProfileViews]           BIGINT         NULL,
    [ProfileImage]           NVARCHAR (500) NULL,
    [LastLoginTime]          DATETIME       NULL,
    [RegisterBy]             VARCHAR (10)   NULL,
    [CreatedOn]              DATETIME       CONSTRAINT [DF_FamilyDetails_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]              BIGINT         NOT NULL,
    [UpdatedOn]              DATETIME       NULL,
    [UpdatedBy]              BIGINT         NULL,
    [DeletedOn]              DATETIME       NULL,
    [DeletedBy]              BIGINT         NULL,
    [IsDeleted]              BIT            CONSTRAINT [DF_FamilyDetails_IsDeleted] DEFAULT ((0)) NOT NULL,
    CONSTRAINT [PK_FamilyDetails] PRIMARY KEY CLUSTERED ([FamilyDetailsId] ASC),
    CONSTRAINT [FK_FamilyDetails_EthnicityChildMaster] FOREIGN KEY ([EthnicityChildMasterId]) REFERENCES [nan].[EthnicityChildMaster] ([EthnicityChildMasterId])
);

