

--ПРОЦЕДУРА для записи результата вычислений функции dbo.CalculateContractAmount 
--в столбец LineTotal (сумма контракта) таблицы ContractDetail

--CREATE PROCEDURE usp_UpdateAllContractAmounts
--AS
--BEGIN
--    SET NOCOUNT ON;                                 
--    SET XACT_ABORT ON;
    
--    BEGIN TRY
--        BEGIN TRANSACTION;
        
--        PRINT 'Начало обновления сумм контрактов...';
        
--        -- Обновляем все существующие записи в ContractDetail
--        UPDATE cd
--        SET cd.LineTotal = dbo.CalculateContractAmount(cd.ObjectID, cd.InsuranceTypeID)
--        FROM ContractDetail cd;
        
--        DECLARE @RowsUpdated INT = @@ROWCOUNT;
        
--        PRINT 'Обновлено ' + CAST(@RowsUpdated AS NVARCHAR(10)) + ' записей в таблице ContractDetail';
        
--        COMMIT TRANSACTION;
        
--        PRINT 'Обновление завершено успешно';
        
--    END TRY
--    BEGIN CATCH
--        ROLLBACK TRANSACTION;
        
--        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
--        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
--        DECLARE @ErrorState INT = ERROR_STATE();
        
--        PRINT 'Ошибка при обновлении: ' + @ErrorMessage;
        
--        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
--    END CATCH
--END;
--GO

-- Обновляем все существующие суммы контрактов
USE Insurance_Management;
GO
EXEC usp_UpdateAllContractAmounts;
select * from ContractDetail





--SET NOCOUNT ON;
-- Сообщение "(1 row(s) affected)" НЕ показывается
--SET XACT_ABORT ON;
--При ошибке SQL Server автоматически откатывает всю транзакцию
--Все три операции отменяются.Таблицы возвращаются в исходное состояние




--ПРОЦЕДУРА для заключения нового договора страхования

--CREATE PROCEDURE usp_CreateInsuranceContract1
--    @CustomerID INT,
--    @ManagerID INT,
--    @ObjectID INT,
--    @InsuranceTypeID INT,
--    @ContractStartDate nvarchar(25),
--    @ContractEndDate nvarchar(25),  
--    @PaymentStatus NVARCHAR(25),
--    @FinancialInfID INT
--AS
--BEGIN
--    SET NOCOUNT ON;
--    SET XACT_ABORT ON;    

--    BEGIN TRY
--        BEGIN TRANSACTION;     
        
--        -- Если финансовой информации нет, создаем новую запись
--        IF @FinancialInfID IS NULL
--        BEGIN
--            INSERT INTO FinancialInf (AccountNumber, Card, Bank)
--            VALUES (0, 0, 'Не указан');
            
--            SET @FinancialInfID = SCOPE_IDENTITY();
--        END


--        DECLARE @ListPrice NUMERIC(10,2);        
        
--        -- Получаем стоимость объекта
--        SELECT @ListPrice = ListPrice 
--        FROM Object 
--        WHERE ObjectID = @ObjectID;
        
--        Declare @ContractAmount numeric(10,2);
--        SET @ContractAmount = 
--        CASE 
--            WHEN @InsuranceTypeID = 1 THEN @ListPrice * 0.02  -- Физ лица: 2%
--            WHEN @InsuranceTypeID = 2 THEN @ListPrice * 0.01  -- Юр лица: 1%
            
--        END;

--        -- Создаем запись о платеже
--        DECLARE @PaymentID INT;
        
--        INSERT INTO Payment (FinancialInfID, PaymentStatus)
--        VALUES (@FinancialInfID, @PaymentStatus);
        
--        SET @PaymentID = SCOPE_IDENTITY();
        
--        -- Создаем детали договора
--        DECLARE @ContractDetailID INT;
        
--        INSERT INTO ContractDetail (ObjectID, InsuranceTypeID, ContractStatus, LineTotal)
--        VALUES (@ObjectID, @InsuranceTypeID, 'Активен', @ContractAmount);
        
--        SET @ContractDetailID = SCOPE_IDENTITY();
        
--        -- Создаем основной договор
--        DECLARE @ContractID INT;
        
--        INSERT INTO Contract (CustomerID, ManagerID, ContractDetailID, PaymentID, ContractStartDate, ContractEndDate)
--        VALUES (@CustomerID, @ManagerID, @ContractDetailID, @PaymentID, @ContractStartDate, @ContractEndDate);
        
