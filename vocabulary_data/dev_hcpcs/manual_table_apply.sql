SET ECHO OFF
SET VERIFY OFF
/* If any errors occurs - stop script execution and return error code */
WHENEVER SQLERROR EXIT SQL.SQLCODE
/*
 *****************************
 *  Log to file...    
 *****************************
*/
SPOOL &1

PROMPT Applying &2 data to RELATIONSHIP_TO_CONCEPT table...
MERGE INTO RELATIONSHIP_TO_CONCEPT r2c
   USING (SELECT DISTINCT CONCEPT_CODE_1, CONCEPT_ID_2, PRECEDENCE, CONVERSION_FACTOR FROM MANUAL_TABLE) mt
   ON (r2c.CONCEPT_CODE_1 = mt.CONCEPT_CODE_1 AND r2c.CONCEPT_ID_2 = mt.CONCEPT_ID_2)
     WHEN MATCHED 
        THEN UPDATE SET r2c.PRECEDENCE = mt.PRECEDENCE, r2c.CONVERSION_FACTOR = mt.CONVERSION_FACTOR 
     WHEN NOT MATCHED 
        THEN INSERT (r2c.CONCEPT_CODE_1, r2c.CONCEPT_ID_2, r2c.PRECEDENCE, r2c.CONVERSION_FACTOR) 
             VALUES (mt.CONCEPT_CODE_1, mt.CONCEPT_ID_2, mt.PRECEDENCE, mt.CONVERSION_FACTOR);

COMMIT;

PROMPT Apply "Manual Mapping" fix...
insert into relationship_to_concept (CONCEPT_CODE_1,CONCEPT_ID_2,PRECEDENCE) values ('hydrocortisone sodium phosphate',975125,1);
insert into relationship_to_concept (CONCEPT_CODE_1,CONCEPT_ID_2,PRECEDENCE) values ('sulfur hexafluoride lipid microspheres',45892833,1);
insert into relationship_to_concept (CONCEPT_CODE_1,CONCEPT_ID_2,PRECEDENCE) values ('estrogen conjugated',1549080,1);
insert into relationship_to_concept (CONCEPT_CODE_1,CONCEPT_ID_2,PRECEDENCE) values ('ondansetron hydrochloride 8 mg',1000560,1);

SPOOL OFF
EXIT