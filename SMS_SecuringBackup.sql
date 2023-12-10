USE master;
GO

--DROP MASTER KEY 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'QWEqwe!@#123';
GO

CREATE CERTIFICATE Cert_DBSLab_Test1  
   WITH SUBJECT = 'Cert_DBSLab_Test1';  
GO
Select thumbprint From sys.certificates where name = 'Cert_DBSLab_Test1'

BACKUP CERTIFICATE Cert_DBSLab_Test1 
TO FILE = N'C:\Temp\Cert_DBSLab_Test1.cert'
WITH PRIVATE KEY (
    FILE = N'C:\Temp\Cert_DBSLab_Test1.key', 
ENCRYPTION BY PASSWORD = 'QWEqwe!@#123'
);
Go

--If you have accidentally deleted your certificate, 
-- you can restore fro backup
OPEN MASTER KEY DECRYPTION BY PASSWORD = 'QWEqwe!@#123';
Create CERTIFICATE Cert_DBSLab_Test1 
From FILE = N'C:\Temp\Cert_DBSLab_Test1.cert'
WITH PRIVATE KEY (
    FILE = N'C:\Temp\Cert_DBSLab_Test1.key', 
DECRYPTION BY PASSWORD = 'QWEqwe!@#123'
);

BACKUP DATABASE DBSLab_Anonymise
TO DISK = N'C:\Temp2\DBSLab_Anonymise.bak'  
WITH  
  COMPRESSION,  
  ENCRYPTION   
   (  
   ALGORITHM = AES_256,  
   SERVER CERTIFICATE = Cert_DBSLab_Test1  
   )
GO


-- Copy the database and certificate backup files to another location 
-- accessible by the other instance
-- perform permission management so that the backup file, certificate 
-- and private key is accessible by the new instance account

--Another Server/Instance - run in the new server

USE MASTER
GO
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'QWEqwe!@#123';
GO

--Recreate the Certificate From The File
Create CERTIFICATE Cert_DBSLab_Test1 
From FILE = N'C:\Temp2\Cert_DBSLab_Test1.cert'
WITH PRIVATE KEY (
    FILE = N'C:\Temp2\Cert_DBSLab_Test1.key', 
DECRYPTION BY PASSWORD = 'QWEqwe!@#123'
);

RESTORE DATABASE DBSLab_Anonymise 
FROM DISK = 'C:\Temp2\DBSLab_Anonymise.bak'
WITH MOVE 'DBSLab_Anonymise' TO 'C:\Temp2\DBSLab_Anonymise.mdf',
MOVE 'DBSLab_Anonymise_Log' TO 'C:\Temp2\DBSLab_Anonymise_Log.ldf'

Select * from sys.certificates