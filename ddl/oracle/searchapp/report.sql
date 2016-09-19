--
-- Type: TABLE; Owner: SEARCHAPP; Name: REPORT
--
 CREATE TABLE "SEARCHAPP"."REPORT" 
  (	"REPORT_ID" NUMBER, 
"NAME" VARCHAR2(200 BYTE), 
"DESCRIPTION" VARCHAR2(1000 BYTE), 
"CREATINGUSER" VARCHAR2(200 BYTE), 
"PUBLIC_FLAG" VARCHAR2(20 BYTE), 
"CREATE_DATE" TIMESTAMP (6), 
"STUDY" VARCHAR2(200 BYTE)
  ) SEGMENT CREATION DEFERRED
 TABLESPACE "TRANSMART" ;

