--SELECT dbo.AmountToWordConvert(0.26)
--SELECT dbo.AmountToWordConvert(1.26)
--select dbo.AmountToWordConvert(19600)
CREATE FUNCTION [dbo].[AmountToWordConvert] ( @amt NUMERIC(15, 2) )
RETURNS VARCHAR(5000)
AS 
    BEGIN
        DECLARE @Rps BIGINT ,
            @Ps INT ,
            @amtstr VARCHAR(5000)

        --On Error Resume Next
        IF @amt > 100000000000000 
            BEGIN
                RETURN ''
            END
        
        SET @Ps = ( @amt % 1 ) * 100
        SET @Rps = FLOOR(@amt)
        IF @Rps > 0
            AND @Ps > 0 
            BEGIN
        
        
                SET @amtstr = dbo.NumberToWordsConvert(@Rps) + ' Rupees And '
                    + dbo.NumberToWordsConvert(@Ps) + ' Paisa Only '
            END
        
        ELSE 
            IF @Rps > 0
                AND @Ps = 0 
                BEGIN
        
        
                    SET @amtstr = dbo.NumberToWordsConvert(@Rps)
                        + ' Rupees Only '
                END
            ELSE 
                IF @Rps = 0
                    AND @Ps > 0 
                    BEGIN
        
                        SET @amtstr = dbo.NumberToWordsConvert(@Ps)
                            + ' Paisa Only '
                    END
        RETURN @amtstr
    END