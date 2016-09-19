--
-- Type: TABLE; Owner: FMAPP; Name: FM_FOLDER_ASSOCIATION
--
 CREATE TABLE "FMAPP"."FM_FOLDER_ASSOCIATION" 
  (	"FOLDER_ID" NUMBER(18,0) NOT NULL ENABLE, 
"OBJECT_UID" NVARCHAR2(300) NOT NULL ENABLE, 
"OBJECT_TYPE" NVARCHAR2(100) NOT NULL ENABLE, 
 CONSTRAINT "PK_FOLDER_ASSOC" PRIMARY KEY ("FOLDER_ID", "OBJECT_UID") DISABLE
  ) SEGMENT CREATION IMMEDIATE
 TABLESPACE "TRANSMART" ;

--
-- Type: REF_CONSTRAINT; Owner: FMAPP; Name: FK_FM_FOLDER_ASSOC_FM_FOLDER
--
ALTER TABLE "FMAPP"."FM_FOLDER_ASSOCIATION" ADD CONSTRAINT "FK_FM_FOLDER_ASSOC_FM_FOLDER" FOREIGN KEY ("FOLDER_ID")
 REFERENCES "FMAPP"."FM_FOLDER" ("FOLDER_ID") ENABLE;

