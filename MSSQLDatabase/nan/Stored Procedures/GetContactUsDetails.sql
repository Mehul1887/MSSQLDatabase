-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<nan.GetContactUsDetails>
-- Call SP    :	nan.GetContactUsDetails
-- =============================================
CREATE PROCEDURE [nan].[GetContactUsDetails]
AS
    BEGIN
        SET NOCOUNT ON; 
        DECLARE @Address NVARCHAR(500) ,
            @MobileNo NVARCHAR(50) ,
            @Email NVARCHAR(100) ,
            @Website NVARCHAR(100);

        SELECT  @Address = ISNULL(ACS.KeyValue, '') FROM  nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName = 'ContactUsAddress'
		SELECT  @Email = ISNULL(ACS.KeyValue, '') FROM  nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName = 'ContactUsEmail'
		SELECT  @MobileNo = ISNULL(ACS.KeyValue, '') FROM  nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName = 'ContactUsMobileNo'
		SELECT  @Website = ISNULL(ACS.KeyValue, '') FROM  nan.AAAAConfigSettings AS ACS WHERE ACS.KeyName = 'ContactUsWebsite'

        SELECT  ISNULL(@Address, '') AS Address ,
                ISNULL(@Email, '') AS Email ,
                ISNULL(@MobileNo, '') AS MobileNo ,
                ISNULL(@Website, '') AS Website;
    END;