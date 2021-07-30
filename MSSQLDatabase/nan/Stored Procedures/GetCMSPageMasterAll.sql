﻿-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetCMSPageMasterAll>
-- Call SP    :	GetCMSPageMasterAll
-- =============================================
CREATE PROCEDURE [nan].[GetCMSPageMasterAll]
AS
    BEGIN
	SET NOCOUNT ON
        SELECT  [CMS].[CMSPageMasterId] AS CMSPageMasterId ,
                [CMS].[CMSPageMasterName] AS CMSPageMasterName ,
                [CMS].[PageContent] AS PageContent ,
                [CMS].[PageMasterId] AS PageMasterId ,
                [CMS].[Title] AS Title ,
                [CMS].[Keywords] AS Keywords ,
                [CMS].[Description] AS Description
        FROM    nan.[CMSPageMaster] AS CMS
        WHERE   [CMS].IsDeleted = 0;
    END;