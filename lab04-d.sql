/** Question A: **/
/** 
Instead of deleting the record, we can set the status of the row to be inactive. 

1) Add an additional column to the SQL table to keep track of the row status
2) Then, create a trigger to update the column status whenever a delete comman is issued
**/

-- Add RowStatus column into Customer table if haven't.
-- ALTER TABLE Customer
-- ADD RowStatus INT DEFAULT 1 NOT NULL;


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


/** Question B **/
/**
Write a DDL Trigger that allows and tables columns to be added but prevents tables and columns from being dropped.
**/

-- prevent any accidental deletion of tables
CREATE OR ALTER TRIGGER [JustWannaBeSafe]   
ON DATABASE   
FOR DROP_TABLE
AS   
PRINT 'You must disable Trigger [JustWannaBeSafe] to drop tables!'   
ROLLBACK; 

-- Triggers can be disabled, enabled back or dropped 
-- DISABLE TRIGGER <trigger name>
-- ON <table name>

-- ENABLE TRIGGER <trigger name>
-- ON <table name>

-- DROP TRIGGER <trigger name>
