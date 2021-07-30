-- =============================================
-- Author:		<Author,,ADMIN>
-- Create date: <Create Date,, 18 Oct 2014>
-- Description:	<Description,,GetErrorLogAll>
-- Call SP    :	GetErrorLogAll
-- =============================================
CREATE PROCEDURE [nan].[GetErrorLogAll]
AS
    BEGIN
	SET NOCOUNT ON;
        SELECT  [EL].[Id] AS Id ,
                [EL].[PageId] AS PageId ,
                [P].PageName ,
                [EL].[MethodName] AS MethodName ,
                [EL].[ErrorType] AS ErrorType ,
                [EL].[ErrorMessage] AS ErrorMessage ,
                [EL].[ErrorDetails] AS ErrorDetails ,
                [EL].[ErrorDate] AS ErrorDate ,
                [EL].[UserId] AS UserId ,
                [EL].[Solution] AS Solution
        FROM    nan.[ErrorLog] AS EL
                INNER JOIN nan.[Page] AS P ON [P].Id = [EL].PageId
        WHERE   [EL].IsDeleted = 0;
    END;