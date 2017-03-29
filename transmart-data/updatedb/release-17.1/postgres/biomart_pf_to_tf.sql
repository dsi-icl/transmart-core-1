CREATE SEQUENCE BIOMART.SEQ_ANNOTATION_ID;

CREATE SEQUENCE BIOMART.SEQ_BIO_ASY_PPA;

CREATE SEQUENCE BIOMART.SEQ_GENO_PLATFORM_PROBE_ID;

ALTER TABLE BIOMART.BIO_ASY_ANALYSIS_EQTL_TOP50
 ADD GENE VARCHAR(50);

ALTER TABLE BIOMART.BIO_ASY_ANALYSIS_EQTL_TOP50
 ADD PVALUE_CHAR VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASY_ANALYSIS_EQTL_TOP50
 ADD STRAND VARCHAR(1);

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD PLATFORM_IMPUTED_ALGORITHM VARCHAR(500);

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD PLATFORM_IMPUTED_PANEL VARCHAR(200);

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD PLATFORM_IMPUTED CHAR(1);

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD CREATED_BY VARCHAR(30);

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD CREATED_DATE DATE;

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD MODIFIED_BY VARCHAR(30);

ALTER TABLE BIOMART.BIO_ASSAY_PLATFORM
 ADD MODIFIED_DATE DATE;

CREATE TABLE BIOMART.GENOTYPE_PROBE_ANNOTATION
(
 GENOTYPE_PROBE_ANNOTATION_ID NUMERIC(22)   NOT NULL,
 SNP_NAME           VARCHAR(50),
 CHROM             VARCHAR(4),
 POS              NUMERIC,
 REF              VARCHAR(4000),
 ALT              VARCHAR(4000),
 GENE_INFO           VARCHAR(4000),
 VARIATION_CLASS        VARCHAR(10),
 STRAND            VARCHAR(1),
 EXON_INTRON          VARCHAR(30),
 GENOME_BUILD         VARCHAR(10),
 SNP_SOURCE          VARCHAR(10),
 RECOMBINATION_RATE      NUMERIC(18,6),
 RECOMBINATION_MAP       NUMERIC(18,6),
 REGULOME_SCORE        VARCHAR(10),
 REF_TEXT           TEXT,
 ALT_TEXT           TEXT,
 CREATED_BY          VARCHAR(30),
 CREATED_DATE         DATE,
 MODIFIED_BY          VARCHAR(30),
 MODIFIED_DATE         DATE
);

CREATE INDEX IDX_PROBE_ANNO_SNP ON BIOMART.GENOTYPE_PROBE_ANNOTATION
(SNP_NAME);

CREATE INDEX IDX_GENO_ANNO_LOC ON BIOMART.GENOTYPE_PROBE_ANNOTATION
(CHROM, POS);

CREATE UNIQUE INDEX PK_GENO_PROBE_ANNOTATION ON BIOMART.GENOTYPE_PROBE_ANNOTATION
(GENOTYPE_PROBE_ANNOTATION_ID);

ALTER TABLE BIOMART.GENOTYPE_PROBE_ANNOTATION
 ADD CONSTRAINT PK_GENO_PROBE_ANNOTATION
 PRIMARY KEY
 (GENOTYPE_PROBE_ANNOTATION_ID);

CREATE TABLE BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE
(
 BIO_ASY_GENO_PLATFORM_PROBE_ID NUMERIC(18)  NOT NULL,
 BIO_ASSAY_PLATFORM_ID      NUMERIC(18)  NOT NULL,
 ORIG_CHROM           VARCHAR(5),
 ORIG_POSITION          NUMERIC,
 ORIG_GENOME_BUILD        VARCHAR(20),
 PROBE_NAME           VARCHAR(200),
 IS_CONTROL           CHAR(1),
 CREATED_BY           VARCHAR(30),
 CREATED_DATE          DATE,
 MODIFIED_BY           VARCHAR(30),
 MODIFIED_DATE          DATE
);

CREATE INDEX IDX_BIO_ASY_GPP_PROBE_NAME ON BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE
(PROBE_NAME);

CREATE INDEX IDX_BIO_ASY_GPP_PLATFORM ON BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE
(BIO_ASSAY_PLATFORM_ID);

