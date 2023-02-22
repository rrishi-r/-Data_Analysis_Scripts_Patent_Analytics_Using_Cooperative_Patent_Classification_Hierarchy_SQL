-- ======================================================================================================
-- Author:      Rishi Raghav
-- Create date: 08-20-2021
-- Description: To Normalize Patent Dataset repository extracted European Patent Office
-- Details:		Normalize by CPC , Applicant and Country Attribution
-- Comments: 	Normalized data will be used in Patent Analytics platorm with particular focus on CPC
-- Procedure Name: PAT_CPC_SPLIT_PROC
-- =======================================================================================================
CREATE OR REPLACE PROCEDURE PAT_CPC_SPLIT_PROC
AS
        --This is your declaration section to extract Raw Patent Data Set
        CURSOR MY_CURSOR IS
                SELECT
                        PATENT_SEQ_ID ,
                        SUB_SEQ_ID    ,
                        CPC
                FROM
                        PAT_EXTRACT_DATA;
        
        V_CPC_COUNT NUMBER;
        V_CPC       VARCHAR2(4000);
BEGIN
		-- Initialize to clear Split Data Table
        DELETE
        FROM
                PAT_CPC_SPLIT_DATA;
        
		-- Open Cursor
        FOR REC IN MY_CURSOR
        LOOP
				-- Use Regular Expression to identify number of CPC in the each of row of raw data
                V_CPC_COUNT := REGEXP_COUNT(REC.CPC, CHR(10)) + 1;
                IF V_CPC_COUNT = 1 THEN
                        INSERT INTO
                                PAT_CPC_SPLIT_DATA
                                (
                                        PAT_SEQ_ID ,
                                        SUB_SEQ_ID ,
                                        CPC
                                )
                                VALUES
                                (
                                        REC.PATENT_SEQ_ID ,
                                        REC.SUB_SEQ_ID    ,
                                        REC.CPC
                                );
                
                ELSE
                        FOR i IN 1..V_CPC_COUNT
                        LOOP
								-- Split CPC String into individual Tokens of CPC for normalized insert
                                IF i = 1 THEN
                                        V_CPC := SUBSTR(REC.CPC, 1, INSTR (REC.CPC, CHR(10), 1, 1) - 2);
                                ELSIF i = V_CPC_COUNT THEN
                                        V_CPC := SUBSTR(REC.CPC, INSTR(REC.CPC, CHR(10), 1, i-1)+1, LENGTH (REC.CPC));
                                ELSE
                                        V_CPC := SUBSTR(REC.CPC, INSTR(REC.CPC, CHR(10), 1, i-1)+1, INSTR(REC.CPC, CHR(10), 1, i) - INSTR(REC.CPC, CHR(10), 1, i-1)-2);
                                END IF;
                                INSERT INTO
                                        PAT_CPC_SPLIT_DATA
                                        (
                                                PAT_SEQ_ID ,
                                                SUB_SEQ_ID ,
                                                CPC
                                        )
                                        VALUES
                                        (
                                                REC.PATENT_SEQ_ID ,
                                                REC.SUB_SEQ_ID    ,
                                                V_CPC
                                        );
                        
                        END LOOP;
                END IF;
        END LOOP;
END PAT_CPC_SPLIT_PROC;