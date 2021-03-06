--
-- Type: TABLE; Owner: DEAPP; Name: DE_RNASEQ_TRANSCRIPT_ANNOT
--
 CREATE TABLE "DEAPP"."DE_RNASEQ_TRANSCRIPT_ANNOT"
  (	"ID" NUMBER NOT NULL ENABLE,
"GPL_ID" VARCHAR2(50 BYTE) NOT NULL ENABLE,
"REF_ID" VARCHAR2(50 BYTE) NOT NULL ENABLE,
"CHROMOSOME" VARCHAR2(2 BYTE),
"START_BP" NUMBER,
"END_BP" NUMBER,
"TRANSCRIPT" VARCHAR2(100 BYTE),
 CONSTRAINT "DE_RNASEQ_TR_ANNOT_PK" PRIMARY KEY ("ID")
 USING INDEX
 TABLESPACE "TRANSMART"  ENABLE,
 CONSTRAINT "DE_RNASEQ_TR_ANNOT_REF_ID_UNQ" UNIQUE ("GPL_ID", "REF_ID")
 USING INDEX
 TABLESPACE "TRANSMART"  ENABLE
  ) SEGMENT CREATION DEFERRED
NOCOMPRESS LOGGING
 TABLESPACE "TRANSMART" ;
--
-- Type: REF_CONSTRAINT; Owner: DEAPP; Name: DE_RNASEQ_TR_ANNOT_GPL_FKEY
--
ALTER TABLE "DEAPP"."DE_RNASEQ_TRANSCRIPT_ANNOT" ADD CONSTRAINT "DE_RNASEQ_TR_ANNOT_GPL_FKEY" FOREIGN KEY ("GPL_ID")
 REFERENCES "DEAPP"."DE_GPL_INFO" ("PLATFORM") ENABLE;
