---------- do purchase ----------

--USE DBSLab
Use DBSLab_Test1;
GO

DECLARE @RC int
DECLARE @CustID varchar(5)
DECLARE @PurchaseDate datetime
DECLARE @ProductCode varchar(10)
DECLARE @Quantity int
DECLARE @CardNumber varchar(100)
DECLARE @PinCode varchar(100)
DECLARE @PurchaseID int

--first customer, new  purchase

Set @CustID = 'C0001'
Set @PurchaseDate = getdate() - 10
Set @ProductCode = 'IT100'
Set @Quantity = 1
Set @CardNumber = '011656767011656767'
Set @PinCode = '12345'
Set @PurchaseID = NULL

EXECUTE @RC = [dbo].[PerformPurchase] @CustID,@ProductCode,@Quantity,@CardNumber,@PinCode,@PurchaseDate,@PurchaseID
Go
--same customer, same purchase ,second item same trasnaction
SELECT * FROM CustomerPurchase

DECLARE @RC int
DECLARE @CustID varchar(5)
DECLARE @PurchaseDate datetime
DECLARE @ProductCode varchar(10)
DECLARE @Quantity int
DECLARE @CardNumber varchar(100)
DECLARE @PinCode varchar(100)
DECLARE @PurchaseID int

Set @CustID = 'C0001'
--Set @PurchaseDate = getdate() - 10
Set @ProductCode = 'IT200'
Set @Quantity = 2
Set @CardNumber = '011656767011656767'
Set @PinCode = '12345'
Set @PurchaseID = 1

EXECUTE @RC = [dbo].[PerformPurchase] @CustID,@ProductCode,@Quantity,@CardNumber,@PinCode,@PurchaseDate,@PurchaseID
Go

---------- do purchase ---------- complete ---------

--new customer 

DECLARE @RC int
DECLARE @CustID varchar(5)
DECLARE @PurchaseDate datetime
DECLARE @ProductCode varchar(10)
DECLARE @Quantity int
DECLARE @CardNumber varchar(100)
DECLARE @PinCode varchar(100)
DECLARE @PurchaseID int

--first customer, new  purchase

Set @CustID = 'C0002'
Set @PurchaseDate = getdate() - 10
Set @ProductCode = 'ST100'
Set @Quantity = 10
Set @CardNumber = '567011667011656767'
Set @PinCode = '56789'
Set @PurchaseID = NULL

EXECUTE @RC = [dbo].[PerformPurchase] @CustID,@ProductCode,@Quantity,@CardNumber,@PinCode,@PurchaseDate,@PurchaseID
Go

Select * From CustomerPurchase

--same customer, same purchase ,second item same trasnaction
DECLARE @RC int
DECLARE @CustID varchar(5)
DECLARE @PurchaseDate datetime
DECLARE @ProductCode varchar(10)
DECLARE @Quantity int
DECLARE @CardNumber varchar(100)
DECLARE @PinCode varchar(100)
DECLARE @PurchaseID int

Set @CustID = 'C0002'
--Set @PurchaseDate = getdate() - 10
Set @ProductCode = 'ST200'
Set @Quantity = 20
Set @CardNumber = '567011667011656767'
Set @PinCode = '56789'
Set @PurchaseID = 2

EXECUTE @RC = [dbo].[PerformPurchase] @CustID,@ProductCode,@Quantity,@CardNumber,@PinCode,@PurchaseDate,@PurchaseID
Go

--same customer, same purchase ,third item same trasnaction
DECLARE @RC int
DECLARE @CustID varchar(5)
DECLARE @PurchaseDate datetime
DECLARE @ProductCode varchar(10)
DECLARE @Quantity int
DECLARE @CardNumber varchar(100)
DECLARE @PinCode varchar(100)
DECLARE @PurchaseID int

Set @CustID = 'C0002'
--Set @PurchaseDate = getdate() - 10
Set @ProductCode = 'ST300'
Set @Quantity = 15
Set @CardNumber = '567011667011656767'
Set @PinCode = '56789'
Set @PurchaseID = 2

EXECUTE @RC = [dbo].[PerformPurchase] @CustID,@ProductCode,@Quantity,@CardNumber,@PinCode,@PurchaseDate,@PurchaseID
Go

Select * From Customer
Select * From CustomerPurchase
Select * From CustomerPurchaseDetail