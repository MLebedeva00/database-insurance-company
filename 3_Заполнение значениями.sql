USE Insurance_Management;
GO


-- 1. Категории ТС
--INSERT INTO ObjectCategory (ObjectCategoryName)
--VALUES
--('Легковой автомобиль'),
--('Грузовой автомобиль'),
--('Мотоцикл'),
--('Водный транспорт'),
--('Недвижимость');

--UPDATE ObjectCategory
--SET ObjectCategoryName = 'Автобусы'
--WHERE ObjectCategoryID = 5;

--select * FROM ObjectCategory 


-- 2. Виды тарифов
--INSERT INTO InsuranceType (TypeName)
--VALUES
--('Физическое лицо'),
--('Юридическое лицо');



-- 3. Модели автомобилей
--INSERT INTO Model (BrandName, ModelName, EnginePower, Year, Cost)
--VALUES
--('Toyota', 'Camry', 249, 2022, 3200000),
--('Hyundai', 'Solaris', 123, 2023, 1500000),
--('Lada', 'Vesta', 106, 2024, 1300000),
--('KIA', 'Rio', 123, 2023, 1600000),
--('BMW', 'X5', 340, 2021, 6500000),
--('GAZ', 'ГАЗель NEXT', 150, 2022, 2800000),
--('ВАЗ (Lada)', 'Niva Travel', 80, 2023, 1200000),
--('Honda', 'CBR600RR', 120, 2020, 800000),
--('Toyota', 'Land Cruiser 300', 409, 2023, 9500000);

INSERT INTO Model (BrandName, ModelName, EnginePower, Year, Cost)
VALUES
('Hyundai', 'D700', 409, 2023, 3600000)


-- 6. Рекомендации для клиентов
--INSERT INTO Recommendation (CustomerID, LetterText)
--VALUES
--(1, 'Уважаемый Иван! Учитывая ваш стаж вождения и историю, рекомендуем рассмотреть полный пакет КАСКО с франшизой для снижения стоимости.'),
--(3, 'Уважаемый Сергей! В связи с частыми авариями в прошлом, предлагаем программу "Защищенный водитель" с дополнительными занятиями. Скидка 5% при заключении договора.'),
--(6, 'Уважаемые партнеры из ООО "Грузоперевозки Плюс"! Для вашего автопарка оптимальным решением будет корпоративный полис КАСКО с учетом пробега.'),
--(2, 'Уважаемая Мария! Для молодой водительницы у нас есть специальный тариф "Начало пути" с пониженным коэффициентом.'),
--(4, 'Уважаемая Анна! Рекомендуем добавить в ваш полис ОСАГО опцию "Расширенная гражданская ответственность" для защиты от непредвиденных расходов.');

--ALTER TABLE FinancialInf ALTER COLUMN [AccountNumber] varchar(25) NOT NULL;  
--GO
--ALTER TABLE FinancialInf ALTER COLUMN [Card] varchar(25) NOT NULL;  
--GO

-- 7. Финансовая информация (счета клиентов/компаний)
--INSERT INTO FinancialInf (AccountNumber, Card, Bank)
--VALUES
--(40817810012345678901, 5555666677778888, 'Сбербанк'),
--(40817810023456789012, 4444333322221111, 'ВТБ'),
--(40702810034567890123, 4111111122223333, 'Альфа-Банк'),
--(40817810045678901234, 5111122233334444, 'Тинькофф'),
--(40702810056789012345, 3711111122223333, 'Газпромбанк'),
--(40702810067890123456, 5111155566667777, 'Открытие'),
--(40817810078901234567, 4111188899990000, 'Сбербанк'),
--(40702810089012345678, 5555000011112222, 'ВТБ');


-- 8. Платежи
--INSERT INTO Payment (FinancialInfID, PaymentStatus)
--VALUES
--(1, 'Оплачен'),
--(2, 'Ожидает оплаты'),
--(3, 'Оплачен частично'),
--(4, 'Оплачен'),
--(5,
--'Просрочен'),
--(6, 'Оплачен'),
--(7, 'Ожидает оплаты'),
--(8, 'Оплачен');

-- 9. Объекты страхования 
--INSERT INTO Object (ObjectCategoryID, ModelID, VIN, ListPrice)
--VALUES
--(1, 1, 'JTNBB46KX64012345', 3200000.00), -- Toyota Camry
--(1, 2, 'Z94CB41ABHR123456', 1500000.00), -- Hyundai Solaris
--(1, 4, 'Z94K241BCNR234567', 1600000.00), -- KIA Rio
--(2, 6, 'X9FGA310000123456', 2800000.00), -- GAZ ГАЗель (коммерц)
--(1, 5, 'WBAJF010X0GJ12345', 6500000.00), -- BMW X5 (коммерц)
--(3, 8, 'JH2SC4610YM123456', 800000.00),  -- Honda CBR - мотоцикл, завершен
--(1, 3, 'XTA219120K1234567', 1300000.00), -- Lada Vesta (коммерц)
--(1, 9, 'JTMCY7AJ0NJ123456', 9500000.00); -- Toyota LC300

INSERT INTO Object (ObjectCategoryID, ModelID, VIN, ListPrice)
VALUES
(1, 10, 'PTNBB46KX64012345', 6400000.00)