CREATE UNIQUE INDEX IDX_BIO_ASSAY_GP_PROBE_PK ON BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE
(BIO_ASY_GENO_PLATFORM_PROBE_ID);

ALTER TABLE BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE
 ADD CONSTRAINT PK_BIO_ASY_GP_PROBE
 PRIMARY KEY
 (BIO_ASY_GENO_PLATFORM_PROBE_ID);

CREATE INDEX BIO_MKR_SRC_EXT_ID_IDX ON BIOMART.BIO_MARKER
(PRIMARY_SOURCE_CODE, PRIMARY_EXTERNAL_ID);

CREATE INDEX B_ASY_EQTL_T50_IDX1 ON BIOMART.BIO_ASY_ANALYSIS_EQTL_TOP50
(BIO_ASSAY_ANALYSIS_ID);

CREATE INDEX IDX_BIO_RECOMB_1 ON BIOMART.BIO_RECOMBINATION_RATES
(POSITION, CHROMOSOME);

CREATE UNIQUE INDEX BIO_DATA_PLATFORM_PK ON BIOMART.BIO_DATA_PLATFORM
(BIO_DATA_ID, BIO_ASSAY_PLATFORM_ID);

CREATE UNIQUE INDEX BIO_DATA_OBSERVATION_PK ON BIOMART.BIO_DATA_OBSERVATION
(BIO_DATA_ID, BIO_OBSERVATION_ID);

CREATE UNIQUE INDEX BIO_ASSAY_ANALYSIS_EQTL_PK ON BIOMART.BIO_ASSAY_ANALYSIS_EQTL
(BIO_ASY_ANALYSIS_EQTL_ID);

CREATE UNIQUE INDEX BIO_D_O_M_MARKER2_PK ON BIOMART.BIO_DATA_OMIC_MARKER
(BIO_MARKER_ID, BIO_DATA_ID);

CREATE UNIQUE INDEX BIO_D_FG_M_MARKER2_PK ON BIOMART.BIO_ASSAY_DATA_ANNOTATION
(BIO_MARKER_ID, BIO_ASSAY_FEATURE_GROUP_ID);

CREATE OR REPLACE FUNCTION BIOMART.FUN_ANNOTATION_ID() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF NEW.GENOTYPE_PROBE_ANNOTATION_ID IS NULL
   THEN
     SELECT nextval('BIOMART.SEQ_ANNOTATION_ID')
      INTO NEW.GENOTYPE_PROBE_ANNOTATION_ID;
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER TRG_ANNOTATION_IDBEFORE BEFORE INSERT ON BIOMART.GENOTYPE_PROBE_ANNOTATION FOR EACH ROW EXECUTE PROCEDURE BIOMART.FUN_ANNOTATION_ID();

CREATE OR REPLACE FUNCTION BIOMART.FUN_GENO_PLATFORM_PROBE_ID() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF NEW.BIO_ASY_GENO_PLATFORM_PROBE_ID IS NULL
   THEN
     SELECT nextval('BIOMART.SEQ_GENO_PLATFORM_PROBE_ID')
      INTO NEW.BIO_ASY_GENO_PLATFORM_PROBE_ID;
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER TRG_GENO_PLATFORM_PROBE_ID BEFORE INSERT ON BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE FOR EACH ROW EXECUTE PROCEDURE BIOMART.FUN_GENO_PLATFORM_PROBE_ID();

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS
 ADD UPDATE_OF NUMERIC(18);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS
 ADD CREATED_BY VARCHAR(30);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS
 ADD MODIFIED_BY VARCHAR(30);

CREATE TABLE BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
(
 BIO_ASY_PLATFORM_PROBE_ANNO_ID NUMERIC(22)  NOT NULL,
 BIO_ASY_GENO_PLATFORM_PROBE_ID NUMERIC(22)  NOT NULL,
 GENOTYPE_PROBE_ANNOTATION_ID  NUMERIC(22)  NOT NULL,
 BIO_ASSAY_PLATFORM_ID      NUMERIC(18)  NOT NULL,
 GENOME_BUILD          VARCHAR(10),
 CREATED_BY           VARCHAR(30),
 CREATED_DATE          DATE,
 MODIFIED_BY           VARCHAR(30),
 MODIFIED_DATE          DATE
);

