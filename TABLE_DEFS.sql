-- ===========================================================================================================
-- Author:      Rishi Raghav
-- Create date: 08-20-2021
-- Description: Relational Table Definitions for CPC based Patent Analytics Data Extraction and Transformation
-- ===========================================================================================================

-- Raw Data Extract Table to store CPC data extracted from https://worldwide.espacenet.com platform
CREATE TABLE
        "PAT_EXTRACT_DATA"
        (
                "PATENT_SEQ_ID"        NUMBER             ,
                "SUB_SEQ_ID"           NUMBER             ,
                "TEXT_FILE_NAME"       VARCHAR2(4000 BYTE),
                "TITLE_NAME"           VARCHAR2(4000 BYTE),
                "INVENTORS"            VARCHAR2(4000 BYTE),
                "APPLICANTS"           VARCHAR2(4000 BYTE),
                "PUBLICATION_NUMBER"   VARCHAR2(4000 BYTE),
                "EARLIEST_PRIORITY"    VARCHAR2(4000 BYTE),
                "IPC"                  VARCHAR2(4000 BYTE),
                "CPC"                  VARCHAR2(4000 BYTE),
                "PUBLICATION_DATE"     VARCHAR2(4000 BYTE),
                "EARLIEST_PUBLICATION" VARCHAR2(4000 BYTE),
                "FAMILY_NUMBER"        VARCHAR2(4000 BYTE)
        );

--- Final Transformed Data Table to store normalized CPC data
CREATE TABLE
        "PAT_CPC_SPLIT_DATA"
        (
                "PAT_SEQ_ID" NUMBER,
                "SUB_SEQ_ID" NUMBER,
                "CPC"        VARCHAR2(4000 BYTE)
        );

--- Table to store Country Code standards used by Patent Offices around the worldwide
CREATE TABLE
        "PAT_COUNTRY_CODE"
        (
                "COUNTRY_CODE" VARCHAR2(4000 BYTE),
                "COUNTRY_DESC" VARCHAR2(4000 BYTE),
                "TYPE"         VARCHAR2(1 BYTE)
        );

--- Final Transformed Data Table definition to store Applicant Level normalized data
CREATE TABLE
        "PAT_APPLICANTS_SPLIT_DATA"
        (
                "PATENT_SEQ_ID" NUMBER,
                "SUB_SEQ_ID"    NUMBER,
                "APPLICANTS"    VARCHAR2(4000 BYTE)
        );
