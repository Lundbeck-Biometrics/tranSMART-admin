-- In order to fix the issues in the Browse tab related to creating new programs, studies, and folders
-- we need to add some missing data in the biomart.bio_data_uid table.

-- ADD DISEASE UIDS
/* Code is based on: https://github.com/tranSMART-Foundation/transmart-data/blob/release-16.2/ddl/postgres/tm_cz/functions/set_bio_data_uid_dis.sql
   Example of what will be inserted in bio_data_uid: 
  "149895"	"DIS:D008016"	"BIO_DISEASE"
  */

insert into biomart.bio_data_uid(
                    bio_data_id, unique_id, bio_data_type)
                    SELECT
                    bio_disease_id, 'DIS:' || coalesce(bio_disease.mesh_code, 'ERROR'), 'BIO_DISEASE'
                    from biomart.bio_disease
                    where not exists
                      (select 1 from biomart.bio_data_uid
                      where 'DIS:' || coalesce(bio_disease.mesh_code, 'ERROR') = bio_data_uid.unique_id);

-- ADD CONCEPT_CODE UIDS
/* Example of what will be inserted in bio_data_uid:
  "169631"	"STUDY_DESIGN:INTERVENTIONAL"	"BIO_CONCEPT_CODE"
  Various concept types:
  "STUDY_BIOMARKER_TYPE"
  "FOLD_CHG_METRIC"
  "ANALYSIS_METHOD"
  "STUDY_PHASE"
  "ANALYTIC_CATEGORY"
  "GENE_SIG_SOURCE"
  "STUDY_ACCESS_TYPE"
  "STUDY_DESIGN"
  "SPECIES"
  "NORMALIZATION_METHOD"
  "THERAPEUTIC_DOMAIN"
  "P_VAL_CUTOFF"
  "STUDY_PUBLICATION_STUDY_PUBLICATION_STATUS"
  "COUNTRY"
  "STUDY_OBJECTIVE"
  "EXPERIMENT_TYPE"
  "FILE_TYPE"
  "OTHER"
  "ASSAY_TYPE_OF_BM_STUDIED"
  "TISSUE_TYPE"
  "PROVIDER" 
  */

insert into biomart.bio_data_uid(
                    bio_data_id, unique_id, bio_data_type)
                    SELECT
                    bio_concept_code_id, code_type_name || ':' || bio_concept_code, 'BIO_CONCEPT_CODE'
                    from biomart.bio_concept_code
                    where not exists
                      (select 1 from biomart.bio_data_uid
                      where (bio_concept_code.code_type_name || ':' || bio_concept_code.bio_concept_code) = bio_data_uid.unique_id);

-- ADD PLATFORM UIDS
/* Example of what will be inserted in bio_data_uid:
 596  "BAP:GPL17529:DNA Microarray" "BIO_ASSAY_PLATFORM"
  */

insert into biomart.bio_data_uid(
                    bio_data_id, unique_id, bio_data_type)
                    SELECT distinct
                    bio_assay_platform_id, 'BAP:' || platform_accession || ':' || platform_technology, 'BIO_ASSAY_PLATFORM'
                    from biomart.bio_assay_platform
                    where not exists
                      (select 1 from biomart.bio_data_uid
                      where ('BAP:' || bio_assay_platform.platform_accession || ':' || bio_assay_platform.platform_technology) = bio_data_uid.unique_id);