--        SET @ContractID = SCOPE_IDENTITY();      
            
        
--        -- Возвращаем информацию о созданном договоре
--        SELECT 
--            @ContractID AS ContractID,
--            @ContractDetailID AS ContractDetailID,
--            @PaymentID AS PaymentID,
--            @ContractAmount AS ContractAmount,
--            @ContractStartDate AS ContractStartDate,
--            @ContractEndDate AS ContractEndDate,
--            'Договор успешно создан' AS Message;
        
--        COMMIT TRANSACTION;       

--    END TRY
--    BEGIN CATCH
--        ROLLBACK TRANSACTION;
        
--        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
--        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
--        DECLARE @ErrorState INT = ERROR_STATE();
        
--        PRINT 'Ошибка при обновлении: ' + @ErrorMessage;
        
--        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
--    END CATCH
--END;
--GO

--use Insurance_Management
--EXEC usp_CreateInsuranceContract1     
--    @CustomerID = 1,
--    @ManagerID = 1,
--    @ObjectID = 1,
--    @InsuranceTypeID = 1,
--    @ContractStartDate = '2027-01-15',
--    @ContractEndDate = '2028-01-15',
--    @PaymentStatus = 'Ожидает оплаты',
--    @FinancialInfID = Null;

--select * from contract;

--use Insurance_Management
--EXEC usp_CreateInsuranceContract1     
--    @CustomerID = 3,
--    @ManagerID = 5,
--    @ObjectID = 5,
--    @InsuranceTypeID = 2,
--    @ContractStartDate = '2027-02-15',
--    @ContractEndDate = '2028-02-15',
--    @PaymentStatus = 'Оплачен',
--    @FinancialInfID = Null;



-- ПРОЦЕДУРА для отчетности

--CREATE PROCEDURE usp_GenerateMonthlyReport
--    @Year INT = NULL,
--    @Month INT = NULL
--AS
--BEGIN
--    SET NOCOUNT ON;
    
--    -- Если год и месяц не указаны, используем предыдущий месяц
--    IF @Year IS NULL SET @Year = YEAR(DATEADD(MONTH, -1, GETDATE()));
--    IF @Month IS NULL SET @Month = MONTH(DATEADD(MONTH, -1, GETDATE()));       

--    -- Отчет по договорам
--    SELECT 
--        'Договоры за ' + CAST(@Month AS NVARCHAR(2)) + '.' + CAST(@Year AS NVARCHAR(4)) AS ReportTitle,
--        COUNT(DISTINCT c.ContractID) AS TotalContracts,
--        COUNT(DISTINCT c.CustomerID) AS NewCustomers,
--        COUNT(DISTINCT c.ManagerID) AS ActiveManagers,
--        SUM(cd.LineTotal) AS TotalRevenue,
--        AVG(cd.LineTotal) AS AverageContractValue,
--        MIN(c.ContractStartDate) AS FirstContractDate,
--        MAX(c.ContractStartDate) AS LastContractDate
--    FROM Contract c
--    INNER JOIN ContractDetail cd ON c.ContractDetailID = cd.ContractDetailID
--    WHERE YEAR(c.ContractStartDate) = @Year
--    AND MONTH(c.ContractStartDate) = @Month;
    
--    -- Отчет по менеджерам
--    SELECT 
--        m.ManagerID,
--        CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
--        COUNT(DISTINCT c.ContractID) AS ContractsCount,
--        SUM(cd.LineTotal) AS ManagerRevenue,
--        COUNT(DISTINCT c.CustomerID) AS CustomersServed,
--        RANK() OVER (ORDER BY SUM(cd.LineTotal) DESC) AS RevenueRank
--    FROM Manager m
--    LEFT JOIN Contract c ON m.ManagerID = c.ManagerID
--    LEFT JOIN ContractDetail cd ON c.ContractDetailID = cd.ContractDetailID
--    WHERE YEAR(c.ContractStartDate) = @Year
--    AND MONTH(c.ContractStartDate) = @Month
--    GROUP BY m.ManagerID, m.FirstName, m.LastName
--    ORDER BY ManagerRevenue DESC;
    
    
--    PRINT 'Отчет за ' + CAST(@Month AS NVARCHAR(2)) + '.' + CAST(@Year AS NVARCHAR(4)) + ' сгенерирован успешно';
--END;
--GO


--Use Insurance_Management
--EXEC usp_GenerateMonthlyReport @Year = 2026, @Month = 2;