-- =============================================
-- Author:		<Author,,Darpan>
-- Create date: <Create Date,,29-May-2017>
-- Description:	<Description,,nan.InsertOrUpdateEmployerDetails>
-- =============================================
CREATE PROCEDURE [nan].[InsertOrUpdateEmployerDetails]
@EmployerId BIGINT,
@EmployerTitle NVARCHAR(50),
@EmployerFirstName NVARCHAR(50),
@EmployerSureName NVARCHAR(50),
@EmployerAddress1 NVARCHAR(250),
@EmployerAddress2 NVARCHAR(250),
@EmployerPostCode INT,
@EmployerCountry NVARCHAR(50),
@EmployerPhoneNumber INT,
@EmployeeStartDate DATE,
@EmployeeDetails BIT,
@EmployeeTitle NVARCHAR(50),
@EmployeeFirstName NVARCHAR(50),
@EmployeeSurName NVARCHAR(50),
@EmployeeAddress NVARCHAR(250),
@EmployeePostCode INT,
@EmployeePhoneNumber INT,
@EmployeeEmail NVARCHAR(50),
@NationalInsuranceNumber NVARCHAR(50),
@EmployeeDateOfBirth DATE,
@PayingYourNanny BIT,
@NetOrGross BIT,
@WeeklyOrMonthly BIT,
@NanntStartDate DATE,
@WorkOtherThenYou BIT,
@Employer BIT,
@ContractEmployment BIT,
@Information NVARCHAR(250),
@TermsAndCondition BIT,
@UserId BIGINT,
@PageId BIGINT
AS
BEGIN
	
	SET NOCOUNT ON;
	 DECLARE @InsertedId BIGINT;
        IF EXISTS ( SELECT  EmployerId
                    FROM    nan.EmployerDetails
                    WHERE   EmployerFirstName = @EmployerFirstName
                            AND EmployerId != @EmployerId
                            AND IsDeleted = 0 )
            BEGIN
                SET @InsertedId = -1;
                SELECT  ISNULL(@InsertedId, -1) AS InsertedId;
            END;
        
        ELSE
	BEGIN 
		IF(@EmployerId = 0)
		BEGIN
			INSERT INTO nan.EmployerDetails
			        ( EmployerTitle ,
			          EmployerFirstName ,
			          EmployerSureName ,
			          EmployerAddress1 ,
			          EmployerAddress2 ,
			          EmployerPostCode ,
			          EmployerCountry ,
			          EmployerPhoneNumber ,
			          EmployeeStartDate ,
			          EmployeeDetails ,
			          EmployeeTitle ,
			          EmployeeFirstName ,
			          EmployeeSurName ,
			          EmployeeAddress ,
			          EmployeePostCode ,
			          EmployeePhoneNumber ,
			          EmployeeEmail ,
			          NationalInsuranceNumber ,
			          EmployeeDateOfBirth ,
			          PayingYourNanny ,
			          NetOrGross ,
			          WeeklyOrMonthly ,
			          NanntStartDate ,
			          WorkOtherThenYou ,
			          Employer ,
			          ContractEmployment ,
			          Information ,
			          TermsAndCondition ,
			          CreatedOn ,
			          CreatedBy ,
			          IsDeleted
			        )
			VALUES  ( 
					@EmployerTitle,
					@EmployerFirstName,
					@EmployerSureName,
					@EmployerAddress1,
					@EmployerAddress2,
					@EmployerPostCode,
					@EmployerCountry,
					@EmployerPhoneNumber,
					@EmployeeStartDate,
					@EmployeeDetails,
					@EmployeeTitle,
					@EmployeeFirstName,
					@EmployeeSurName,
					@EmployeeAddress,
					@EmployeePostCode,
					@EmployeePhoneNumber,
					@EmployeeEmail,
					@NationalInsuranceNumber,
					@EmployeeDateOfBirth,
					@PayingYourNanny,
					@NetOrGross,
					@WeeklyOrMonthly,
					@NanntStartDate,
					@WorkOtherThenYou,
					@Employer,
					@ContractEmployment,
					@Information,
					@TermsAndCondition,
					GETDATE(),
					@UserId,
					0
			        );
					SELECT  @EmployerId = SCOPE_IDENTITY();
					INSERT  INTO nan.ActivityLog
                                ( UserId ,
                                  PageId ,
                                  AuditComments ,
                                  TableName ,
                                  RecordId ,
                                  CreatedOn ,
                                  CreatedBy ,
                                  IsDeleted
                                )
                        VALUES  ( @UserId ,
                                  @PageId ,
                                  'Insert record in table AreaMaster' ,
                                  'AreaMaster' ,
                                  @EmployerId ,
                                  GETDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
                ELSE
                    BEGIN
						UPDATE  ED
						SET EmployerTitle = @EmployerTitle,
                        EmployerFirstName = @EmployerFirstName,
                        EmployerSureName = @EmployerSureName,
						EmployerAddress1 = @EmployerAddress1,
						EmployerAddress2 = @EmployerAddress2,
						EmployerPostCode = @EmployerPostCode,
						EmployerCountry = @EmployerCountry, 
						EmployerPhoneNumber = @EmployerPhoneNumber,
						EmployeeStartDate = @EmployeeStartDate,
						EmployeeDetails = @EmployeeDetails,
						EmployeeTitle = @EmployeeTitle,
						EmployeeFirstName = @EmployeeFirstName,
						EmployeeSurName = @EmployeeSurName,
						EmployeeAddress = @EmployeeAddress,
						EmployeePostCode = @EmployeePostCode,
						EmployeePhoneNumber = @EmployeePhoneNumber,
						EmployeeEmail = @EmployeeEmail,
						NationalInsuranceNumber = @NationalInsuranceNumber,
						EmployeeDateOfBirth = @EmployeeDateOfBirth,
						PayingYourNanny = @PayingYourNanny,
						NetOrGross = @NetOrGross,
						WeeklyOrMonthly = @WeeklyOrMonthly,
						NanntStartDate = @NanntStartDate,
						WorkOtherThenYou = @WorkOtherThenYou,
						Employer = @Employer,
						ContractEmployment = @ContractEmployment,
						Information = @Information,
						TermsAndCondition = @TermsAndCondition,
						UpdatedOn = GETDATE(),
						UpdatedBy = @UserId
						FROM nan.EmployerDetails AS ED
						WHERE EmployerId = @EmployerId
						INSERT  INTO nan.ActivityLog
                                ( UserId ,
                                  PageId ,
                                  AuditComments ,
                                  TableName ,
                                  RecordId ,
                                  CreatedOn ,
                                  CreatedBy ,
                                  IsDeleted
                                )
                        VALUES  ( @UserId ,
                                  @PageId ,
                                  'Update record in table AreaMaster' ,
                                  'AreaMaster' ,
                                  @EmployerId ,
                                  GETDATE() ,
                                  @UserId ,
                                  0
                                );
                    END;
			
                SET @InsertedId = @EmployerId;
                SELECT  ISNULL(@InsertedId, 0) AS InsertedId;
            END;
END