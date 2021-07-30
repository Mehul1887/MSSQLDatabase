-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 29-Apr-2017
-- Description:	
-- Call SP    :	
-- =============================================
CREATE PROCEDURE [nan].[ApproveAgency]
    @AgencyDetailsId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE  nan.AgencyDetails
        SET     IsProfileReviewed =1,
                UpdatedOn = GETUTCDATE()
        WHERE   AgencyDetailsId = @AgencyDetailsId;
   
    END;