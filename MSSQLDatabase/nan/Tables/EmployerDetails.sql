﻿CREATE TABLE [nan].[EmployerDetails] (
    [EmployerId]              BIGINT          NOT NULL,
    [EmployerTitle]           NVARCHAR (50)   NULL,
    [EmployerFirstName]       NVARCHAR (50)   NULL,
    [EmployerSureName]        NVARCHAR (50)   NULL,
    [EmployerEmailId]         NVARCHAR (50)   NULL,
    [ReplyDescription]        NVARCHAR (1000) NULL,
    [ReplyOnDate]             DATETIME        NULL,
    [Link]                    NVARCHAR (500)  NULL,
    [IsLinkActive]            BIT             NULL,
    [BillingAddress]          NVARCHAR (250)  NULL,
    [EmployerAddress1]        NVARCHAR (250)  NULL,
    [EmployerAddress2]        NVARCHAR (250)  NULL,
    [EmployerPostCode]        INT             NULL,
    [EmployerCountry]         NVARCHAR (50)   NULL,
    [EmployerPhoneNumber]     INT             NULL,
    [EmployeeStartDate]       DATE            NULL,
    [EmployeeDetails]         BIT             NULL,
    [EmployeeTitle]           NVARCHAR (50)   NULL,
    [EmployeeFirstName]       NVARCHAR (50)   NULL,
    [EmployeeSurName]         NVARCHAR (50)   NULL,
    [EmployeeAddress]         NVARCHAR (250)  NULL,
    [EmployeePostCode]        INT             NULL,
    [EmployeePhoneNumber]     INT             NULL,
    [EmployeeEmail]           NVARCHAR (50)   NULL,
    [NationalInsuranceNumber] NVARCHAR (50)   NULL,
    [EmployeeDateOfBirth]     DATE            NULL,
    [PayingYourNanny]         INT             NULL,
    [NetOrGross]              BIT             NULL,
    [WeeklyOrMonthly]         BIT             NULL,
    [NanntStartDate]          DATE            NULL,
    [WorkOtherThenYou]        BIT             NULL,
    [Employer]                BIT             NULL,
    [ContractEmployment]      BIT             NULL,
    [Information]             NVARCHAR (250)  NULL,
    [TermsAndCondition]       BIT             NULL,
    [CreatedOn]               DATETIME        NULL,
    [CreatedBy]               INT             NULL,
    [UpdatedOn]               DATETIME        NULL,
    [UpdatedBy]               INT             NULL,
    [DeletedOn]               DATETIME        NULL,
    [DeletedBy]               INT             NULL,
    [IsDeleted]               BIT             NULL
);
