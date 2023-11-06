/****** LAB 04-a ******/

/****** Encryption ******/

-- 1. Evaluate the data dictionary and identify sensitive column
-- List down the table
-- The sensitive columns identified are PaymentCardNumber and PassportNumber in the Customer table.
CREATE PROCEDURE SelectAllCustomers
AS
SELECT * FROM dbo.Customer
GO;
EXEC SelectAllCustomers;

-- 2. Update the table structure to implement encryption
-- Update table queries
-- Update existing records with encrypted data
-- First, we'll add new columns to hold the encrypted data. We'll suffix these with "_Encrypted".
ALTER TABLE dbo.Customer ADD PaymentCardNumber_Encrypted VARBINARY(MAX);
ALTER TABLE dbo.Customer ADD PassportNumber_Encrypted VARBINARY(MAX);

-- Update existing records with encrypted data
-- Using ENCRYPTBYCERT for encryption in SQL Server.
---Step 1 - Create Master Key
CREATE master key encryption BY password = 'QwErTy12345!@#$%'
go
SELECT * FROM sys.symmetric_keys
go

---Step 2 - Create a certificate for encryption
--Drop Certificate Cert_Customer
CREATE Certificate Cert_Customer
With Subject = 'Cert_For_Customer_Table'
go
select * from sys.certificates

-- 3. Choose suitable encryption method
-- Update existing records with encrypted data using ENCRYPTBYCERT
UPDATE dbo.Customer
SET 
    PaymentCardNumber_Encrypted = ENCRYPTBYCERT(CERT_ID('Cert_Customer'), PaymentCardNumber), 
    PassportNumber_Encrypted = ENCRYPTBYCERT(CERT_ID('Cert_Customer'), PassportNumber)

-- 4. Test & run queries to copy the values from unencrypted columns to encrypted columns
-- Decrypting data using DECRYPTBYCERT for demonstration
SELECT 
    CustID, 
    CONVERT(VARCHAR(100), DECRYPTBYCERT(CERT_ID('Cert_Customer'), PaymentCardNumber_Encrypted)) AS DecryptedCardNumber, 
    CONVERT(VARCHAR(50), DECRYPTBYCERT(CERT_ID('Cert_Customer'), PassportNumber_Encrypted)) AS DecryptedPassportNumber 
FROM dbo.Customer
WHERE CustID = 'C0001' OR CustID =  'C0002';

-- 5. Remove previous unencrypted columns
ALTER TABLE dbo.Customer DROP COLUMN PaymentCardNumber;
ALTER TABLE dbo.Customer DROP COLUMN PassportNumber;

-- 6. Prepare relevant queries to read back the data (View)
EXEC SelectAllCustomers




/******  B. Case Study: Sales Management System – Development System
Protect the data before passing a copy of the database to the development team.
the real customer’s name and phone numbers should not be made available to anyone, including your development and testing teams. 
******/
ALTER TABLE dbo.Customer ADD CustomerName_Encrypted VARBINARY(MAX);
ALTER TABLE dbo.Customer ADD PhoneNumber_Encrypted VARBINARY(MAX);

EXEC SelectAllCustomers;

-- Master key
-- (already created)

-- Certificate
CREATE CERTIFICATE CustomerDataCertificate
WITH SUBJECT = 'Customer Data Encryption(name and phone numbers)';
GO
SELECT * FROM sys.certificates

-- Encrypt
UPDATE dbo.Customer
SET 
    CustomerName_Encrypted = ENCRYPTBYCERT(CERT_ID('CustomerDataCertificate'), CustName),
    PhoneNumber_Encrypted = ENCRYPTBYCERT(CERT_ID('CustomerDataCertificate'), PhoneNumber);

EXEC SelectAllCustomers;

-- Decrypt
SELECT 
    CustID, 
    CONVERT(VARCHAR(100), DECRYPTBYCERT(CERT_ID('CustomerDataCertificate'), CustomerName_Encrypted)) AS DecryptedName,
    CONVERT(VARCHAR(12), DECRYPTBYCERT(CERT_ID('CustomerDataCertificate'), PhoneNumber_Encrypted)) AS DecryptedPhone
FROM Customer;

-- Delete columns
ALTER TABLE dbo.Customer DROP COLUMN CustName;
ALTER TABLE dbo.Customer DROP COLUMN PhoneNumber;

-- View
EXEC SelectAllCustomers;
