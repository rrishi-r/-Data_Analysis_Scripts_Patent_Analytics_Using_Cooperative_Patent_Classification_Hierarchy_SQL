-- ======================================================================================================
-- Author:      Rishi Raghav
-- Create date: 08-20-2021
-- Description: To Normalize Patent Dataset repository extracted European Patent Office
-- Details:		Normalize by Applicant  Attribution
-- Comments: 	Normalized data will be used in Patent Analytics platorm with particular focus on CPC
-- Procedure Name: PAT_APPLICANTS_SPLIT_PROC
-- =======================================================================================================
CREATE OR REPLACE PROCEDURE PAT_APPLICANTS_SPLIT_PROC
AS
        --This is your declaration section to extract Applicant level info from raw dataset
        CURSOR MY_CURSOR IS
                SELECT
                        PATENT_SEQ_ID ,
                        SUB_SEQ_ID    ,
                        APPLICANTS
                FROM
                        PAT_EXTRACT_DATA
                WHERE
                        APPLICANTS IS NOT NULL;
        
        V_APPLICANTS_COUNT NUMBER;
        V_APPLICANTS       VARCHAR2(4000);
BEGIN
	-- Initialize to clear Split Data Table
        DELETE
        FROM
                PAT_APPLICANTS_SPLIT_DATA;
        -- Open Cursor
        FOR REC IN MY_CURSOR
        LOOP
				-- Use Regular Expression to identify number of CPC in the each of row of raw data
                V_APPLICANTS_COUNT := REGEXP_COUNT(REC.APPLICANTS, CHR(10)) + 1;
                IF V_APPLICANTS_COUNT = 1 THEN
				--- Perform various insert operations for each Applicant token
                        INSERT INTO
                                PAT_APPLICANTS_SPLIT_DATA
                                (
                                        PATENT_SEQ_ID ,
                                        SUB_SEQ_ID    ,
                                        APPLICANTS
                                )
                                VALUES
                                (
                                        REC.PATENT_SEQ_ID ,
                                        REC.SUB_SEQ_ID    ,
                                        REC.APPLICANTS
                                );
                
                ELSE
						-- Split Applicant String into individual Tokens of Applicants for normalized insert per Patent
                        FOR i IN 1..V_APPLICANTS_COUNT
                        LOOP
                                IF i = 1 THEN
                                        V_APPLICANTS := SUBSTR(REC.APPLICANTS, 1, INSTR (REC.APPLICANTS, CHR(10), 1, 1) - 2);
                                ELSIF i = V_APPLICANTS_COUNT THEN
                                        V_APPLICANTS := SUBSTR(REC.APPLICANTS, INSTR(REC.APPLICANTS, CHR(10), 1, i-1)+1, LENGTH (REC.APPLICANTS));
                                ELSE
                                        V_APPLICANTS := SUBSTR(REC.APPLICANTS, INSTR(REC.APPLICANTS, CHR(10), 1, i-1)+1, INSTR(REC.APPLICANTS, CHR(10), 1, i) - INSTR(REC.APPLICANTS, CHR(10), 1, i-1)-2);
                                END IF;
                                INSERT INTO
                                        PAT_APPLICANTS_SPLIT_DATA
                                        (
                                                PATENT_SEQ_ID ,
                                                SUB_SEQ_ID    ,
                                                APPLICANTS
                                        )
                                        VALUES
                                        (
                                                REC.PATENT_SEQ_ID ,
                                                REC.SUB_SEQ_ID    ,
                                                V_APPLICANTS
                                        );
                        
                        END LOOP;
                END IF;
        END LOOP;
        COMMIT;
END;