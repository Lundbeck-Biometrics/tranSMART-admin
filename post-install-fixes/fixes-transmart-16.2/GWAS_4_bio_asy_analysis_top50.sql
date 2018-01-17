-- Issue: tranSMART encountered an error while running this query 
-- (org.postgresql.util.PSQLException ERROR: column "beta" does not exist Position: 118)
-- Solution: the beta column is missing in the biomart.bio_asy_analysis_gwas_top50 table
-- so we create the table again, with the expected columns
-- A similar issue occurs for eQTL data, giving an error on colum "gene" missing

-- Connect to the server and run postgres commands to recreate the table
-- cd /datastore/postgresql/tablespaces/
-- sudo su postgres
-- psql -d transmart

-- Table: biomart.bio_asy_analysis_gwas_top50

DROP TABLE biomart.bio_asy_analysis_gwas_top50;

CREATE TABLE biomart.bio_asy_analysis_gwas_top50
(
  bio_assay_analysis_id bigint,
  analysis character varying(500),
  chrom character varying(4),
  pos numeric(10,0),
  rsgene character varying(200),
  rsid character varying(50),
  pvalue double precision,
  logpvalue double precision,
  extdata character varying(4000),
  rnum bigint,
  intronexon character varying(10),
  regulome character varying(10),
  recombinationrate numeric(18,6),
  beta character varying(100),
  effect_allele character varying(100),
  other_allele character varying(100),
  standard_error character varying(100),
  strand smallint
)
WITH (
  OIDS=FALSE
)
TABLESPACE transmart;
ALTER TABLE biomart.bio_asy_analysis_gwas_top50
  OWNER TO biomart;
GRANT ALL ON TABLE biomart.bio_asy_analysis_gwas_top50 TO biomart;
GRANT ALL ON TABLE biomart.bio_asy_analysis_gwas_top50 TO tm_cz;
GRANT SELECT ON TABLE biomart.bio_asy_analysis_gwas_top50 TO biomart_user;


-- Table: biomart.bio_asy_analysis_eqtl_top50

DROP TABLE biomart.bio_asy_analysis_eqtl_top50;

CREATE TABLE biomart.bio_asy_analysis_eqtl_top50
(
  bio_assay_analysis_id bigint,
  analysis character varying(500),
  chrom character varying(4),
  pos numeric(10,0),
  rsgene character varying(200),
  rsid character varying(50),
  pvalue double precision,
  logpvalue double precision,
  extdata character varying(4000),
  rnum bigint,
  intronexon character varying(10),
  regulome character varying(10),
  recombinationrate numeric(18,6),
  gene character varying(200),
  strand smallint
)
WITH (
  OIDS=FALSE
)
TABLESPACE transmart;
ALTER TABLE biomart.bio_asy_analysis_eqtl_top50
  OWNER TO biomart;
GRANT ALL ON TABLE biomart.bio_asy_analysis_eqtl_top50 TO biomart;
GRANT ALL ON TABLE biomart.bio_asy_analysis_eqtl_top50 TO tm_cz;
GRANT SELECT ON TABLE biomart.bio_asy_analysis_eqtl_top50 TO biomart_user;

-- To exit from psql console type \q