-- 10. Детали контракта
--INSERT INTO ContractDetail (ObjectID, InsuranceTypeID, ContractStatus)
--VALUES
---- Toyota Camry
--(1, 1, 'Активен'),  
---- Hyundai Solaris
--(2, 1, 'Активен'),
---- KIA Rio
--(3, 1, 'Активен'),
---- GAZ ГАЗель
--(4, 2, 'Активен'),
---- BMW X5
--(5, 2, 'Активен'),
----Honda CBR
--(6, 1, 'Завершен'),
----Lada Vesta
--(7, 2, 'Активен'),
----Toyota LC300
--(8, 1, 'Активен');

USE Insurance_Management;
GO
INSERT INTO ContractDetail (ObjectID, InsuranceTypeID, ContractStatus)
VALUES
(10, 1, 'Активен')

--Delete From ContractDetail;
--DBCC CHECKIDENT ('ContractDetail', RESEED, 0);
--ALTER TABLE ContractDetail DROP COLUMN LineTotal;
--select * from ContractDetail

--ALTER TABLE Contract ALTER COLUMN [ContractStartDate] varchar(25) NOT NULL;  
--GO
--ALTER TABLE Contract ALTER COLUMN [ContractEndDate] varchar(25) NOT NULL;  
--GO


-- 11. Заключенные контракты 
--INSERT INTO Contract (CustomerID, ManagerID, ContractDetailID, PaymentID, ContractStartDate, ContractEndDate)
--VALUES
---- Иван Смирнов страхует Toyota через Анну
--(1, 1, 1, 1, '2026-01-15', '2027-01-15'),
---- Мария Козлова страхует Hyundai через Дмитрия
--(2, 2, 2, 2, '2026-03-01', '2027-03-01'),
---- Сергей Попов страхует KIA Rio через Елену
--(3, 3, 3, 3, '2026-02-01', '2027-02-01'),
---- 'ООО "Грузоперевозки Плюс"' страхует GAZ ГАЗель через Алексея
--(6, 4, 4, 6, '2026-02-01', '2027-02-01'),
---- 'ИП Соколов А.В.' страхует BMW X5 через Алексея
--(7, 4, 5, 7, '2026-02-01', '2027-02-01'),
---- Анна Лебедева страховала Honda CBR через Ольгу (завершен)
--(4, 5, 6, 4, '2024-02-01', '2025-02-01'),
---- 'ООО "Такси Город"' страхует Lada Vesta через Ольгу 
--(8, 5, 7, 8, '2026-02-01', '2027-02-01'),
---- Александр Новиков страхует Toyota LC300 через Анну 
--(5, 1, 8, 5, '2026-02-01', '2027-02-01');



--delete from Contract;
--DBCC CHECKIDENT ('Contract', RESEED, 0);


-- 4. Менеджеры компании
--INSERT INTO Manager (FirstName, LastName, Salary, Phone, EmailAddress)
--VALUES
--('Анна', 'Иванова', 85000.00, '+7(912)345-67-89', 'a.ivanova@useinsurance.ru'),
--('Дмитрий', 'Петров', 92000.00, '+7(912)987-65-43', 'd.petrov@useinsurance.ru'),
--('Елена', 'Сидорова', 78000.00, '+7(912)555-12-34', 'e.sidorova@useinsurance.ru'),
--('Алексей', 'Кузнецов', 105000.00, '+7(912)777-88-99', 'a.kuznetsov@useinsurance.ru'),
--('Ольга', 'Васильева', 81000.00, '+7(912)333-44-55', 'o.vasileva@useinsurance.ru');

-- 5. Физические и юридические клиенты
--INSERT INTO Customer (FirstName, LastName, Age, Gender, DrivingYears, AccidentsNumber, CompanyName, INN, RegionCode, Phone, EmailAddress)
--VALUES
---- Физические лица
--('Иван', 'Смирнов', 35, 'Мужской', 12, 1, NULL, NULL, '77', '+7(916)123-45-67', 'ivan.smirnov@mail.ru'),
--('Мария', 'Козлова', 28, 'Женский', 6, 0, NULL, NULL, '78', '+7(911)234-56-78', 'maria.kozlova@gmail.com'),
--('Сергей', 'Попов', 45, 'Мужской', 20, 3, NULL, NULL, '50', '+7(925)345-67-89', 'sergey.popov@yandex.ru'),
--('Анна', 'Лебедева', 22, 'Женский', 2, 1, NULL, NULL, '77', '+7(903)456-78-90', 'anna.lebedeva@mail.ru'),
--('Александр', 'Новиков', 31, 'Мужской', 8, 0, NULL, NULL, '66', '+7(912)567-89-01', 'a.novikov@bk.ru'),

---- Юридические лица
--(NULL, NULL, NULL, NULL, NULL, NULL, 'ООО "Грузоперевозки Плюс"', '773456789012', '77', '+7(495)123-45-67', 'info@gruzoplus.ru'),
--(NULL, NULL, NULL, NULL, NULL, NULL, 'ИП Соколов А.В.', '500123456789', '50', '+7(910)987-65-43', 'ip.sokolov@mail.ru'),
--(NULL, NULL, NULL, NULL, NULL, NULL, 'ООО "Такси Город"', '774567890123', '77', '+7(495)234-56-78', 'dispatcher@taxi-city.ru');

