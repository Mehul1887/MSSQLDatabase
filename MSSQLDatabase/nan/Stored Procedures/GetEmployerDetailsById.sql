-- =============================================
-- Author:		<Author,,Darpan>
-- Create date: <Create Date,,29-May-2017>
-- Description:	<Description,,>
-- Call SP:     [nan].[GetEmployerDetailsById]
-- =============================================
CREATE PROCEDURE [nan].[GetEmployerDetailsById] @EmployerId BIGINT
AS
    BEGIN
	
        SET NOCOUNT ON;
        SELECT  EmployerTitle ,
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
                TermsAndCondition
        FROM    nan.EmployerDetails
        WHERE   EmployerId = @EmployerId;

    END;