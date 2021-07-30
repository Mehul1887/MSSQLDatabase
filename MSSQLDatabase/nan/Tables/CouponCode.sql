CREATE TABLE [nan].[CouponCode] (
    [CouponCodeId]   BIGINT         IDENTITY (1, 1) NOT NULL,
    [CouponCodeName] NVARCHAR (100) NULL,
    [CouponCode]     NVARCHAR (30)  NULL,
    [Discount]       DECIMAL (18)   NULL,
    [StartDate]      DATETIME       NULL,
    [EndDate]        DATETIME       NULL,
    [Description]    NVARCHAR (250) NULL,
    [TermsCondition] NVARCHAR (500) NULL,
    [CreatedOn]      DATETIME       CONSTRAINT [DF_CouponCode_CreatedOn] DEFAULT (getdate()) NOT NULL,
    [CreatedBy]      BIGINT         NOT NULL,
    [UpdatedOn]      DATETIME       NULL,
    [UpdatedBy]      BIGINT         NULL,
    [DeletedOn]      DATETIME       NULL,
    [DeletedBy]      BIGINT         NULL,
    [IsDeleted]      BIT            CONSTRAINT [DF_CouponCode_IsDeleted] DEFAULT ((0)) NOT NULL,
    [IsForAdvert]    BIT            NULL,
    [IsActive]       BIT            NULL,
    CONSTRAINT [PK_CouponCode] PRIMARY KEY CLUSTERED ([CouponCodeId] ASC)
);

