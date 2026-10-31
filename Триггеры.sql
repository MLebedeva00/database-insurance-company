USE Insurance_Management;
GO

 
-- Таблица архива клиентов
--CREATE TABLE CustomerArchive
--(
--    ArchiveID int IDENTITY PRIMARY KEY NOT NULL,
--    CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
--    FirstName nvarchar(25) NULL,
--    LastName nvarchar(25) NULL,    
--    Age int NULL,
--    Gender nvarchar(10) NULL,
--    DrivingYears int NULL,
--    AccidentsNumber int NULL,
--    CompanyName nvarchar(50) NULL,
--    INN nvarchar(50) NULL,
--    RegionCode nvarchar(25) NOT NULL,
--    Phone nvarchar(25) NOT NULL,
--    EmailAddress nvarchar(50) NOT NULL,
--    ArchivedDate DATETIME DEFAULT GETDATE(),
--    ArchiveReason nvarchar(100) NULL
--);
--GO

-- Триггер, который будет автоматически архивировать клиентов
--CREATE TRIGGER trg_ArchiveCustomer
--ON ContractDetail
--AFTER INSERT, UPDATE, DELETE
--AS
--BEGIN
--    SET NOCOUNT ON;
    
--    -- Архивация клиентов, у которых нет активных договоров в текущем году
--    DECLARE @CurrentYear INT = YEAR(GETDATE()) + 1;
    
--    -- Вставляем в архив клиентов, которые есть в базе, но у них нет договоров в текущем году
--    -- и которые еще не находятся в архиве
--    INSERT INTO CustomerArchive (
--        CustomerID, FirstName, LastName, Age, Gender, DrivingYears, 
--        AccidentsNumber, CompanyName, INN, RegionCode, Phone, EmailAddress, 
--        ArchiveReason
--    )
--    SELECT 
--        c.CustomerID,
--        c.FirstName,
--        c.LastName,
--        c.Age,
--        c.Gender,
--        c.DrivingYears,
--        c.AccidentsNumber,
--        c.CompanyName,
--        c.INN,
--        c.RegionCode,
--        c.Phone,
--        c.EmailAddress,
--        'No active contracts in current year'
--    FROM Customer c
--    WHERE NOT EXISTS (
--        -- Нет активных договоров в текущем году
--        SELECT 1 
--        FROM Contract con
--        INNER JOIN ContractDetail cd ON con.ContractDetailID = cd.ContractDetailID
--        WHERE con.CustomerID = c.CustomerID
--        AND YEAR(con.ContractStartDate) >= @CurrentYear
--        AND cd.ContractStatus = 'Активен'

--    );
    
--END;
--GO

--drop TRIGGER trg_ArchiveCustomer
--select * from ContractDetail
--select * from Contract
select * from CustomerArchive

--inserted — временная таблица в памяти, доступная только внутри триггера

-- Триггер для предотвращения дублирования объектов страхования по VIN
--CREATE TRIGGER trg_PreventDuplicateObject
--ON Object
--INSTEAD OF INSERT
--AS
--BEGIN
--    SET NOCOUNT ON;
    
--    DECLARE @DuplicateFound BIT = 0;
--    DECLARE @DuplicateVIN NVARCHAR(25);
    
--    -- Проверяем наличие дубликатов VIN среди вставляемых записей
--    IF EXISTS (
--        SELECT 1
--        FROM inserted i
--        GROUP BY i.VIN
--        HAVING COUNT(*) > 1
--    )
--    BEGIN
--        SET @DuplicateFound = 1;
--        SELECT TOP 1 @DuplicateVIN = i.VIN 
--        FROM inserted i 
--        GROUP BY i.VIN 
--        HAVING COUNT(*) > 1;
        
--        declare @t NVARCHAR(60) = 'Duplicate VIN found within the inserted records: ' + @DuplicateVIN;
--        THROW 50003, @t, 1;
--        RETURN;
--    END
    
--    -- Проверяем наличие дубликатов VIN в существующей таблице
--    IF EXISTS (
--        SELECT 1
--        FROM inserted i
--        INNER JOIN Object o ON i.VIN = o.VIN
--    )
--    BEGIN
--        SET @DuplicateFound = 1;
--        SELECT TOP 1 @DuplicateVIN = i.VIN 
--        FROM inserted i 
--        INNER JOIN Object o ON i.VIN = o.VIN;
        
