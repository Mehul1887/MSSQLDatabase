CREATE FUNCTION [nan].[fnGetLatLongDistanceMiles]
    (
      @Lat1 VARCHAR(30) ,
      @Lon1 VARCHAR(30) ,
      @Lat2 VARCHAR(30) ,
      @Lon2 VARCHAR(30)
    )
RETURNS FLOAT
AS
    BEGIN 
-- CONSTANTS
   DECLARE @geo1 geography = geography::Point(CAST(@Lat1 AS FLOAT), CAST(@Lon1 AS FLOAT), 4326),
        @geo2 geography = geography::Point(CAST(@Lat2 AS FLOAT), CAST(@Lon2 AS FLOAT), 4326)

 RETURN @geo1.STDistance(@geo2)*0.000621371192
END