--
-- Type: TABLE; Owner: I2B2DEMODATA; Name: ASYNC_JOB
--
 CREATE TABLE "I2B2DEMODATA"."ASYNC_JOB" 
  (	"ID" NUMBER NOT NULL ENABLE, 
"JOB_NAME" VARCHAR2(200 BYTE), 
"JOB_STATUS" VARCHAR2(200 BYTE), 
"RUN_TIME" VARCHAR2(200 BYTE), 
"JOB_STATUS_TIME" TIMESTAMP (6), 
"LAST_RUN_ON" TIMESTAMP (6), 
"VIEWER_URL" VARCHAR2(4000 BYTE), 
"ALT_VIEWER_URL" VARCHAR2(4000 BYTE), 
"JOB_RESULTS" CLOB, 
"JOB_INPUTS_JSON" CLOB, 
"JOB_TYPE" VARCHAR2(20 BYTE),
"USER_ID" VARCHAR2(50 BYTE),
 PRIMARY KEY ("ID")
 USING INDEX
 TABLESPACE "TRANSMART"  ENABLE
  ) SEGMENT CREATION IMMEDIATE
 TABLESPACE "TRANSMART" 
LOB ("JOB_RESULTS") STORE AS BASICFILE (
 TABLESPACE "TRANSMART" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
 NOCACHE LOGGING ) 
LOB ("JOB_INPUTS_JSON") STORE AS BASICFILE (
 TABLESPACE "TRANSMART" ENABLE STORAGE IN ROW CHUNK 8192 RETENTION 
 NOCACHE LOGGING ) ;

--
-- add documentation
--
COMMENT ON TABLE i2b2demodata.async_job IS 'Stores record per an advanced analysis job.';

COMMENT ON COLUMN async_job.job_name IS 'The job name. e.g. admin-RHeatmap-100448';
COMMENT ON COLUMN async_job.job_status IS 'The status of the job. [Started|Cancelled|Error|Completed|...]';
COMMENT ON COLUMN async_job.job_status_time IS 'The time when current job_status took place.';
COMMENT ON COLUMN async_job.last_run_on IS 'The start time of the job.';
COMMENT ON COLUMN async_job.user_id IS 'Name of the user.';