CREATE UNIQUE INDEX PK_BIO_ASY_PLATFORM_PROBE_ANNO ON BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
(BIO_ASY_PLATFORM_PROBE_ANNO_ID);

CREATE INDEX IDX_BIO_ASY_PPANNO_PROBE ON BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
(BIO_ASY_GENO_PLATFORM_PROBE_ID);

CREATE INDEX IDX_BIO_ASY_PPANNO_PLATFORM ON BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
(BIO_ASSAY_PLATFORM_ID);

CREATE INDEX IDX_BIO_ASY_PPANNO_ANNO ON BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
(GENOTYPE_PROBE_ANNOTATION_ID);

ALTER TABLE BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
 ADD CONSTRAINT PK_BIO_ASY_PLATFORM_PROBE_ANNO
 PRIMARY KEY
 (BIO_ASY_PLATFORM_PROBE_ANNO_ID);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD GENO_PLATFORM_PROBE_ID NUMERIC(22, 0);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD BETA_OLD NUMERIC;

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD STANDARD_ERROR_OLD NUMERIC;

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD EFFECT_ALLELE_TEXT TEXT;

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD OTHER_ALLELE_TEXT TEXT;

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD CREATED_BY VARCHAR(30);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD CREATED_DATE DATE;

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD MODIFIED_BY VARCHAR(30);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD MODIFIED_DATE DATE;

CREATE INDEX IDX_GWAS_GENO_PLTFM_PROBE_ID ON BIOMART.BIO_ASSAY_ANALYSIS_GWAS
(GENO_PLATFORM_PROBE_ID);

CREATE UNIQUE INDEX IDX3_BIO_ASSAY_ANALYSIS_GWAS ON BIOMART.BIO_ASSAY_ANALYSIS_GWAS
(BIO_ASSAY_ANALYSIS_ID, RS_ID);

CREATE INDEX IDX2_BIO_ASSAY_ANALYSIS_GWAS ON BIOMART.BIO_ASSAY_ANALYSIS_GWAS
(RS_ID);

CREATE INDEX BIO_MARKER_CORREL_MV_ABM_IDX ON BIOMART.BIO_MARKER_CORREL_MV
(ASSO_BIO_MARKER_ID);

CREATE OR REPLACE FUNCTION BIOMART.FUN_BIO_ASY_PPA() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   IF NEW.BIO_ASY_PLATFORM_PROBE_ANNO_ID IS NULL
   THEN
     SELECT nextval('BIOMART.SEQ_BIO_ASY_PPA')
      INTO NEW.BIO_ASY_PLATFORM_PROBE_ANNO_ID;
   END IF;
   RETURN NEW;
END;
$$;

CREATE TRIGGER TRG_BIO_ASY_PPA BEFORE INSERT ON BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO FOR EACH ROW EXECUTE PROCEDURE BIOMART.FUN_BIO_ASY_PPA();


ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD PERCENT_MALE NUMERIC;

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD EFFECT_TYPE VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD EFFECT_UNITS VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD EFFECT_ERROR1_TYPE VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD EFFECT_ERROR2_TYPE VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD EFFECT_ERROR_DESC VARCHAR(1000);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD TRAIT VARCHAR(255);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD REQUESTOR VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD DATA_OWNER VARCHAR(100);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD SD_TRAIT_POPULATION NUMERIC;

CREATE UNIQUE INDEX PK_BAAD ON BIOMART.BIO_ASSAY_ANALYSIS_DATA
(BIO_ASY_ANALYSIS_DATA_ID);

CREATE INDEX BAADT_IDX17 ON BIOMART.BIO_ASSAY_ANALYSIS_DATA_TEA
(BIO_ASSAY_ANALYSIS_ID, TEA_RANK);

CREATE INDEX IDX2_BIO_ASY_GWAS_TOP50 ON BIOMART.BIO_ASY_ANALYSIS_GWAS_TOP50
(ANALYSIS);

CREATE INDEX IDX1_BIO_ASY_GWAS_T50 ON BIOMART.BIO_ASY_ANALYSIS_GWAS_TOP50
(BIO_ASSAY_ANALYSIS_ID);

