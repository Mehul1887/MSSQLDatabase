-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <16 Aug 2017>
-- Description:	<nan.GetEmailCountByFamilyId>
-- Call SP    :	nan.GetEmailCountByFamilyId 45
-- =============================================
CREATE PROCEDURE [nan].[GetEmailCountByFamilyId]
    @FamilyDetailId BIGINT
AS
    BEGIN
        SET NOCOUNT ON; 
        DECLARE @UnReadCount BIGINT;
        SELECT  @UnReadCount= COUNT(1)
        FROM    nan.MailBox AS MB
        WHERE   ISNULL(MB.IsTrash, 0) = 0
                AND ISNULL(MB.IsRead, 0) = 0
                AND ISNULL(MB.IsDeleted, 0) = 0
				AND ISNULL(MB.IsTrash,0)=0
				AND ISNULL(MB.IsDraft,0)=0
                AND MB.ToID = @FamilyDetailId;
      
				SELECT ISNULL(@UnReadCount,0) AS UnReadCount
    END;