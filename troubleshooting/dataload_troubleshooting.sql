
-- Troubleshooting a data load issue by looking at the job_id

select * from cz_job_master order by job_id desc;
select * from cz_job_error where job_id=11; -- replace job id by latest number
select * from cz_job_audit where job_id=95;

-- Deleting study if errors occured and/or data needs to be reloaded
-- Following queries can be used to delete both clinical and omics data

DELETE FROM i2b2demodata.concept_dimension
WHERE sourcesystem_cd='LIBD';

DELETE FROM i2b2demodata.concept_counts
WHERE concept_path IN
(SELECT c_fullname FROM i2b2metadata.i2b2
WHERE sourcesystem_cd='LIBD');

DELETE FROM i2b2demodata.patient_dimension
WHERE sourcesystem_cd LIKE 'LIBD:%';

DELETE FROM i2b2demodata.observation_fact
WHERE sourcesystem_cd='LIBD';

DELETE FROM deapp.de_subject_microarray_data
WHERE trial_name='LIBD';

DELETE FROM deapp.de_subject_sample_mapping
WHERE TRIAL_NAME='LIBD';

DELETE FROM i2b2metadata.i2b2 WHERE sourcesystem_cd='LIBD';

DELETE FROM i2b2metadata.i2b2_secure WHERE sourcesystem_cd='LIBD';

-- Checking the platform annotation

-- This returns the names of the loaded platform annotations:
select * from de_gpl_info;
-- This is where the platform annotation is loaded (platform_id, probe_id, gene_symbol, gene_id):
select * from de_mrna_annotation;
select * from deapp.de_mrna_annotation where gpl_id='LIBDP';

-- Delete platform annotation

delete from deapp.de_gpl_info where platform='LIBDP';
delete from deapp.de_mrna_annotation where gpl_id='LIBDP';

-- Example of updating the marker_type in platform annotation
-- Gene Expression, RNASEQ

UPDATE deapp.de_gpl_info SET marker_type = 'Gene Expression' WHERE platform = 'LIBDP';

-- Handling GWAS data type

-- Update experiment type from BIO_CLINICAL_TRIAL to Experiment in order for the search to be able to index the GWAS dataset
UPDATE biomart.bio_experiment SET bio_experiment_type = 'experiment' WHERE accession = 'MAGIC';

-- Delete MAGIC dataset load
-- REMEMBER to assign correct bio_assay_analysis_id where it states EDITME
DELETE FROM biomart.BIO_ASSAY_ANALYSIS_GWAS WHERE bio_assay_analysis_id = EDITME;
DELETE FROM biomart.BIO_ASY_ANALYSIS_GWAS_TOP50 WHERE bio_assay_analysis_id = EDITME;
DELETE FROM biomart.BIO_ASSAY_ANALYSIS_EXT WHERE bio_assay_analysis_id = EDITME;
DELETE FROM biomart.BIO_ASSAY_ANALYSIS WHERE bio_assay_analysis_id = EDITME;
DELETE FROM biomart.BIO_EXPERIMENT WHERE accession = 'MAGIC';
DELETE FROM biomart.BIO_DATA_UID WHERE bio_data_type = 'BIO_EXPERIMENT' AND bio_data_id NOT IN (SELECT BIO_EXPERIMENT_ID FROM biomart.BIO_EXPERIMENT);

-- Delete SNP dictionary info
delete from deapp.de_rc_snp_info;
delete from deapp.de_snp_info;
delete from searchapp.search_keyword_term where search_keyword_id in (select search_keyword_id from searchapp.search_keyword where data_category='SNP');
delete from searchapp.search_keyword where data_category='SNP';

