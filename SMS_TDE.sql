
USE master;
GO

--DROP MASTER KEY 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'QWEqwe!@#123';
GO

--DROP CERTIFICATE MyMKCertificate
CREATE CERTIFICATE MyMKCertificate WITH SUBJECT = 'My MK Cert';
GO

USE DBSLab_Test1;
GO
--DROP  DATABASE ENCRYPTION KEY
CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_256
ENCRYPTION BY SERVER CERTIFICATE MyMKCertificate;
GO

ALTER DATABASE DBSLab_Test1
SET ENCRYPTION ON;
GO

/*
ALTER DATABASE DBSLab_Test1
SET ENCRYPTION OFF;
GO
*/

Use master
SELECT * FROM sys.symmetric_keys
SELECT * FROM sys.certificates
SELECT db_name(a.database_id) AS DBName , a.encryption_state_desc, 
a.encryptor_type, b.name as 'DEK Encrypted By'
FROM sys.dm_database_encryption_keys a
INNER JOIN sys.certificates b ON a.encryptor_thumbprint = b.thumbprint

---------------------

ALTER DATABASE DBSLab_Test1
SET ENCRYPTION OFF;
GO


---------------- backup keys

Use master
Go
BACKUP CERTIFICATE MyMKCertificate 
TO FILE = N'C:\Temp\MyMKCertificate.cert'
WITH PRIVATE KEY (
    FILE = N'C:\Temp\MyMKCertificate.key', 
	ENCRYPTION BY PASSWORD = 'QwErTy12345!@#$%'
);
Go

Use master
Go

Open Master Key Decryption By PASSWORD = 'QWEqwe!@#123'
BACKUP MASTER KEY TO FILE = N'C:\Temp\MasterKey.key'
ENCRYPTION BY PASSWORD = 'QwErTy12345!@#$%'

RESTORE MASTER kEY
FROM FILE = N'C:\Temp\MasterKey.key'
ENCRYPTION BY PASSWORD = 'QwErTy12345!@#$%'
GO

---------------- restore in same server

RESTORE DATABASE DBSLab_Test1
FROM DISK = 'C:\Temp\DBSLab_Test1.bak'
