/******  Lab 4b : TDE DB Backup Restore Testing 
Case Study: Sales Management System
i) Encrypt the Sales Management System database (Implement TDE).
ii)	Perform backup of your encrypted database.
iii) Perform restore of your backup into another instance.
iv)	Test the database in the new instance. 
******/

-- 1.1 Create a master key in the master database
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MyBackUpPassword$$12345';
GO

-- 1.2 Create a certificate protected by the master key
CREATE CERTIFICATE DBSLab_Test1 WITH SUBJECT = 'TDE Certificate for Sales Management System';
GO

-- 1.3 Switch to your database and create a database encryption key
USE DBSLab_Test1;  -- Replace with your database name if different
GO
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE DBSLab_Test1;
GO

-- 1.4 Enable encryption on the database
ALTER DATABASE DBSLab_Test1
SET ENCRYPTION ON;
GO

-- 2.1 Backup the encrypted database
USE master;
GO
BACKUP DATABASE DBSLab_Test1
TO DISK = '/var/opt/mssql/data/DBSLab_Test1.bak';  -- Modify the path as needed
GO

-- 3.1 On the new instance, create a master key (if not already created)
USE master;
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'QwErTy12345!@#$%';
GO

-- 3.2 Restore the certificate used for TDE from the source server
CREATE CERTIFICATE DBSLab_Test1
FROM FILE = 'DBSLab_Test1Cert.cert'
WITH PRIVATE KEY (
    FILE = 'DBSLab_Test1PrivateKey.key',
    DECRYPTION BY PASSWORD = 'QwErTy12345!@#$%'
);
GO

-- 3.3 Restore the database
RESTORE DATABASE DBSLab_Test1
FROM DISK = '/var/opt/mssql/data/DBSLab_Test1.bak';
GO

-- 4.1 Test the database by fetching some data
USE DBSLab_Test1;
GO
SELECT TOP 10 * FROM Customer;
GO




/** drop master key, private key and certificate **/
-- USE DBSLab_Test1;
-- GO
-- ALTER DATABASE DBSLab_Test1
-- SET ENCRYPTION OFF;
-- GO

-- USE DBSLab_Test1;
-- GO
-- DROP DATABASE ENCRYPTION KEY;
-- GO

-- USE master;
-- GO
-- DROP CERTIFICATE Cert_DBSLab_Test1;
-- GO

-- USE master;
-- GO
-- DROP MASTER KEY;
-- GO



/** ************************ **/
USE MASTER
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'MyBackUpPassword$$12345'

USE MASTER
GO
Create CERTIFICATE CertforEncrDBBRTest 
From FILE = '/Users/tina/Documents/Develop/APU/DBS/Lab/CertforEncrDBBRTest.cert'
WITH PRIVATE KEY (
    FILE = '/Users/tina/Documents/Develop/APU/DBS/Lab/CertforEncrDBBRTest.key', 
DECRYPTION BY PASSWORD = 'QwErTy12345!@#$%'
);

CREATE CERTIFICATE Cert_DBSLab_Test1  
   WITH SUBJECT = 'Cert_DBSLab_Test1';  
GO
Select thumbprint From sys.certificates where name = 'Cert_DBSLab_Test1'

BACKUP CERTIFICATE Cert_DBSLab_Test1 
TO FILE = '/Users/tina/Documents/Develop/APU/DBS/Lab/Cert_DBSLab_Test1.cert'
WITH PRIVATE KEY (
    FILE = '/Users/tina/Documents/Develop/APU/DBS/Lab/Cert_DBSLab_Test1.key', 
ENCRYPTION BY PASSWORD = 'QWEqwe!@#123'
);

BACKUP DATABASE DBSLab_Anonymise
TO DISK = '/Users/tina/Documents/Develop/APU/DBS/Lab/DBSLab_Anonymise.bak'  
WITH  
  COMPRESSION,  
  ENCRYPTION   
   (  
   ALGORITHM = AES_256,  
   SERVER CERTIFICATE = Cert_DBSLab_Test1  
   )
GO

--Recreate the Certificate From The File
Create CERTIFICATE Cert_DBSLab_Test1 
From FILE = '/Users/tina/Documents/Develop/APU/DBS/Lab/Cert_DBSLab_Test1.cert'
WITH PRIVATE KEY (
    FILE = '/Users/tina/Documents/Develop/APU/DBS/Lab/Cert_DBSLab_Test1.key', 
DECRYPTION BY PASSWORD = 'QWEqwe!@#123'
);

RESTORE DATABASE DBSLab_Anonymise 
FROM DISK = '/Users/tina/Documents/Develop/APU/DBS/Lab/DBSLab_Anonymise.bak'
WITH MOVE 'DBSLab_Anonymise' TO '/Users/tina/Documents/Develop/APU/DBS/Lab/DBSLab_Anonymise.mdf',
MOVE 'DBSLab_Anonymise_Log' TO '/Users/tina/Documents/Develop/APU/DBS/Lab/DBSLab_Anonymise_Log.ldf'


USE DBSLab_Anonymise;
GO
SELECT * FROM Country;
SELECT * FROM Customer;
