
USE master;
GO

--DROP MASTER KEY 
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'QWEqwe!@#123';
GO

OPEN MASTER KEY DECRYPTION BY PASSWORD = 'QWEqwe!@#123';

Create CERTIFICATE MyMKCertificate 
From FILE = N'C:\Temp3\MyMKCertificate.cert'
WITH PRIVATE KEY (
    FILE = N'C:\Temp3\MyMKCertificate.key', 
DECRYPTION BY PASSWORD = 'QwErTy12345!@#$%'
);

RESTORE DATABASE DBSLab_Test1
FROM DISK = 'C:\Temp3\DBSLab_Test1.bak'
WITH MOVE 'DBSLab_Test1' TO 'C:\Temp3\DBSLab_Test1.mdf',
MOVE 'DBSLab_Test1_Log' TO 'C:\Temp3\DBSLab_Test1_Log.ldf'


