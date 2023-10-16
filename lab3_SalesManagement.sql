CREATE DATABASE SalesManagementSystem
GO

USE SalesManagementSystem
GO

-- Country table #####################
--- 1.Create
CREATE TABLE dbo.Country
    (CountryCode varchar(3) PRIMARY KEY NOT NULL,
    CountryName varchar(100) NULL)
GO

-- 2.Insert 
INSERT INTO  dbo.Country(CountryCode, CountryName) VALUES ('INA', 'Indonesia');
INSERT INTO  dbo.Country(CountryCode, CountryName) VALUES ('JPN', 'Japan');
INSERT INTO  dbo.Country(CountryCode, CountryName) VALUES ('MAS', 'Malaysia');
GO

-- 3.Create Procedure
CREATE PROCEDURE SelectAllCountries
AS
SELECT * FROM dbo.Country
GO;

-- 4.Execute
EXEC SelectAllCountries

-- Customer table #####################
-- Purpose: Stores all the registered customer details 
-- 1.Create
CREATE TABLE dbo.Customer (
    CustID VARCHAR(5) PRIMARY KEY,
    CustName VARCHAR(100) NOT NULL,
    PhoneNumber VARCHAR(12),
    Email VARCHAR(200),
    Country VARCHAR(3) DEFAULT 'MAS' REFERENCES dbo.Country(CountryCode),
    Gender VARCHAR(6) CHECK (Gender IN ('Female', 'Male')),
    PaymentCardNumber VARCHAR(100),
    PassportNumber VARCHAR(50),
    UserID VARCHAR(200)
)
GO

-- 2.Insert 
INSERT INTO  dbo.Customer(CustID, CustName, PhoneNumber, Email, Country, Gender, PaymentCardNumber, PassportNumber, UserID) VALUES ('C0001', 'John', '01245611789', 'john@gmail.com', 'MAS', 'Male', '0116567011656767', 'A189796986', 'U100');
INSERT INTO  dbo.Customer(CustID, CustName, PhoneNumber, Email, Country, Gender, PaymentCardNumber, PassportNumber, UserID) VALUES ('C0002', 'Nancy', '01245611789', 'nancy@email.com', 'MAS', 'Female', '567011667011656767', 'B975596986', 'U200');
GO

-- 3.Create Procedure
CREATE PROCEDURE SelectAllCustomers
AS
SELECT * FROM dbo.Customer
GO;

-- 4.Execute
EXEC SelectAllCustomers


-- ProductCategory table #####################
-- Purpose: Stores all the product category code and name relevant to this system
-- 1.Create
CREATE TABLE dbo.ProductCategory
    (CategoryCode varchar(5) PRIMARY KEY NOT NULL,
    CategoryName varchar(100) NULL)
GO

-- 2.Insert
INSERT INTO dbo.ProductCategory (CategoryCode, CategoryName) 
VALUES ('IT', 'IT Hardware');

INSERT INTO dbo.ProductCategory (CategoryCode, CategoryName) 
VALUES ('SP', 'Sports');

INSERT INTO dbo.ProductCategory (CategoryCode, CategoryName) 
VALUES ('ST', 'Stationary');
GO

-- 3.Create Procedure
CREATE PROCEDURE SelectAllProductCategories
AS
SELECT * FROM dbo.ProductCategory

-- 4.Execute
EXEC SelectAllProductCategories

-- Product table #####################
-- Purpose: Stores all the product registered in the system that are available for sales
-- 1.Create
CREATE TABLE dbo.Product (
    ProductCode varchar(10) PRIMARY KEY,
    ProductName varchar(100) NOT NULL,
    ProductCategory varchar(5) REFERENCES dbo.ProductCategory(CategoryCode),
    CostPrice decimal(8,2) CHECK (CostPrice > 0),
    SalePrice decimal(8,2) CHECK (SalePrice > 0),
    Countrycode varchar(3) DEFAULT 'MAS' REFERENCES dbo.Country(CountryCode)
)
GO

-- 2.Insert 
INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('IT100', 'Acer Laptop', 'IT', 1200.00, 1500.00, 'JPN');

INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('IT200', 'Lenovo Laptop', 'IT', 2000.00, 2500.00, 'INA');

INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('SP100', 'Yonex Badminton Racket', 'SP', 50.00, 105.00, 'MAS');

INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('SP200', 'Adidas Football', 'SP', 35.00, 145.00, 'MAS');

INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('ST100', 'Test Pad', 'ST', 2.50, 4.00, 'INA');

INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('ST200', 'File Folder', 'ST', 4.50, 6.00, 'INA');

INSERT INTO dbo.Product(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, Countrycode) 
VALUES('ST300', 'Stapler', 'ST', 3.50, 5.30, 'INA');
GO

-- 3.Create Procedure
CREATE PROCEDURE SelectAllProducts
AS
SELECT * FROM dbo.Product

-- 4.Execute
EXEC SelectAllProducts

-- CustomerPurchase table #####################
-- Purpose: Records all the high-level transaction details for a purchase
-- 1.Create
CREATE TABLE dbo.CustomerPurchase(
    PurchaseId int PRIMARY KEY IDENTITY,
    CustID varchar(5) NOT NULL REFERENCES dbo.Customer(CustID),
    PurchaseDate DateTime DEFAULT GETDATE()
    )
GO

-- 2.Insert 
SET IDENTITY_INSERT dbo.CustomerPurchase ON;

INSERT INTO dbo.CustomerPurchase(PurchaseId, CustID, PurchaseDate)
VALUES(1, 'C0001', '2023-08-08 10:55:30.440');

INSERT INTO dbo.CustomerPurchase(PurchaseId, CustID, PurchaseDate) 
VALUES(2, 'C0002', '2023-08-18 10:55:30.443');
GO

SET IDENTITY_INSERT dbo.CustomerPurchase OFF;
GO

-- 3.Create Procedure
CREATE PROCEDURE SelectAllCustomerPurchases
AS
SELECT * FROM dbo.CustomerPurchase

-- 4.Execute
EXEC SelectAllCustomerPurchases

-- CustomerPurchaseDetail table #####################
-- Purpose: records all the details of the product sold
-- 1.Create
CREATE TABLE dbo.CustomerPurchaseDetail(
    DetailPurchaseId int PRIMARY KEY IDENTITY,
    PurchaseId int REFERENCES dbo.CustomerPurchase(PurchaseId),
    ProductCode varchar(10) REFERENCES dbo.Product(ProductCode),
    PurchasePrice decimal(8,2),
    Quantity int default 1 check (Quantity > 0),
    Total AS (PurchasePrice * CAST(Quantity AS decimal(19,2))) PERSISTED
)
GO

-- 2.Insert
INSERT INTO dbo.CustomerPurchaseDetail(PurchaseId, ProductCode, PurchasePrice, Quantity) 
VALUES 
(1, 'IT100', 1500.00, 1),
(1, 'SP200', 145.00, 2),
(2, 'ST100', 4.00, 2),
(2, 'ST200', 6.00, 2),
(2, 'ST300', 5.30, 2);
GO

-- 3.Create Procedure
CREATE PROCEDURE SelectAllCustomerPurchaseDetails
AS
SELECT * FROM dbo.CustomerPurchaseDetail

-- 4.Execute
EXEC SelectAllCustomerPurchaseDetails