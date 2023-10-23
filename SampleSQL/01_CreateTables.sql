
Create Database DBSLab_Test1;
Go

Use DBSLab_Test1;

--DDL Query
Create Table Country
(
CountryCode varchar(3) primary key,
CountryName varchar(100)
);
Go

Create Table Customer
(
CustID varchar(5) primary key,
CustName varchar(100) not null,
PhoneNumber varchar(12),
Email varchar(200),
Country  varchar(3) References Country(CountryCode),
Gender varchar (6) Check (Gender in ('Female','Male')),
PaymentCardNumber varchar(100),
PaymentCardPinCode varchar(100),
PassportNumber varchar(50),
UserID varchar(200)
);
Go

Create Table ProductCategory
(
CategoryCode varchar(5) primary key,
CategoryName varchar(100) not null
);
Go


Create Table Product
(
ProductCode varchar(10) primary key,
ProductName varchar(100) not null,
ProductCategory varchar(5) null references ProductCategory(CategoryCode),
CostPrice decimal(8,2) Check (CostPrice > 0.00),
SalePrice decimal(8,2) Check (SalePrice > 0.00),
CountryCode varchar(3) Default 'MAS' references Country(CountryCode)
);
Go

Create Table CustomerPurchase
(
PurchaseID integer identity primary key,
CustID varchar(5) references Customer(CustID),
PurchaseDate datetime default getdate()
);
Go

Create Table CustomerPurchaseDetail
(
DetailPurchaseID integer identity primary key,
PurchaseID integer references CustomerPurchase(PurchaseID),
ProductCode varchar(10) references Product(ProductCode),
PurchasePrice decimal(8,2) Check (PurchasePrice > 0.00),
Quantity integer Check (Quantity> 0),
Total as PurchasePrice * Quantity
);
Go

