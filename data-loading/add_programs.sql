
----- Adding 'Public Studies' program

-- set schema so that the triggers and functions can be found
SET search_path TO fmapp;

-- inserting a new folder and thus generating a new ID
-- this actually creates a new entry in the fmapp.fm_data_uid table as well, so no manual insert is needed for that table
INSERT INTO fm_folder 
(folder_name,folder_level,folder_type,folder_tag,active_ind,parent_id,description)
VALUES
('Public Studies',0,'PROGRAM',null,true,null,'Datasets from publicly available sources');

-- get the id and the extended string based id for the new folder
select folder_id, folder_full_name from fm_folder where folder_name='Public Studies';

-- insert the tags
INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D000544','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Public Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D003865','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Public Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D010300','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Public Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D012559','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Public Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'THERAPEUTIC_DOMAIN:NERVOUS_SYSTEM_DISEASES','BIO_CONCEPT_CODE',1995569 from fm_folder where folder_name='Public Studies';
 
 -- apply template

INSERT INTO amapp.am_tag_template_association
(tag_template_id,object_uid)
SELECT 1995564, trim(both '\' from folder_full_name) from fm_folder where folder_name='Public Studies';


----- Adding 'External Studies' program

-- set schema so that the triggers and functions can be found
SET search_path TO fmapp;

-- inserting a new folder and thus generating a new ID
-- this actually creates a new entry in the fmapp.fm_data_uid table as well, so no manual insert is needed for that table
INSERT INTO fm_folder 
(folder_name,folder_level,folder_type,folder_tag,active_ind,parent_id,description)
VALUES
('External Studies',0,'PROGRAM',null,true,null,'Datasets obtained through external collaborations');

-- get the id and the extended string based id for the new folder
select folder_id, folder_full_name from fm_folder where folder_name='External Studies';

-- insert the tags
INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D000544','PROGRAM_TARGET',1995568 from fm_folder where folder_name='External Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D003865','PROGRAM_TARGET',1995568 from fm_folder where folder_name='External Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D010300','PROGRAM_TARGET',1995568 from fm_folder where folder_name='External Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D012559','PROGRAM_TARGET',1995568 from fm_folder where folder_name='External Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'THERAPEUTIC_DOMAIN:NERVOUS_SYSTEM_DISEASES','BIO_CONCEPT_CODE',1995569 from fm_folder where folder_name='External Studies';
 
 -- apply template

INSERT INTO amapp.am_tag_template_association
(tag_template_id,object_uid)
SELECT 1995564, trim(both '\' from folder_full_name) from fm_folder where folder_name='External Studies';

----- Adding 'Lundbeck Studies' program

-- set schema so that the triggers and functions can be found
SET search_path TO fmapp;

-- inserting a new folder and thus generating a new ID
-- this actually creates a new entry in the fmapp.fm_data_uid table as well, so no manual insert is needed for that table
INSERT INTO fm_folder 
(folder_name,folder_level,folder_type,folder_tag,active_ind,parent_id,description)
VALUES
('Lundbeck Studies',0,'PROGRAM',null,true,null,'Internal Lundbeck datasets');

-- get the id and the extended string based id for the new folder
select folder_id, folder_full_name from fm_folder where folder_name='Lundbeck Studies';

-- insert the tags
INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D000544','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Lundbeck Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D003865','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Lundbeck Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D010300','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Lundbeck Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'DIS:D012559','PROGRAM_TARGET',1995568 from fm_folder where folder_name='Lundbeck Studies';
 
 INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT trim(both '\' from folder_full_name),'THERAPEUTIC_DOMAIN:NERVOUS_SYSTEM_DISEASES','BIO_CONCEPT_CODE',1995569 from fm_folder where folder_name='Lundbeck Studies';
 
 -- apply template

INSERT INTO amapp.am_tag_template_association
(tag_template_id,object_uid)
SELECT 1995564, trim(both '\' from folder_full_name) from fm_folder where folder_name='Lundbeck Studies';


