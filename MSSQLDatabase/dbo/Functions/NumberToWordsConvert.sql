CREATE FUNCTION [dbo].[NumberToWordsConvert] ( @arg NUMERIC(15) )
RETURNS VARCHAR(5000)
AS 
    BEGIN
	-- Declare the return variable here
        DECLARE @Mappings TABLE
            (
              aIndex INT ,
              aValue VARCHAR(100)
            )
        DECLARE @temp VARCHAR(100)
        DECLARE @t1 NUMERIC(15) ,
            @t2 NUMERIC(15)
        DECLARE @ret_str VARCHAR(5000)
        SET @ret_str = ''
        INSERT  INTO @Mappings
        VALUES  ( 0, '' )
        INSERT  INTO @Mappings
        VALUES  ( 1, 'One' )
        INSERT  INTO @Mappings
        VALUES  ( 2, 'Two' )
        INSERT  INTO @Mappings
        VALUES  ( 3, 'Three' )
        INSERT  INTO @Mappings
        VALUES  ( 4, 'Four' )
        INSERT  INTO @Mappings
        VALUES  ( 5, 'Five' )
        INSERT  INTO @Mappings
        VALUES  ( 6, 'Six' )
        INSERT  INTO @Mappings
        VALUES  ( 7, 'Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 8, 'Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 9, 'Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 10, 'Ten' )
        INSERT  INTO @Mappings
        VALUES  ( 11, 'Eleven' )
        INSERT  INTO @Mappings
        VALUES  ( 12, 'Twelve' )
        INSERT  INTO @Mappings
        VALUES  ( 13, 'Thirteen' )
        INSERT  INTO @Mappings
        VALUES  ( 14, 'Fourteen' )
        INSERT  INTO @Mappings
        VALUES  ( 15, 'Fifteen' )
        INSERT  INTO @Mappings
        VALUES  ( 16, 'Sixteen' )
        INSERT  INTO @Mappings
        VALUES  ( 17, 'Seventeen' )
        INSERT  INTO @Mappings
        VALUES  ( 18, 'Eighteen' )
        INSERT  INTO @Mappings
        VALUES  ( 19, 'Nineteen;' )
        INSERT  INTO @Mappings
        VALUES  ( 20, 'Twenty' )
        INSERT  INTO @Mappings
        VALUES  ( 21, 'Twenty One;' )
        INSERT  INTO @Mappings
        VALUES  ( 22, 'Twenty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 23, 'Twenty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 24, 'Twenty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 25, 'Twenty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 26, 'Twenty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 27, 'Twenty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 28, 'Twenty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 29, 'Twenty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 30, 'Thirty' )
        INSERT  INTO @Mappings
        VALUES  ( 31, 'Thirty One' )
        INSERT  INTO @Mappings
        VALUES  ( 32, 'Thirty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 33, 'Thirty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 34, 'Thirty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 35, 'Thirty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 36, 'Thirty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 37, 'Thirty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 38, 'Thirty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 39, 'Thirty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 40, 'Fourty' )
        INSERT  INTO @Mappings
        VALUES  ( 41, 'Fourty One' )
        INSERT  INTO @Mappings
        VALUES  ( 42, 'Fourty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 43, 'Fourty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 44, 'Fourty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 45, 'Fourty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 46, 'Fourty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 47, 'Fourty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 48, 'Fourty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 49, 'Fourty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 50, 'Fifty' )
        INSERT  INTO @Mappings
        VALUES  ( 51, 'Fifty One' )
        INSERT  INTO @Mappings
        VALUES  ( 52, 'Fifty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 53, 'Fifty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 54, 'Fifty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 55, 'Fifty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 56, 'Fifty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 57, 'Fifty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 58, 'Fifty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 59, 'Fifty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 60, 'Sixty' )
        INSERT  INTO @Mappings
        VALUES  ( 61, 'Sixty One' )
        INSERT  INTO @Mappings
        VALUES  ( 62, 'Sixty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 63, 'Sixty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 64, 'Sixty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 65, 'Sixty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 66, 'Sixty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 67, 'Sixty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 68, 'Sixty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 69, 'Sixty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 70, 'Seventy' )
        INSERT  INTO @Mappings
        VALUES  ( 71, 'Seventy One' )
        INSERT  INTO @Mappings
        VALUES  ( 72, 'Seventy Two' )
        INSERT  INTO @Mappings
        VALUES  ( 73, 'Seventy Three' )
        INSERT  INTO @Mappings
        VALUES  ( 74, 'Seventy Four' )
        INSERT  INTO @Mappings
        VALUES  ( 75, 'Seventy Five' )
        INSERT  INTO @Mappings
        VALUES  ( 76, 'Seventy Six' )
        INSERT  INTO @Mappings
        VALUES  ( 77, 'Seventy Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 78, 'Seventy Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 79, 'Seventy Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 80, 'Eighty' )
        INSERT  INTO @Mappings
        VALUES  ( 81, 'Eighty One' )
        INSERT  INTO @Mappings
        VALUES  ( 82, 'Eighty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 83, 'Eighty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 84, 'Eighty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 85, 'Eighty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 86, 'Eighty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 87, 'Eighty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 88, 'Eighty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 89, 'Eighty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 90, 'Ninty' )
        INSERT  INTO @Mappings
        VALUES  ( 91, 'Ninty One' )
        INSERT  INTO @Mappings
        VALUES  ( 92, 'Ninty Two' )
        INSERT  INTO @Mappings
        VALUES  ( 93, 'Ninty Three' )
        INSERT  INTO @Mappings
        VALUES  ( 94, 'Ninty Four' )
        INSERT  INTO @Mappings
        VALUES  ( 95, 'Ninty Five' )
        INSERT  INTO @Mappings
        VALUES  ( 96, 'Ninty Six' )
        INSERT  INTO @Mappings
        VALUES  ( 97, 'Ninty Seven' )
        INSERT  INTO @Mappings
        VALUES  ( 98, 'Ninty Eight' )
        INSERT  INTO @Mappings
        VALUES  ( 99, 'Ninty Nine' )
        INSERT  INTO @Mappings
        VALUES  ( 100, 'Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 200, 'Two Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 300, 'Three Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 400, 'Four Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 500, 'Five Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 600, 'Six Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 700, 'Seven Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 800, 'Eight Hundred' )
        INSERT  INTO @Mappings
        VALUES  ( 900, 'Nine Hundred' )
        
        
                
        IF @arg >= 10000000 
            BEGIN
                SET @t1 = @arg % 10000000
                SET @t2 = FLOOR(@arg / 10000000)
                SET @ret_str = dbo.NumberToWordsConvert(@t2) + ' Crore '
                    + dbo.NumberToWordsConvert(@t1)
            END
        
        ELSE 
            IF @arg >= 100000 
                BEGIN
                    SET @t1 = @arg % 100000
                    SET @t2 = FLOOR(@arg / 100000)
                    SELECT  @temp = aValue
                    FROM    @Mappings
                    WHERE   aIndex = @t2
                    SET @ret_str = @temp + ' Lakh '
                        + dbo.NumberToWordsConvert(@t1)
                END
                
            ELSE 
                IF @arg >= 1000 
                    BEGIN
                        SET @t1 = @arg % 1000
                        SET @t2 = FLOOR(@arg / 1000)
                        SELECT  @temp = aValue
                        FROM    @Mappings
                        WHERE   aIndex = @t2
                        SET @ret_str = @temp + ' Thousand '
                            + dbo.NumberToWordsConvert(@t1)
                    END
		
                ELSE 
                    IF @arg >= 100 
                        BEGIN
                            SET @t1 = @arg % 100
                            SET @t2 = @arg - @t1
                            SELECT  @temp = aValue
                            FROM    @Mappings
                            WHERE   aIndex = @t2
                            SET @ret_str = @ret_str + @temp + ' '
                                + dbo.NumberToWordsConvert(@t1)
                        END
                    ELSE 
                        IF @arg < 100 
                            BEGIN
                                SELECT  @temp = aValue
                                FROM    @Mappings
                                WHERE   aIndex = @arg
                                SET @ret_str = @ret_str + @temp + ' '
                            END

        RETURN UPPER(RTRIM(@ret_str))

    END