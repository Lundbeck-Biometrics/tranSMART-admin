-- In order to fix the issues in the Browse tab related to creating new programs, studies, and folders
-- we need to add some missing data in the biomart.bio_data_uid table.

-- ADD DISEASE UIDS
-- Code is based on: https://github.com/tranSMART-Foundation/transmart-data/blob/release-16.2/ddl/postgres/tm_cz/functions/set_bio_data_uid_dis.sql

insert into biomart.bio_data_uid(
                    bio_data_id, unique_id, bio_data_type)
                    SELECT
                    bio_disease_id, 'DIS:' || coalesce(bio_disease.mesh_code, 'ERROR'), 'BIO_DISEASE'
                    from biomart.bio_disease
                    where not exists
                      (select 1 from biomart.bio_data_uid
                      where 'DIS:' || coalesce(bio_disease.mesh_code, 'ERROR') = bio_data_uid.unique_id);

-- ADD CONCEPT_CODE UIDS

insert into biomart.bio_data_uid(
                    bio_data_id, unique_id, bio_data_type)
                    SELECT
                    bio_concept_code_id, code_type_name || ':' || bio_concept_code, 'BIO_CONCEPT_CODE'
                    from biomart.bio_concept_code
                    where not exists
                      (select 1 from biomart.bio_data_uid
                      where (bio_concept_code.code_type_name || ':' || bio_concept_code. bio_concept_code) = bio_data_uid.unique_id);
