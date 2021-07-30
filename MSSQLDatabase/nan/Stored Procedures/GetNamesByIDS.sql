-- =============================================================================
-- Author:		Jignesh Prajapati
-- Create date: 21/Jun/2012
-- Description:	Set Purchase Order No  for PO
-- Call Sp:		
--				DECLARE @PoNumber Varchar(50)
--				EXEC PurchaseOrderAutoId_sel @PoNumber OUTPUT
--				SELECT @PoNumber
-- exec GetNamesByIDS 'Color','ColorId','16,17,18,19'
-- =============================================================================
CREATE PROCEDURE [nan].[GetNamesByIDS]
    @TableName VARCHAR(MAX) ,
    @ForeignId VARCHAR(MAX) ,
    @Parameter VARCHAR(MAX)
AS
BEGIN
    DECLARE @Query NVARCHAR(MAX)= '';

    SET @Query = 'SELECT ' + @TableName + 'Name from ' + @TableName
        + ' Where ' + @ForeignId + ' in (select data from nan.split('''
        + @Parameter + ''', '',''))';
    PRINT @Query;
    DECLARE @resultSet AS TABLE ( NAME VARCHAR(MAX) NULL );
	SET NOCOUNT ON
    INSERT  INTO @resultSet
            ( NAME 
            )
            EXEC ( @Query
                );		     
    DECLARE @listStr NVARCHAR(MAX);
    SELECT  @listStr = ( COALESCE(@listStr + ',', '') + CONVERT(VARCHAR(MAX), NAME) )
    FROM    @resultSet; 
    SELECT  @listStr AS Result;


	END