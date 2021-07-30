-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

--select Split ('asdfd,b,c,d,e',',')

CREATE FUNCTION [nan].[Split]
    (
      @RowData VARCHAR(8000) ,
      @SplitOn NVARCHAR(5)
    )
RETURNS @RtnValue TABLE
    (
      Id INT IDENTITY(1, 1) ,
      Data VARCHAR(8000)
    )
AS 
    BEGIN 
        DECLARE @Cnt INT
        SET @Cnt = 1

        WHILE ( CHARINDEX(@SplitOn, @RowData) > 0 ) 
            BEGIN
                INSERT  INTO @RtnValue
                        ( data 
                        )
                        SELECT  Data = LTRIM(RTRIM(SUBSTRING(@RowData, 1,
                                                             CHARINDEX(@SplitOn,
                                                              @RowData) - 1)))

                SET @RowData = SUBSTRING(@RowData,
                                         CHARINDEX(@SplitOn, @RowData) + 1,
                                         LEN(@RowData))
                SET @Cnt = @Cnt + 1
            END
	
        INSERT  INTO @RtnValue
                ( data )
                SELECT  Data = LTRIM(RTRIM(@RowData))

        RETURN
    END