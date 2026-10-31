Use Insurance_Management;
GO

CREATE TABLE Customer
(
    CustomerID int IDENTITY PRIMARY KEY NOT NULL,

    FirstName nvarchar(25) NULL,
    LastName nvarchar(25) NULL,    
    Age int NULL,
    Gender nvarchar(10) NULL,
    DrivingYears int NULL,
    AccidentsNumber int NULL,

    CompanyName nvarchar(50) NULL,
    INN nvarchar(50) NULL,

    RegionCode nvarchar(25) NOT NULL,
    Phone nvarchar(25) NOT NULL,
    EmailAddress nvarchar(50) NOT NULL
);
GO


CREATE TABLE Recommendation
(
    RecommendationID int IDENTITY PRIMARY KEY NOT NULL,
    CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
    LetterText nvarchar(400) NOT NULL
);
GO


CREATE TABLE Manager
(
    ManagerID int IDENTITY PRIMARY KEY NOT NULL,
    FirstName nvarchar(25) NOT NULL,
    LastName nvarchar(25) NOT NULL,
    Salary numeric(10,2) NOT NULL,
    Phone nvarchar(25) NOT NULL,
    EmailAddress nvarchar(50) NOT NULL
);
GO


CREATE TABLE FinancialInf
(
    FinancialInfID int IDENTITY PRIMARY KEY NOT NULL,
    AccountNumber int NOT NULL,
    Card int NOT NULL,
    Bank nvarchar(25) NOT NULL
);
GO

CREATE TABLE Payment
(
    PaymentID int IDENTITY PRIMARY KEY NOT NULL,
    FinancialInfID INT NOT NULL REFERENCES FinancialInf(FinancialInfID),
    PaymentStatus nvarchar(25) NOT NULL
);
GO


CREATE TABLE Model
(
    ModelID int IDENTITY PRIMARY KEY NOT NULL,
    BrandName nvarchar(25) NOT NULL,
    ModelName nvarchar(25) NOT NULL,
    EnginePower INT NOT NULL,
    Year INT NOT NULL,
    Cost INT NOT NULL
);
GO

CREATE TABLE ObjectCategory
(
    ObjectCategoryID int IDENTITY PRIMARY KEY NOT NULL,
    ObjectCategoryName nvarchar(25) NOT NULL
);
GO

CREATE TABLE Object
(
    ObjectID int IDENTITY PRIMARY KEY NOT NULL,
    ObjectCategoryID INT NOT NULL REFERENCES ObjectCategory(ObjectCategoryID),
    ModelID INT NOT NULL REFERENCES Model(ModelID),    
    VIN nvarchar(25) NOT NULL,
    ListPrice numeric(10,2) NOT NULL
);
GO

CREATE TABLE InsuranceType
(
    InsuranceTypeID int IDENTITY PRIMARY KEY NOT NULL,
    TypeName nvarchar(25) NOT NULL
);
GO

CREATE TABLE ContractDetail
(
    ContractDetailID int IDENTITY PRIMARY KEY NOT NULL,
    ObjectID INT NOT NULL REFERENCES Object(ObjectID),
    InsuranceTypeID INT NOT NULL REFERENCES InsuranceType(InsuranceTypeID),
    ContractStatus nvarchar(25) NOT NULL,
    LineTotal numeric(10,2) NOT NULL
);
GO

CREATE TABLE Contract
(
    ContractID int IDENTITY PRIMARY KEY NOT NULL,
    CustomerID INT NOT NULL REFERENCES Customer(CustomerID),
    ManagerID INT NOT NULL REFERENCES Manager(ManagerID),
    ContractDetailID INT NOT NULL REFERENCES ContractDetail(ContractDetailID),        
    PaymentID INT NOT NULL REFERENCES Payment(PaymentID),
    ContractStartDate DATETIME NOT NULL,
    ContractEndDate DATETIME NOT NULL

);
GO
