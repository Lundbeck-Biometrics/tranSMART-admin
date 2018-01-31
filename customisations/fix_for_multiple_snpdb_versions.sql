-- Log in as postgres user on the database

-- Add human genome version and dbSNP version columns to DE_SNP_INFO

ALTER TABLE DEAPP.DE_SNP_INFO
ADD COLUMN hg_version character varying(10),
ADD COLUMN dbsnp_version character varying(10);

-- Add dbSNP version column to DE_SNP_INFO (human genome version column already exists)

ALTER TABLE DEAPP.DE_RC_SNP_INFO 
ADD COLUMN dbsnp_version character varying(10);

