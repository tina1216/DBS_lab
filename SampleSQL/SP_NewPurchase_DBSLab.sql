CREATE DATABASE DBSLab2
GO
--USE [DBSLab]
Use DBSLab2;
GO

/****** Object:  StoredProcedure [dbo].[PerformPurchase]    Script Date: 20/8/2023 8:48:39 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PerformPurchase]
	@CustID varchar(5), @ProductCode varchar(10),
	@Quantity int, @CardNumber varchar(100), @PinCode varchar(100),
	@PurchaseDate datetime=NULL, @PurchaseID int = NULL
AS
BEGIN
	
	--First validate if customer provided valid payment card details
	Declare @Valid int

	Select @Valid = Count(*) From Customer Where CustID=@CustID 
			And PaymentCardNumber = @CardNumber
			And PaymentCardPinCode = @PinCode

	If @Valid != 1
	Return;

	Declare @DetailPurchaseID int

	If (@PurchaseID Is Null)
	Begin
	--New Transaction

		Declare @NewPurchaseID int
		
		Insert Into CustomerPurchase (CustID, PurchaseDate) Values (@CustID,@PurchaseDate)
	
		Select @NewPurchaseID = @@IDENTITY 
	
		Insert Into CustomerPurchaseDetail (PurchaseID, ProductCode,Quantity)
		Values (@NewPurchaseID,@ProductCode,@Quantity)

		Select @DetailPurchaseID = @@IDENTITY 

		Update CustomerPurchaseDetail 
		Set PurchasePrice = 
			(Select SalePrice From Product Where CustomerPurchaseDetail.ProductCode = Product.ProductCode)
		Where CustomerPurchaseDetail.DetailPurchaseID = @DetailPurchaseID
	End
	Else
	Begin

		-- Existing transaction
	
		If Exists (Select * From CustomerPurchaseDetail Where 
			PurchaseID = @PurchaseID And ProductCode = @ProductCode)
		Begin
			--same product
			Update CustomerPurchaseDetail 
			Set Quantity = @Quantity
			Where PurchaseID = @PurchaseID And ProductCode = @ProductCode
		End
		Else
		Begin
			--new product
			Insert Into CustomerPurchaseDetail (PurchaseID, ProductCode,Quantity)
			Values (@PurchaseID,@ProductCode,@Quantity)

			Select @DetailPurchaseID = @@IDENTITY 

			Update CustomerPurchaseDetail 
			Set PurchasePrice = 
				(Select SalePrice From Product Where CustomerPurchaseDetail.ProductCode = Product.ProductCode)
			Where CustomerPurchaseDetail.DetailPurchaseID = @DetailPurchaseID
		End
	End
END 

