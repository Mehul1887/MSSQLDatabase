﻿-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetAgencyDetailsAll>
-- Call SP    :	GetAgencyDetailsAll
-- =============================================
CREATE PROCEDURE [nan].[GetAgencyDetailsAll]
AS
    BEGIN
	SET NOCOUNT ON
        SELECT  [AD].[AgencyDetailsId] AS AgencyDetailsId ,
                [AD].[AgencyDetailsName] AS AgencyDetailsName ,
                [AD].[Address1] AS Address1 ,
                [AD].[Address2] AS Address2 ,
                [AD].[GoogleLat] AS GoogleLat ,
                [AD].[GoogleLong] AS GoogleLong ,
                [AD].[AreaId] AS AreaId ,              
                [AD].[PostCode] AS PostCode ,
                [AD].[Phone] AS Phone ,
                [AD].[Email] AS Email ,
                [AD].[Website] AS Website ,
                [AD].[ContactForm] AS ContactForm ,
                [AD].[IsProfileReviewed] AS IsProfileReviewed ,
                [AD].[IsDeleteProfile] AS IsDeleteProfile ,
                [AD].[DeleteProfileDateTime] AS DeleteProfileDateTime ,
                [AD].[IsActiveProfilebyAdmin] AS IsActiveProfilebyAdmin ,
                [AD].[IsActiveProfile] AS IsActiveProfile ,
                [AD].[ActiveProfileDateTime] AS ActiveProfileDateTime ,
                [AD].[CheckedTerms] AS CheckedTerms ,
                [AD].[IsSubscribeNewsletter] AS IsSubscribeNewsletter ,
                [AD].[LastLoginTime] AS LastLoginTime
        FROM    nan.[AgencyDetails] AS AD
        WHERE   [AD].IsDeleted = 0;
    END;