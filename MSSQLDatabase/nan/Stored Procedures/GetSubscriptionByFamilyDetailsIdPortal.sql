-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <17 Aug 2017>
-- Description:	<nan.GetSubscriptionByFamilyDetailsIdPortal>
-- Call SP    :	nan.GetSubscriptionByFamilyDetailsIdPortal 100,1,'','',45
-- =============================================
CREATE PROCEDURE [nan].[GetSubscriptionByFamilyDetailsIdPortal]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50) ,
    @FamilyDetailsId BIGINT
AS
    BEGIN
        SET NOCOUNT ON; 
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                FamilySubscriptionId ,
                SubscriptionMasterId ,
                FamilySubscriptionName ,
                SubscriptionMasterName ,
                StartDate ,
                EndDate ,
                SucbscriptionStatus ,
                Period
        FROM    ( SELECT    FS.FamilySubscriptionId AS FamilySubscriptionId ,
                            FS.SubscriptionMasterId AS SubscriptionMasterId ,
                            FS.FamilySubscriptionName AS FamilySubscriptionName ,
							FS.FamilySubscriptionName AS SubscriptionMasterName ,
                            nan.ChangeDateFormat(FS.StartDate, 'dd/mm/yyyy') AS StartDate ,
                            nan.ChangeDateFormat(FS.EndDate, 'dd/mm/yyyy') AS EndDate ,
                            CASE WHEN DATEDIFF(DAY, FS.EndDate, GETUTCDATE()) <= 0
                                 THEN 'Active'
                                 ELSE 'Expired'
                            END AS SucbscriptionStatus ,
                            DATEDIFF(DAY, FS.StartDate, FS.EndDate) AS Period ,
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY FS.FamilySubscriptionId DESC) AS RowNum
                  FROM      nan.FamilySubscription AS FS
                            LEFT JOIN nan.SubscriptionMaster AS SM ON SM.SubscriptionMasterId = FS.SubscriptionMasterId
                  WHERE     FS.FamilyDetailsId = @FamilyDetailsId
                            AND ISNULL(FS.IsDeleted, 0) = 0
                            --AND ( ISNULL(FS.FamilySubscriptionName, '') LIKE '%'
                            --      + @Search + '%'
                            --      OR ISNULL(SM.SubscriptionMasterName, '') LIKE '%'
                            --      + @Search + '%'
                            --      OR ISNULL(nan.ChangeDateFormat(FS.StartDate,
                            --                                  'dd/mm/yyyy'),
                            --                '') LIKE '%' + @Search + '%'
                            --      OR ISNULL(nan.ChangeDateFormat(FS.EndDate,
                            --                                  'dd/mm/yyyy'),
                            --                '') LIKE '%' + @Search + '%'
                            --      OR ISNULL(CASE WHEN DATEDIFF(DAY, FS.EndDate,
                            --                                  GETUTCDATE()) <= 0
                            --                     THEN 'OnGoing'
                            --                     ELSE 'Expired'
                            --                END, '') LIKE '%' + @Search + '%'
                            --      OR ISNULL(DATEDIFF(DAY, FS.StartDate,
                            --                         FS.EndDate), '') LIKE '%'
                            --      + @Search + '%'
                            --    )
                ) AS T
				ORDER BY T.FamilySubscriptionId DESC
       -- WHERE   RowNum BETWEEN @Start AND @End;
    END;