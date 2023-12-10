
SELECT *   FROM [DBSLab_Test1].[dbo].[Customer]

  Alter Table Customer
  Add RowStatus bit default 1

  Update Customer
  Set RowStatus =1

  -- trigger
DROP TRIGGER ProtectCustomerTable

CREATE OR ALTER TRIGGER ProtectCustomerTable
ON Customer 
INSTEAD OF  
DELETE
AS 
Begin
Declare @custid varchar(5)
Select @custid = CustID From deleted
Update Customer Set RowStatus=0 Where CustID=@custid
End

Insert Into Customer 
([CustID] ,[CustName],[PhoneNumber] ,[Email] ,[Country] ,[Gender],[PaymentCardNumber]
,[PaymentCardPinCode] ,[PassportNumber],[UserID])
Values  ('C0003','Ali','0145898798','ali@email.com','INA','Male','7687326546465',
'1879','G76585587','U300')

Select RowStatus, * From Customer Where CustID='C0004'
Delete From Customer Where CustID='C0004'
Select RowStatus,* From Customer Where CustID='C0004'


