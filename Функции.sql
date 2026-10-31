USE Insurance_Management;
GO


-- ‘”Ќ ÷»я дл€ отслеживани€ договоров, требующих продлени€ (заканчивающихс€ в ближайшие 30 дней)

--CREATE FUNCTION GetContractsForRenewal()
--RETURNS TABLE
--AS
--RETURN
--(    
--    SELECT 
--        con.ContractID,
--        cus.FirstName AS CustomerFirstName,
--        cus.LastName AS CustomerLastName,
--        cus.CompanyName,
--        cus.Phone AS CustomerPhone,
--        cus.EmailAddress AS CustomerEmail,
--        m.FirstName AS ManagerFirstName,
--        m.LastName AS ManagerLastName,
--        con.ContractStartDate,
--        con.ContractEndDate,
--        DATEDIFF(DAY, GETDATE(), con.ContractEndDate) AS DaysUntilExpiry,
--        cd.ContractStatus,
--        cd.LineTotal AS ContractValue
--    FROM Contract con
--    INNER JOIN Customer cus ON con.CustomerID = cus.CustomerID
--    INNER JOIN Manager m ON con.ManagerID = m.ManagerID
--    INNER JOIN ContractDetail cd ON con.ContractDetailID = cd.ContractDetailID
--    WHERE 'Month(con.ContractEndDate)' +'Day(con.ContractEndDate)'+'Year(con.ContractEndDate)' BETWEEN cast(getdate() as nvarchar(25)) AND cast((DATEADD(DAY, 30, GETDATE())) as nvarchar(25))
--    AND cd.ContractStatus = 'јктивен'
--);
--GO

--select * from GetContractsForRenewal();


-- ‘”Ќ ÷»я дл€ расчета суммы контракта

--CREATE FUNCTION dbo.CalculateContractAmount
--(
--    @ObjectID INT,
--    @InsuranceTypeID INT
--)
--RETURNS NUMERIC(10,2)
--AS
--BEGIN
--    DECLARE @ListPrice NUMERIC(10,2);
--    DECLARE @ContractAmount NUMERIC(10,2);
    
--    -- ѕолучаем стоимость объекта страховани€
--    SELECT @ListPrice = ListPrice 
--    FROM Object 
--    WHERE ObjectID = @ObjectID;
    
        
--    -- –ассчитываем сумму контракта по правилам
--    SET @ContractAmount = 
--        CASE 
--            WHEN @InsuranceTypeID = 1 THEN @ListPrice * 0.02  -- ‘из лица: 2%
--            WHEN @InsuranceTypeID = 2 THEN @ListPrice * 0.01  -- ёр лица: 1%
            
--        END;
    
--    RETURN @ContractAmount;
--END;
--GO

--dbo - схема бд
--явное указание схемы (рекомендуетс€)

--SELECT 
--    dbo.CalculateContractAmount(1, 1) AS AmountForIndividual,  -- ‘из лицо
--    dbo.CalculateContractAmount(7, 2) AS AmountForCorporate;   -- ёр лицо

--select * from Object


-- ‘”Ќ ÷»я, котора€ рассчитывает сумму контракта с учетом скидки дл€ клиентов с водительским стажем более 10 лет:

--CREATE FUNCTION dbo.CalculateContractAmountWithDiscount
--(
--    @CustomerID INT,
--    @ObjectID INT
    
--)
--RETURNS NUMERIC(10,2)
--AS
--BEGIN
--    DECLARE @BaseAmount NUMERIC(10,2);
--    DECLARE @ListPrice NUMERIC(10,2);
--    DECLARE @DiscountRate DECIMAL(5,4) = 1.0;
--    DECLARE @DrivingYears INT;
    
--    -- ѕолучаем стоимость объекта страховани€
--    SELECT @ListPrice = ListPrice 
--    FROM Object 
--    WHERE ObjectID = @ObjectID;
        
    
--    -- Ѕазова€ ставка 
--    SET @BaseAmount = @ListPrice * 0.01          
    
    
--    IF @DrivingYears > 10 
--    BEGIN
--        SET @DiscountRate = 0.6;  -- 40% скидка (100% - 40% = 60% = 0.6)
--    END
    
    
--    RETURN @BaseAmount * @DiscountRate;
--END;
--GO

--select * from Customer

--SELECT 
--    dbo.CalculateContractAmountWithDiscount(1, 1) as DiscountPrice;
