Use DBSLab_Test1;
Go

ALTER TABLE Customer
ADD PaymentCardNumEncrypted VARBINARY(MAX)

---Step 1 - Create Master Key
create master key encryption by password = 'QwErTy12345!@#$%'
go
select * from sys.symmetric_keys
go

---Step 2 - create certificate to protect our sym key

CREATE CERTIFICATE MyDBCertificate WITH SUBJECT = 'My DB Cert';
GO

---Step 3 - create symmetric key

CREATE SYMMETRIC KEY MySymKey
WITH ALGORITHM = AES_256  
ENCRYPTION BY CERTIFICATE MyDBCertificate
GO

OPEN SYMMETRIC KEY MySymKey
DECRYPTION BY CERTIFICATE MyDBCertificate

Update Customer
Set PaymentCardNumEncrypted = 
EncryptByKey(Key_GUID('MySymKey'),PaymentCardNumber)

CLOSE SYMMETRIC KEY MySymKey

Select * From Customer
Select CustID, CustName, PaymentCardNumEncrypted
From Customer


---decrypt

OPEN SYMMETRIC KEY MySymKey
DECRYPTION BY CERTIFICATE MyDBCertificate

Select CustID, CustName, 
CONVERT(varchar, DecryptByKey(PaymentCardNumEncrypted)) As Decrypted
From Customer

CLOSE SYMMETRIC KEY MySymKey

go

---------------- backup keys
Use DBSLab_Test1
Go

OPEN SYMMETRIC KEY MySymKey
DECRYPTION BY CERTIFICATE MyDBCertificate

BACKUP SYMMETRIC KEY MySymKey
   TO FILE = N'C:\Temp\MySymKey.key'
   ENCRYPTION BY PASSWORD = 'QwErTy12345!@#$%'

CLOSE SYMMETRIC KEY MySymKey

Use DBSLab_Test1;
Go

BACKUP CERTIFICATE MyDBCertificate 
TO FILE = N'C:\Temp\MyDBCertificate.cert'
WITH PRIVATE KEY (
    FILE = N'C:\Temp\MyDBCertificate.key', 
	ENCRYPTION BY PASSWORD = 'QwErTy12345!@#$%'
);
Go

Use DBSLab_Test1;
Go


Open Master Key Decryption By PASSWORD ='QwErTy12345!@#$%'
BACKUP MASTER KEY TO FILE = N'C:\Temp\MasterKey.key'
ENCRYPTION BY password = 'QwErTy12345!@#$%'