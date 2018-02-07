-- Extending current data model for BIO_ASSAY_ANALYSIS_EXT table
-- with six new columns for holding GWAS metadata

ALTER TABLE BIOMART.BIO_ASSAY_ANALYSIS_EXT 
ADD COLUMN num_ctrls character varying(20),
ADD COLUMN num_cases character varying(20),
ADD COLUMN analysis_platform character varying(500),
ADD COLUMN snp_database_id character varying(20),
ADD COLUMN path_source character varying(500),
ADD COLUMN dataset_release_date character varying(20);
