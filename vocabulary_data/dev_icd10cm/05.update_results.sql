SET TERMOUT ON
SET LINESIZE 3000
SET PAGESIZE 45
SET SERVEROUTPUT ON
SET VERIFY OFF
/* If any errors occurs - stop script execution and return error code */
WHENEVER SQLERROR EXIT SQL.SQLCODE
/*
 *****************************
 *  Log to file...    
 *****************************
*/
SPOOL &1

/**
* Perform update results verification
**/
PROMPT **
PROMPT * Perform update results verification...
PROMPT **
SET ECHO OFF
-- Define column width
COLUMN CHECK_ID FORMAT A10 HEADING 'CHECK_ID' NULL - WRAP
COLUMN CONCEPT_ID_1 FORMAT A20 HEADING 'CONCEPT_ID_1' NULL - WRAP
COLUMN CONCEPT_ID_2 FORMAT A20 HEADING 'CONCEPT_ID_2' NULL - WRAP
COLUMN RELATIONSHIP_ID FORMAT A20 HEADING 'RELATIONSHIP_ID' NULL - WRAP
COLUMN VALID_START_DATE FORMAT A20 HEADING 'VALID_START_DATE' NULL - WRAP
COLUMN VALID_END_DATE FORMAT A20 HEADING 'VALID_END_DATE' NULL - WRAP
COLUMN INVALID_REASON FORMAT A15 HEADING 'INVALID_REASON' NULL - WRAP

SET ECHO ON
-- Perform common checks
PROMPT Perform common checks...
SELECT
	TO_CHAR(CHECK_ID) as CHECK_ID,
	TO_CHAR(CONCEPT_ID_1) as CONCEPT_ID_1,
	TO_CHAR(CONCEPT_ID_2) as CONCEPT_ID_2,
	RELATIONSHIP_ID,
	VALID_START_DATE,
	VALID_END_DATE, 
	INVALID_REASON
FROM TABLE(DEVV5.QA_TESTS.GET_CHECKS);

SET ECHO OFF
-- Define column width
COLUMN VOCABULARY_ID_1 FORMAT A20 HEADING 'VOCABULARY_ID_1' NULL - WRAP
COLUMN VOCABULARY_ID_2 FORMAT A20 HEADING 'VOCABULARY_ID_2' NULL - WRAP
COLUMN CONCEPT_CLASS_ID FORMAT A20 HEADING 'CONCEPT_CLASS_ID' NULL - WRAP
COLUMN RELATIONSHIP_ID FORMAT A20 HEADING 'RELATIONSHIP_ID' NULL - WRAP
COLUMN INVALID_REASON FORMAT A15 HEADING 'INVALID_REASON' NULL - WRAP
COLUMN CONCEPT_DELTA FORMAT 999999999.99 HEADING 'CONCEPT_DELTA' NULL - WRAP

-- Clear cache
PROMPT Clear cache...
EXEC DEVV5.QA_TESTS.PURGE_CACHE;

SET ECHO ON
-- Perform CONCEPT checks
PROMPT Perform CONCEPT checks...
WITH VGSC AS (SELECT * FROM TABLE(DEVV5.QA_TESTS.get_summary('concept')))
SELECT VOCABULARY_ID_1,
       VOCABULARY_ID_2,
       CONCEPT_CLASS_ID,
       RELATIONSHIP_ID,
       INVALID_REASON,
       CONCEPT_DELTA
FROM VGSC
  UNION ALL
SELECT '-',
       '-',
       '-',
       '-',
       '-',
       SUM(CONCEPT_DELTA)
FROM VGSC;

-- Perform CONCEPT RELATIONSHIPS checks
PROMPT Perform CONCEPT RELATIONSHIPS checks...
WITH VGSCR AS (SELECT * FROM TABLE(DEVV5.QA_TESTS.get_summary('concept_relationship')))
SELECT VOCABULARY_ID_1,
       VOCABULARY_ID_2,
       CONCEPT_CLASS_ID,
       RELATIONSHIP_ID,
       INVALID_REASON,
       CONCEPT_DELTA
FROM VGSCR
  UNION ALL
SELECT '-',
       '-',
       '-',
       '-',
       '-',
       SUM(CONCEPT_DELTA)
FROM VGSCR;

SPOOL OFF
EXIT