ALTER TABLE BIOMART.BIO_ASY_ANALYSIS_DATA_IDX
 ADD CONSTRAINT PK_BIO_ASY_DATA_IDX
 PRIMARY KEY
 (BIO_ASY_ANALYSIS_DATA_IDX_ID);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD CONSTRAINT PK_BIO_ASY_ANALY_EXT
 PRIMARY KEY
 (BIO_ASSAY_ANALYSIS_EXT_ID);

ALTER TABLE BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE
 ADD CONSTRAINT FK_BIO_ASY_GP_PROBE_ASY_PLF 
 FOREIGN KEY (BIO_ASSAY_PLATFORM_ID) 
 REFERENCES BIOMART.BIO_ASSAY_PLATFORM (BIO_ASSAY_PLATFORM_ID);

ALTER TABLE BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
 ADD CONSTRAINT FK_BIO_ASY_PPA_PLATFORM 
 FOREIGN KEY (BIO_ASSAY_PLATFORM_ID) 
 REFERENCES BIOMART.BIO_ASSAY_PLATFORM (BIO_ASSAY_PLATFORM_ID);

ALTER TABLE BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
 ADD CONSTRAINT FK_BIO_ASY_PPA_GP_PROBE 
 FOREIGN KEY (BIO_ASY_GENO_PLATFORM_PROBE_ID) 
 REFERENCES BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE (BIO_ASY_GENO_PLATFORM_PROBE_ID);

ALTER TABLE BIOMART.BIO_ASY_PLATFORM_PROBE_ANNO
 ADD CONSTRAINT FK_BIO_ASY_PPA_PROBE_ANNO 
 FOREIGN KEY (GENOTYPE_PROBE_ANNOTATION_ID) 
 REFERENCES BIOMART.GENOTYPE_PROBE_ANNOTATION (GENOTYPE_PROBE_ANNOTATION_ID);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD CONSTRAINT FK_GWAS_BIO_AA 
 FOREIGN KEY (BIO_ASSAY_ANALYSIS_ID) 
 REFERENCES BIOMART.BIO_ASSAY_ANALYSIS (BIO_ASSAY_ANALYSIS_ID);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_GWAS
 ADD CONSTRAINT FK_GWAS_GENO_PLATFORM_PROBE 
 FOREIGN KEY (GENO_PLATFORM_PROBE_ID) 
 REFERENCES BIOMART.BIO_ASSAY_GENO_PLATFORM_PROBE (BIO_ASY_GENO_PLATFORM_PROBE_ID);

ALTER TABLE BIOMART.BIO_ASY_ANALYSIS_GWAS_TOP50
 ADD CONSTRAINT FK_GWAS_TOP50_ASY_ANAL 
 FOREIGN KEY (BIO_ASSAY_ANALYSIS_ID) 
 REFERENCES BIOMART.BIO_ASSAY_ANALYSIS (BIO_ASSAY_ANALYSIS_ID);

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT
 ADD CONSTRAINT FK_ASY_ANALYSIS_EXT_ANALY 
 FOREIGN KEY (BIO_ASSAY_ANALYSIS_ID) 
 REFERENCES BIOMART.BIO_ASSAY_ANALYSIS (BIO_ASSAY_ANALYSIS_ID);
 
CREATE VIEW BIOMART.BIO_MARKER_EXP_ANALYSIS_MV_10 (BIO_MARKER_ID,BIO_EXPERIMENT_ID,BIO_ASSAY_ANALYSIS_ID,"T1.BIO_ASSAY_ANALYSIS_ID*100")
AS SELECT DISTINCT t3.bio_marker_id,
        t1.bio_experiment_id,
        t1.bio_assay_analysis_id,
        t1.bio_assay_analysis_id * 100 + t3.bio_marker_id
 FROM biomart.BIO_ASSAY_ANALYSIS_DATA t1,
    biomart.BIO_EXPERIMENT t2,
    biomart.BIO_MARKER t3,
    biomart.BIO_ASSAY_DATA_ANNOTATION t4
 WHERE   t1.bio_experiment_id = t2.bio_experiment_id
    AND t2.bio_experiment_type = 'Experiment'
    AND t3.bio_marker_id = t4.bio_marker_id
    AND t1.bio_assay_feature_group_id = t4.bio_assay_feature_group_id;