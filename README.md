# Patent Analytics Program Setup & Walkthrough (For SQL)
## Install
1) This project uses the Oracle SQL developer.
2) Install SQL developer from Oracle website (Oracle.com).

## Oracle Cloud
1) Install Oracle Database XE or provision an Oracle Automomous Database Cloud instance. 
2) Download Oracle XE Client for Windows or Mac. 

## Running the Program
1) Run TABLE_DEFS.sql to setup the database tables
2) Import patent raw data Patent_Application_Extract_by_CPC.dat into PAT_EXTRACT_DATA
3) Run PAT_CPC_SPLIT_PROC.sql  
4) Run PAT_APPLICANTS_SPLIT_PROC.sql
5) Run ANALYTICS_EXTRACT.sql to export normalized Patent Analytics data to Excel
6) Import Excel into Zoho analytics platform
