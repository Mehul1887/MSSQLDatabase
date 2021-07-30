-- =============================================
-- Author: Sanjay Chaudhary		
-- Create date: 29-Apr-2017
-- Description:	
-- Call SP    :	
-- =============================================
CREATE PROCEDURE [nan].[ChangeAgencyStatus]
    @Status BIT ,
    @AgencyDetailsId BIGINT
AS
    BEGIN
        SET NOCOUNT ON;

        UPDATE  nan.AgencyDetails
        SET     IsActiveProfilebyAdmin = @Status ,
				IsActiveProfile=@Status,
                ActiveProfileDateTime = GETUTCDATE()
        WHERE   AgencyDetailsId = @AgencyDetailsId;
   
    END;