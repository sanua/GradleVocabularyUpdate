SET LINESIZE 1024
SET ECHO OFF
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET NEWPAGE NONE
-- SET COLSEP ';'

COLUMN exp_file_name new_val exp_file_name
SELECT '&1'|| '/' || '&2' AS exp_file_name FROM dual;
SPOOL &&exp_file_name

SELECT 'CONCEPT_CODE_1' || ','
    || 'CONCEPT_NAME_1' || ','
    || 'CONCEPT_ID_2' || ','
    || 'CONCEPT_NAME_2' || ','
    || 'DOMAIN_ID' || ','
    || 'VOCABULARY_ID' || ','
    || 'INVALID_REASON' || ','
    || 'VALID_START_DATE' || ','
    || 'VALID_END_DATE' || ','
    || 'PRECEDENCE' || ','
    || 'CONVERSION_FACTOR'
FROM DUAL
UNION ALL
SELECT '"' || CONCEPT_CODE_1  || '",'
    || '"' || CONCEPT_NAME_1 || '",'
    || '"' || CONCEPT_ID_2 || '",'
    || '"' || CONCEPT_NAME_2 || '",'
    || '"' || DOMAIN_ID || '",'
    || '"' || VOCABULARY_ID || '",'
    || '"' || INVALID_REASON || '",'
    || '"' || TO_CHAR(VALID_START_DATE, 'YYYY-MM-DD HH24:MI:SS') || '",'
    || '"' || TO_CHAR(VALID_END_DATE, 'YYYY-MM-DD HH24:MI:SS')  || '",'
    || '"' || PRECEDENCE || '",'
    || '"' || CONVERSION_FACTOR || '"'
FROM &3
;

SPOOL OFF
EXIT