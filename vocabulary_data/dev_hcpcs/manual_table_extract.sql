SET SERVEROUTPUT ON
SET LINESIZE 1024
SET ECHO OFF
SET TERMOUT OFF
SET HEADING OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET NEWPAGE NONE
-- SET COLSEP ';'

COLUMN exp_file_name new_val exp_file_name
SELECT '&1'|| '/' || '&2' AS exp_file_name FROM dual;
SPOOL &&exp_file_name

WITH mt AS (SELECT LABEL_TEXT,
                   CONCEPT_CODE_1,
                   CONCEPT_NAME_1,
                   CONCEPT_ID_2,
                   CONCEPT_NAME_2,
                   DOMAIN_ID,
                   VOCABULARY_ID,
                   CONCEPT_CLASS_ID,
                   INVALID_REASON,
                   TO_CHAR(VALID_START_DATE, 'YYYY-MM-DD') AS VALID_START_DATE,
                   TO_CHAR(VALID_END_DATE, 'YYYY-MM-DD') AS VALID_END_DATE,
                   PRECEDENCE,
                   CONVERSION_FACTOR
            FROM &3
            ORDER BY LABEL_TEXT,
                     CONCEPT_CODE_1,
                     CONCEPT_NAME_1,
                     CONCEPT_ID_2,
                     CONCEPT_NAME_2,
                     DOMAIN_ID,
                     VOCABULARY_ID,
                     CONCEPT_CLASS_ID,
                     INVALID_REASON,
                     VALID_START_DATE,
                     VALID_END_DATE,
                     PRECEDENCE,
                     CONVERSION_FACTOR)
SELECT 'LABEL_TEXT' || ','
    || 'CONCEPT_CODE_1' || ','
    || 'CONCEPT_NAME_1' || ','
    || 'CONCEPT_ID_2' || ','
    || 'CONCEPT_NAME_2' || ','
    || 'DOMAIN_ID' || ','
    || 'VOCABULARY_ID' || ','
    || 'CONCEPT_CLASS_ID' || ','
    || 'INVALID_REASON' || ','
    || 'VALID_START_DATE' || ','
    || 'VALID_END_DATE' || ','
    || 'PRECEDENCE' || ','
    || 'CONVERSION_FACTOR' || CHR(13)||CHR(10) AS "&3 DATA"
FROM DUAL
UNION ALL
SELECT '"' || mt.LABEL_TEXT  || '",'
    || '"' || mt.CONCEPT_CODE_1  || '",'
    || '"' || mt.CONCEPT_NAME_1 || '",'
    || '"' || mt.CONCEPT_ID_2 || '",'
    || '"' || mt.CONCEPT_NAME_2 || '",'
    || '"' || mt.DOMAIN_ID || '",'
    || '"' || mt.VOCABULARY_ID || '",'
    || '"' || mt.CONCEPT_CLASS_ID || '",'
    || '"' || mt.INVALID_REASON || '",'
    || '"' || mt.VALID_START_DATE || '",'
    || '"' || mt.VALID_END_DATE || '",'
    || '"' || mt.PRECEDENCE || '",'
    || '"' || mt.CONVERSION_FACTOR || '"' || CHR(13)||CHR(10)
FROM mt
;

SPOOL OFF
EXIT