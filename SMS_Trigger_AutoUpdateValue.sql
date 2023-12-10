
USE [DBSLab_Test1]
GO

Select * From CustomerPurchaseDetail
insert into [CustomerPurchaseDetail] ([PurchaseID],[ProductCode],[Quantity])
values (6,'ST200',5);
Go

CREATE OR ALTER TRIGGER AutoUpdatePurchasePrice
ON CustomerPurchaseDetail 
AFTER  
INSERT
AS 
Begin

Declare @detailpurchaseid int, @productcode varchar(10), 
@quantity int, @purchaseprice decimal(8,2)

Select @detailpurchaseid =DetailPurchaseID, @productcode = ProductCode
From inserted

Select @purchaseprice = SalePrice From Product
Where ProductCode = @productcode

Update CustomerPurchaseDetail Set PurchasePrice=@purchaseprice
Where DetailPurchaseID=@detailpurchaseid 

End
