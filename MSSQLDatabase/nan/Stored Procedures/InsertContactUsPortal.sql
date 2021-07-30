-- =============================================
-- Author:		<Sanjay Chaudhary>
-- Create date: <17 Aug 2014>
-- Description:	<nan.InsertContactUsPortal>
-- Call SP    :	nan.InsertContactUsPortal
-- =============================================
CREATE PROCEDURE [nan].[InsertContactUsPortal]
    @Id BIGINT ,
    @FirstName NVARCHAR(50) ,
	@LastName NVARCHAR(50),
    @Subject NVARCHAR(500) ,
    @BodyText NVARCHAR(max) ,	
    @EmailId NVARCHAR(50) ,    
	@ContactNo NVARCHAR(20),
	@IsPayroll BIT,
    @UserId BIGINT ,
    @PageId BIGINT
AS
    BEGIN
	SET NOCOUNT ON    
            INSERT INTO nan.ContactUs
                    (ContactUsName,
                      Name ,
                      EmailId ,
                      ContactNo ,
                      Subject ,
                      BodyText ,
                      IsRead ,
                      IsReply ,
                      IsPayroll ,                      
                      CreatedOn ,
                      CreatedBy ,                      
                      IsDeleted
                    )
            VALUES  ( @FirstName,
                      @FirstName+' '+@LastName , -- Name - nvarchar(50)
                      @EmailId , -- EmailId - nvarchar(50)
                      @ContactNo , -- ContactNo - nvarchar(50)
                      @Subject , -- Subject - nvarchar(50)
                      @BodyText , -- BodyText - nvarchar(max)
                      0 , -- IsRead - bit
                      0 , -- IsReply - bit
                      @IsPayroll , -- IsPayroll - bit                                            
                      GETUTCDATE() , -- CreatedOn - datetime
                      @UserId , -- CreatedBy - bigint                      
                      0  -- IsDeleted - bit
                    )

					SELECT @Id=SCOPE_IDENTITY()                
        SELECT  ISNULL(@Id, 0) AS InsertedId;
    END;