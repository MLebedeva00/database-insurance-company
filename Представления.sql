USE Insurance_Management;
GO


--ПРЕДСТАВЛЕНИЕ для оценки риска страхового случая и оценки репутации клиента
--CREATE VIEW vw_CustomerRiskAnalysis
--AS
--SELECT 
--    c.CustomerID,
--    CASE 
--        WHEN c.CompanyName IS NOT NULL THEN c.CompanyName
--        ELSE CONCAT(c.FirstName, ' ', c.LastName)
--    END AS CustomerName,
--    Case
--        WHEN c.CompanyName IS NOT NULL THEN 'Юридическое лицо'
--        ELSE 'Физическое лицо'
--    END AS CustomerType,
--    c.Age,
--    c.Gender,
--    c.DrivingYears,
--    c.AccidentsNumber,
--    c.RegionCode, 
--    p.PaymentStatus,

--    CASE 
--        WHEN p.PaymentStatus = 'Просрочен' AND c.AccidentsNumber >= 3 THEN 'Очень высокий риск. Отказать в последующей услуге'
--        WHEN p.PaymentStatus = 'Просрочен' AND c.AccidentsNumber = 2 THEN 'Высокий риск. Увеличить стоимость страховки'
--        WHEN p.PaymentStatus = 'Просрочен' AND c.AccidentsNumber < 2 THEN 'Средний риск. Рекомендовать стандартный пакет'

--        WHEN p.PaymentStatus = 'Ожидает оплаты' AND c.AccidentsNumber > 2 THEN 'Средний риск. Рекомендовать стандартный пакет'
--        WHEN p.PaymentStatus = 'Ожидает оплаты' AND c.AccidentsNumber <= 2 THEN 'Средний риск. Рекомендовать стандартный пакет'
--        WHEN p.PaymentStatus = 'Оплачен частично' AND c.AccidentsNumber > 2 THEN 'Средний риск. Рекомендовать стандартный пакет'
--        WHEN p.PaymentStatus = 'Оплачен частично' AND c.AccidentsNumber <= 2 THEN 'Низкий риск. Сделать скидку на услуги'
--        WHEN p.PaymentStatus = 'Оплачен' AND c.AccidentsNumber >= 3 THEN 'Средний риск. Рекомендовать стандартный пакет'
--        WHEN p.PaymentStatus = 'Оплачен' AND c.AccidentsNumber <= 2 THEN 'Низкий риск. Сделать скидку на услуги'
        
--    END AS Recommendation
    

    
--FROM Customer c
--LEFT JOIN Contract con ON c.CustomerID = con.CustomerID
--LEFT JOIN ContractDetail cd ON con.ContractDetailID = cd.ContractDetailID
--LEFT JOIN Payment p ON con.PaymentID = p.PaymentID
--GO

--select * from vw_CustomerRiskAnalysis


-- ПРЕДСТАВЛЕНИЕ для просмотра договоров, заключенных сотрудниками компании в текущем году
--CREATE VIEW vw_CurrentYearContracts
--AS
--SELECT 
--    -- Информация о договоре
--    con.ContractID AS ContractNumber,
--    con.ContractStartDate AS StartDate,
--    con.ContractEndDate AS EndDate,
--    DATEDIFF(DAY, GETDATE(), con.ContractEndDate) AS DaysUntilExpiry,
    
--    -- Статус договора
--    cd.ContractStatus,
    
--    -- Информация о клиенте
--    cus.CustomerID,
--    CASE 
--        WHEN cus.CompanyName IS NOT NULL THEN cus.CompanyName
--        ELSE CONCAT(cus.FirstName, ' ', cus.LastName)
--    END AS CustomerName,
--    CASE 
--        WHEN cus.CompanyName IS NOT NULL THEN 'Юридическое лицо'
--        ELSE 'Физическое лицо'
--    END AS CustomerType,
--    cus.Phone AS CustomerPhone,
--    cus.EmailAddress AS CustomerEmail,
--    cus.RegionCode,
    
--    -- Информация о менеджере (сотруднике)
--    m.ManagerID,
--    CONCAT(m.FirstName, ' ', m.LastName) AS ManagerName,
--    m.Phone AS ManagerPhone,
--    m.EmailAddress AS ManagerEmail,
    
--    -- Информация об объекте страхования
--    o.ObjectID,
--    oc.ObjectCategoryName AS ObjectCategory,
--    o.VIN,
--    o.ListPrice,
    
--    -- Информация о типе страхования
--    it.InsuranceTypeID,
--    it.TypeName AS InsuranceType,
    
--    -- Финансовая информация
--    cd.LineTotal AS ContractSum,
    
--    -- Информация о платеже
--    p.PaymentID,
--    p.PaymentStatus,      
    
--    -- Месяц заключения    
--    DATENAME(MONTH, con.ContractStartDate) AS MonthStart    
    
    
--FROM Contract con
--INNER JOIN Customer cus ON con.CustomerID = cus.CustomerID
--INNER JOIN Manager m ON con.ManagerID = m.ManagerID
--INNER JOIN ContractDetail cd ON con.ContractDetailID = cd.ContractDetailID
--INNER JOIN Object o ON cd.ObjectID = o.ObjectID
--INNER JOIN ObjectCategory oc ON o.ObjectCategoryID = oc.ObjectCategoryID
--INNER JOIN Model mod ON o.ModelID = mod.ModelID
--INNER JOIN InsuranceType it ON cd.InsuranceTypeID = it.InsuranceTypeID
--INNER JOIN Payment p ON con.PaymentID = p.PaymentID
--WHERE YEAR(con.ContractStartDate) = YEAR(GETDATE()) + 1  -- Только текущий год (2026)
--GO

--select * from vw_CurrentYearContracts


--ПРЕДСТАВЛЕНИЕ для просмотра количества активных контрактов у каждого менеджера

--CREATE VIEW vw_ManagerActiveContracts
--AS
--SELECT 
--    -- Информация о менеджере
--    m.ManagerID AS КодМенеджера,
--    CONCAT(m.FirstName, ' ', m.LastName) AS Менеджер,
--    m.Phone AS Телефон,
--    m.EmailAddress AS Email,
--    m.Salary AS Зарплата,
    
--    -- Количество активных контрактов
--    COUNT(DISTINCT con.ContractID) AS КоличествоАктивныхКонтрактов,
   
--     --Комментарий
--    CASE 
--        WHEN COUNT(DISTINCT con.ContractID) = 0 THEN 'Требуется активная работа'
--        WHEN COUNT(DISTINCT con.ContractID) >= 2 THEN 'Претендент на получение премии'
        
--        ELSE 'Работа в норме'
--    END AS 'Комментарий по работе менеджера'

--FROM Manager m
--LEFT JOIN Contract con ON m.ManagerID = con.ManagerID
--LEFT JOIN Customer cus ON con.CustomerID = cus.CustomerID
--LEFT JOIN ContractDetail cd ON con.ContractDetailID = cd.ContractDetailID
--Where cd.ContractStatus = 'Активен'  -- Только активные контракты
    
--GROUP BY 
--    m.ManagerID, 
--    m.FirstName, 
--    m.LastName, 
--    m.Phone, 
--    m.EmailAddress, 
--    m.Salary;
--GO

--select * from vw_ManagerActiveContracts