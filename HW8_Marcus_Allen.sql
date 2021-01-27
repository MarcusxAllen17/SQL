--1
Select * from browser_user;
Select * from prospective_user;
-- These two tables share the common fields of Email, Phone, first_name, last_name, status
--2 !
CREATE TABLE client_dw
(
client_id       Varchar2(50),   
first_name      Varchar2(50),
last_name       Varchar2(50),
email           Varchar2(50),
phone           Varchar2(50),
Status          Varchar2(50),
data_source     Varchar2(50),
CONSTRAINT pk_client_dw PRIMARY KEY(client_id, data_source)
)
;
DROP TABLE client_dw;
--3 
CREATE OR REPLACE VIEW Browser_user_view AS 
SELECT User_ID as client_id, First_Name, Last_Name, email, substr(phone_num, 1,3) 
||'-'|| substr(phone_num, 4,3) ||'-'||  substr(phone_num, 7,4) AS phone, CC_Flag, 
'curr' AS data_source
FROM browser_user
;

CREATE OR REPLACE VIEW Prospective_user_view AS 
SELECT prospective_id as client_id, pc_first_name, pc_last_name, email,
REPLACE(REPLACE(phone,'(',''), ')','-') AS phone, 
'N' AS Status, 'pros' AS data_source
FROM prospective_user
;

SELECT * FROM Browser_user_view;
SELECT * FROM Prospective_user_view;

--4

INSERT INTO client_dw (client_id,first_name, last_name, email, phone, status, data_source)
    SELECT b.client_id,b.first_name, b.last_name, b.email, b.phone, b.cc_flag, b.data_source
    FROM browser_user_view b
    LEFT JOIN client_dw c
    ON b.client_id = c.client_id
    AND b.data_source = c.data_source
    WHERE c.client_id IS NULL
    ;
    
INSERT INTO client_dw (client_id,first_name, last_name, email, phone, status, data_source)
    SELECT p.client_id,p.pc_first_name, p.pc_last_name, p.email, p.phone, p.status, p.data_source
    FROM Prospective_user_view p
    LEFT JOIN client_dw c
    ON p.client_id = c.client_id
    AND p.data_source = c.data_source
    WHERE c.client_id IS NULL
    ;
--5
MERGE INTO client_dw c
    using browser_user_view b
    ON (c.client_id = b.client_id)
   WHEN MATCHED THEN
    UPDATE SET 
    c.first_name = b.first_name,
    c.last_name = b.last_name,
    c.email = b.email,
    c.phone = b.phone,
    c.status =  b.CC_FLAG
   WHEN NOT MATCHED THEN 
   INSERT (c.first_name,c.last_name,c.email,c.phone,c.status)
   VALUES (b.first_name,b.last_name,b.email,b.phone,b.cc_flag)
   ;
    
MERGE INTO client_dw c
    using Prospective_user_view p
    ON (c.client_id = p.client_id)
   WHEN MATCHED THEN
    UPDATE SET 
    c.first_name = pc_first_name,
    c.last_name = pc_last_name,
    c.email = p.email,
    c.phone = p.phone,
    c.status = p.status
   WHEN NOT MATCHED THEN 
   INSERT (c.first_name,c.last_name,c.email,c.phone,c.status)
   VALUES (p.pc_first_name,p.pc_last_name,p.email,p.phone,p.status)
   ;
--6
CREATE OR REPLACE PROCEDURE user_etl_proc
AS
BEGIN
 INSERT INTO client_dw (client_id,first_name, last_name, email, phone, status, data_source)
    SELECT b.client_id,b.first_name, b.last_name, b.email, b.phone, b.cc_flag, b.data_source
    FROM browser_user_view b
    LEFT JOIN client_dw c
    ON b.client_id = c.client_id
    AND b.data_source = c.data_source
    WHERE c.client_id IS NULL
    ;
    
INSERT INTO client_dw (client_id,first_name, last_name, email, phone, status, data_source)
    SELECT p.client_id,p.pc_first_name, p.pc_last_name, p.email, p.phone, p.status, p.data_source
    FROM Prospective_user_view p
    LEFT JOIN client_dw c
    ON p.client_id = c.client_id
    AND p.data_source = c.data_source
    WHERE c.client_id IS NULL
    ;

MERGE INTO client_dw c
    using browser_user_view b
    ON (c.client_id = b.client_id)
   WHEN MATCHED THEN
    UPDATE SET 
    c.first_name = b.first_name,
    c.last_name = b.last_name,
    c.email = b.email,
    c.phone = b.phone,
    c.status =  b.CC_FLAG
   WHEN NOT MATCHED THEN 
   INSERT (c.first_name,c.last_name,c.email,c.phone,c.status)
   VALUES (b.first_name,b.last_name,b.email,b.phone,b.cc_flag)
   ;
    
MERGE INTO client_dw c
    using Prospective_user_view p
    ON (c.client_id = p.client_id)
   WHEN MATCHED THEN
    UPDATE SET 
    c.first_name = pc_first_name,
    c.last_name = pc_last_name,
    c.email = p.email,
    c.phone = p.phone,
    c.status = p.status
   WHEN NOT MATCHED THEN 
   INSERT (c.first_name,c.last_name,c.email,c.phone,c.status)
   VALUES (p.pc_first_name,p.pc_last_name,p.email,p.phone,p.status)
   ;

End;
/








