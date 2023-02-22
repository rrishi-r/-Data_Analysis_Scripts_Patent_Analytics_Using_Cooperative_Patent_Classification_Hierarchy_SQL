-- ======================================================================================================
-- Author:      Rishi Raghav
-- Create date: 08-20-2021
-- Description: Patent Data Transformed Extraction for Analytics Dashboard feed
-- Details:  CPC Normalized data joined to the Raw Patent Publication data and Labeled CPC Hierarchy
-- Comments:  Normalized data will be used in Patent Analytics platorm with particular focus on CPC
-- SQL Name: ANALYTICS_EXTRACT.sql
-- =======================================================================================================
SELECT DISTINCT
        A.Subject_Code "Subject Code"              ,
        A.Subject_Desc "Subject Description"       ,
        A.CPC_PARENT_CODE "CPC Parent Code"        ,
        A.CPC_PARENT_DESC "CPC Parent Description" ,
        A.CPC_CODE "CPC Code"                      ,
        TRIM(NVL(SUBSTR(A.CPC_DESC, instr(A.CPC_DESC, '-', 1, 1) + 1, LENGTH(A.CPC_DESC)), A.CPC_DESC)) "CPC Description"
        /*  Get Patent Publication # and Date from Raw Espacenet Database */
        ,
        C.PUBLICATION_NUMBER "Publication Number"     ,
        C.EARLIEST_PUBLICATION "Earliest Publication" ,
        D.COUNTRY_CODE "Country Code"                 ,
        INITCAP(D.COUNTRY_DESC) "Country Description"
FROM
        CPC_TBL            A ,
        PAT_CPC_SPLIT_DATA B ,
        PAT_EXTRACT_DATA   C ,
        PAT_COUNTRY_CODE   D
WHERE
        A.CPC_CODE     = SUBSTR(B.CPC, 1, INSTR(B.CPC, '(', 1, 1)-2)
AND     B.PAT_SEQ_ID   = C.PATENT_SEQ_ID
AND     B.SUB_SEQ_ID   = C.SUB_SEQ_ID
AND     D.COUNTRY_CODE = SUBSTR(C.PUBLICATION_NUMBER, 1, 2);