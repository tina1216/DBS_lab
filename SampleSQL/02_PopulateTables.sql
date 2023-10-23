--Use DBSLab;
Use DBSLab_Test1;
Go


--DML Query  
INSERT Into Country values ('MAS','Malaysia')
INSERT Into Country values('INA','Indonesia')
INSERT Into Country values ('JPN','Japan')
Select * from country


Insert Into Customer(CustID , CustName , PhoneNumber , Email,  
Country, Gender, PaymentCardNumber , PaymentCardPinCode, PassportNumber , UserID)
Values
('C0001','John','01245611789','john@gmail.com', 'MAS','Male', '011656767011656767','12345','A189796986','U100')

Insert Into Customer(CustID , CustName , PhoneNumber , Email, 
Country, Gender, PaymentCardNumber , PaymentCardPinCode, PassportNumber , UserID)
Values
('C0002','Nancy','01245611789','nancy@email.com', 'MAS','Female', '567011667011656767','56789','B975596986','U200')

Select * from Customer

Insert Into ProductCategory(CategoryCode, CategoryName)
Values ('SP', 'Sports'), ('IT','IT Hardware'), ('ST', 'Stationary')

Select * From ProductCategory

Insert Into Product 
(ProductCode, ProductName, ProductCategory, CostPrice, SalePrice, CountryCode)
Values 
('SP100','Yonex Badminton Racket','SP',50, 105, 'MAS'),
('SP200','Adidas Football','SP',35, 145, 'MAS'),
('IT100','Acer Laptop','IT',1200, 1500, 'JPN'),
('IT200','Lenovo Laptop','IT',2000, 2500, 'INA'),
('ST100','Test Pad','ST',2.50, 4.00, 'INA'),
('ST200','File Folder','ST',4.50, 6.00, 'INA'),
('ST300','Stapler','ST',3.50, 5.30, 'INA')

Select * From Product
SELECT * FROM CustomerPurchase
SELECT * FROM CustomerPurchaseDetail