--        -- Создаем сообщение об ошибке с информацией о дубликате
--        DECLARE @ErrorMessage NVARCHAR(200) = 
--            'Object with VIN "' + @DuplicateVIN + '" already exists in the database. ' +
--            'Duplicate VIN numbers are not allowed.';
        
--        THROW 50004, @ErrorMessage, 1;
--        RETURN;
--    END
    
--    -- Если дубликатов нет, выполняем вставку
--    IF @DuplicateFound = 0
--    BEGIN
--        INSERT INTO Object (ObjectCategoryID, ModelID, VIN, ListPrice)
--        SELECT ObjectCategoryID, ModelID, VIN, ListPrice
--        FROM inserted;
        
--        PRINT 'Object(s) successfully inserted: ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' record(s)';
--    END
--END;
--GO

--select * from Object

-- Проверка работы триггера
--INSERT INTO Object (ObjectCategoryID, ModelID, VIN, ListPrice)
--VALUES (1, 1, 'JTNBB46KX64012345', 3200000.00);


-- Триггер для автоматического создания писем с рекомендациями при истечении срока договора
--CREATE TRIGGER trg_CreateRecommendationOnContractExpiry
--ON Contract
--AFTER UPDATE
--AS
--BEGIN
--    SET NOCOUNT ON;
    
--    -- Проверяем, изменилась ли дата окончания договора
--    IF UPDATE(ContractEndDate) OR UPDATE(ContractDEtailID)
--    BEGIN
--        -- Создаем рекомендации для договоров, которые истекли или истекают в ближайшие 30 дней
--        INSERT INTO Recommendation (CustomerID, LetterText)
--        SELECT 
--            i.CustomerID,
--            CONCAT(
--                'Уважаемый клиент! ',
--                CASE 
--                    WHEN DATEDIFF(DAY, GETDATE(), i.ContractEndDate) <= 0 
--                        THEN 'Ваш договор страхования №' + CAST(i.ContractID AS NVARCHAR(10)) + ' истек.'
--                    ELSE 'Ваш договор страхования №' + CAST(i.ContractID AS NVARCHAR(10)) + 
--                         ' истекает через ' + CAST(DATEDIFF(DAY, GETDATE(), i.ContractEndDate) AS NVARCHAR(10)) + ' дней.'
--                END,
--                ' Рекомендуем продлить страховку для продолжения защиты. ',
--                'Свяжитесь с вашим менеджером для получения специальных условий продления.'
--            ) AS LetterText
--        FROM inserted i
--        INNER JOIN deleted d ON i.ContractID = d.ContractID
--        WHERE 
--            -- Проверяем, что договор активен
--            EXISTS (
--                SELECT 1 
--                FROM ContractDetail cd 
--                WHERE cd.ContractDetailID = i.ContractDetailID 
--                AND cd.ContractStatus = 'Активен'
--            )
--            AND (
--                -- Договор истек
--                i.ContractEndDate <= GETDATE() 
--                OR 
--                -- Договор истекает в ближайшие 30 дней
--                (i.ContractEndDate BETWEEN GETDATE() AND DATEADD(DAY, 30, GETDATE()))
--            )
--            -- Исключаем договоры, для которых уже созданы рекомендации в последние 7 дней
--            AND NOT EXISTS (
--                SELECT 1 
--                FROM Recommendation r 
--                WHERE r.CustomerID = i.CustomerID 
--                AND r.LetterText LIKE '%договор страхования №' + CAST(i.ContractID AS NVARCHAR(10)) + '%'
--                AND DATEDIFF(DAY, r.RecommendationID, GETDATE()) <= 7 -- Предполагаем, что RecommendationID автоинкрементный
--            );
        
--        -- Логируем созданные рекомендации
--        IF @@ROWCOUNT > 0
--        BEGIN
--            PRINT 'Created ' + CAST(@@ROWCOUNT AS NVARCHAR(10)) + ' recommendation letter(s) for expiring contracts';
--        END
--    END
--END;
--GO



--.................
--Логирование (от англ. "log" — журнал, запись) — это процесс систематической записи информации 
--о событиях, действиях и состояниях в работе программного обеспечения или системы.
--Логирование для мониторинга работы триггера

--@@ROWCOUNT - системная переменная SQL Server
--возвращает количество строк, затронутых последним оператором

