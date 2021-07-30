-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 24 Apr 2017>
-- Description:	<Description,,GetFamilySubscriptionAll>
-- Call SP    :	nan.SearchFamilySubscription 1, 1, '', ''
-- =============================================
CREATE PROCEDURE [nan].[SearchFamilySubscription]
    @Rows INT ,
    @Page INT ,
    @Search NVARCHAR(500) ,
    @Sort NVARCHAR(50)
AS
    BEGIN
		SET NOCOUNT ON
        DECLARE @Start AS INT ,
            @End INT;
        SET @Start = ( ( @Page * @Rows ) - @Rows ) + 1;
        SET @End = @Page * @Rows; 
        SELECT  RowNum ,
                Total ,
                FamilySubscriptionId ,
                FamilySubscriptionName ,
                FamilyDetailsName ,
				PeriodInDays,
				StartDate,
				EndDate
        FROM    (SELECT  FS.FamilySubscriptionId AS FamilySubscriptionId,
		FD.FamilyDetailsName AS FamilyDetailsName,
		FS.FamilySubscriptionName AS FamilySubscriptionName,
		ISNULL(convert(varchar(20),FS.StartDate, 103),'') AS StartDate,
	ISNULL(convert(varchar(20),FS.EndDate, 103),'') AS EndDate,	
	DATEDIFF(DAY,FS.StartDate,FS.EndDate) AS PeriodInDays,	
                            COUNT(*) OVER ( PARTITION BY 1 ) AS Total ,
                            ROW_NUMBER() OVER ( ORDER BY  CASE
                                                              WHEN @Sort = 'FamilyDetailsName Asc'
                                                              THEN [FD].[FamilyDetailsName]
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilyDetailsName DESC'
                                                              THEN [FD].[FamilyDetailsName]
															  ELSE ''
															   END DESC, CASE
                                                              WHEN @Sort = 'FamilySubscriptionName Asc'
                                                              THEN FS.FamilySubscriptionName
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'FamilySubscriptionName DESC'
                                                              THEN FS.FamilySubscriptionName
															  ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'StartDate Asc'
                                                              THEN ISNULL(convert(varchar(20),FS.StartDate, 103),'')
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'StartDate DESC'
                                                              THEN ISNULL(convert(varchar(20),FS.StartDate, 103),'')
															  ELSE ''
                                                              END DESC,
															   CASE
                                                              WHEN @Sort = 'EndDate Asc'
                                                              THEN ISNULL(convert(varchar(20),FS.EndDate, 103),'')
															  ELSE ''
                                                              END ASC, CASE
                                                              WHEN @Sort = 'EndDate DESC'
                                                              THEN ISNULL(convert(varchar(20),FS.EndDate, 103),'')
															  ELSE ''
                                                              END DESC
															  , CASE
                                                              WHEN @Sort = 'PeriodInDays Asc'
                                                              THEN DATEDIFF(DAY,FS.StartDate,FS.EndDate)
															  ELSE 0
                                                              END ASC, CASE
                                                              WHEN @Sort = 'PeriodInDays DESC'
                                                              THEN DATEDIFF(DAY,FS.StartDate,FS.EndDate)
															  ELSE 0
                                                              END DESC
															   ) AS RowNum
                  FROM      nan.[FamilySubscription] AS FS
							INNER JOIN nan.FamilyDetails AS FD ON FD.FamilyDetailsId = [FS].FamilyDetailsId							
                  WHERE     [FS].IsDeleted = 0
                            AND ( ISNULL([FS].[FamilySubscriptionName],
                                         '') LIKE '%' + @Search + '%'
                                  OR ISNULL([FD].[FamilyDetailsName],
                                            '') LIKE '%' + @Search + '%'
                                  OR ISNULL(ISNULL(convert(varchar(20),FS.StartDate, 103),''),
                                            '') LIKE '%' + @Search + '%'
											 OR ISNULL(ISNULL(convert(varchar(20),FS.EndDate, 103),''),
                                            '') LIKE '%' + @Search + '%'
											 OR ISNULL(CAST(DATEDIFF(DAY,FS.StartDate,FS.EndDate) AS VARCHAR(20)),
                                            '') LIKE '%' + @Search + '%'
											
                                )
                ) AS T
        WHERE   RowNum BETWEEN @Start AND @End;
    END;