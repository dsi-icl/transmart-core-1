--
-- Type: TABLE; Owner: TM_WZ; Name: I2B2_LOAD_PATH
--
 CREATE TABLE "TM_WZ"."I2B2_LOAD_PATH" 
  (	"PATH" VARCHAR2(700 BYTE), 
"RECORD_ID" ROWID, 
 PRIMARY KEY ("PATH", "RECORD_ID") ENABLE
  ) ORGANIZATION INDEX NOCOMPRESS
 TABLESPACE "TRANSMART" 
PCTTHRESHOLD 50;
