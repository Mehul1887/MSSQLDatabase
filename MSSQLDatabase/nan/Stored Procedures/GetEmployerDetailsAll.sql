-- =============================================
-- Author:		<Author,,Darpan>
-- Create date: <Create Date,,29-May-2017>
-- Description:	<Description,,GetEmployerDetailsAll>
-- call SP: nan.GetEmployerDetailsAll
-- =============================================
CREATE PROCEDURE [nan].[GetEmployerDetailsAll]
AS
    BEGIN
	
        SET NOCOUNT ON;
        SELECT  EmployerId ,
                EmployerTitle ,
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
        FROM    nan.EmployerDetails;
    
    END;