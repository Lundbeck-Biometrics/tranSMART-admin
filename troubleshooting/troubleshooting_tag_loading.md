## Identifying how to programmatically load the program info

The approach is to add a program manually through the interface and see what was written in the database and where.

### Difference for adding a program called "Public Studies":

```
'amapp','am_tag_association',0
'amapp','am_tag_association',5

'amapp','am_tag_template_association',0
'amapp','am_tag_template_association',1

'fmapp','fm_data_uid',0
'fmapp','fm_data_uid',1

'fmapp','fm_folder',0
'fmapp','fm_folder',1
```

Also, not related to actual data, but more that an event of creating a program has occurred is logged in: 

```
'searchapp','search_app_access_log',836
'searchapp','search_app_access_log',837
```

This gives us an idea of where the info was stored.

### What was actually written

Based on the content of these tables we can work out what the INSERT statement would be.

```
- FMAPP.FM_DATA_UID
-- fm_data_id is primary key; val '1992447'

INSERT INTO fmapp.fm_data_uid
(fm_data_id,unique_id,fm_data_type)
VALUES
(1992447,'FOL:1992447','FM_FOLDER');

-- FMAPP.FM_FOLDER
-- folder_id is primary key; val '1992447'

INSERT INTO fmapp.fm_folder 
(folder_id,folder_name,folder_full_name,folder_level,folder_type,folder_tag,active_ind,parent_id,description)
VALUES
(1992447,'Public Studies','\FOL:1992447\',0,'PROGRAM',null,true,null,'Datasets from publicly available sources');


-- AMAPP.AM_TAG_ASSOCIATION
-- subject_uid and object_uid are primary keys
-- tag_item_id refers to definition of what tags are available (am_tag_item table)

INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
VALUES
('FOL:1992447','DIS:D000544','PROGRAM_TARGET',1995568),
('FOL:1992447','DIS:D003865','PROGRAM_TARGET',1995568),
('FOL:1992447','DIS:D010300','PROGRAM_TARGET',1995568),
('FOL:1992447','DIS:D012559','PROGRAM_TARGET',1995568),
('FOL:1992447','THERAPEUTIC_DOMAIN:NERVOUS_SYSTEM_DISEASES','BIO_CONCEPT_CODE',1995569);

-- AMAPP.am_tag_template_association
-- tag_template_id and object_uid are primary keys
-- tag_template_id refers to what types of templates are available (tag_template_id in am_tag_template table)

INSERT INTO amapp.am_tag_template_association
(tag_template_id,object_uid,id)
VALUES
(1995564,'FOL:1992447',1995735);
```

### Deleting existing program before programmatically testing the insert

```
delete from amapp.am_tag_template_association where object_uid = 'FOL:1992447'; 

delete from amapp.am_tag_association where subject_uid = 'FOL:1992447';

delete from fmapp.fm_folder where folder_id = 1992447;

delete from fmapp.fm_data_uid where fm_data_id = 1992447;

```

### Adding a new program

Without specifying an ID, though that will work as well if it is unique.

```
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
```


## Identifying how to programmatically load the study info

The approach is to add a study manually through the interface and see what was written in the database and where.
Note: this was done before the customization of the study level metadata, meaning that this exercise was done on the out of the box tags.

### Difference for adding a study in "Public Studies" called "GSE8581":

```
'amapp','am_data_uid',0
'amapp','am_data_uid',7

'amapp','am_tag_association',5
'amapp','am_tag_association',17

'amapp','am_tag_template_association',1
'amapp','am_tag_template_association',2

'amapp','am_tag_value',0
'amapp','am_tag_value',7

'fmapp','fm_data_uid',1
'fmapp','fm_data_uid',2

'fmapp','fm_folder',1
'fmapp','fm_folder',2
```

Also, not related to actual data, but more that an event of creating a study has occurred is logged in: 

```
'searchapp','search_app_access_log',851
'searchapp','search_app_access_log',853
```

### What was actually written

```
-- AMAPP.AM_DATA_UID
-- am_data_id is primary key, bigint

INSERT INTO AMAPP.AM_DATA_UID 
(am_data_id,unique_id,am_data_type)
VALUES
(1995736,'TAG:1995736','AM_TAG_VALUE')
(1995737,'TAG:1995737','AM_TAG_VALUE'),
(1995738,'TAG:1995738','AM_TAG_VALUE'),
(1995739,'TAG:1995739','AM_TAG_VALUE'),
(1995740,'TAG:1995740','AM_TAG_VALUE'),
(1995741,'TAG:1995741','AM_TAG_VALUE'),
(1995742,'TAG:1995742','AM_TAG_VALUE');

-- AMAPP.AM_TAG_ASSOCIATION
-- subject_uid and object_uid are primary keys
-- tag_item_id refers to definition of what tags are available (am_tag_item table)

INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
VALUES
('FOL:1992448','DIS:D029424','BIO_DISEASE','1995526'),
('FOL:1992448','SPECIES:HOMO_SAPIENS','BIO_CONCEPT_CODE','1995537'),
('FOL:1992448','STUDY_OBJECTIVE:DISCOVER_BIOMARKERS','BIO_CONCEPT_CODE','1995531'),
('FOL:1992448','STUDY_PHASE:PRECLINICAL','BIO_CONCEPT_CODE','1995530'),
('FOL:1992448','STUDY_PUBLICATION_STUDY_PUBLICATION_STATUS:PUBLISHED','BIO_CONCEPT_CODE','1995546'),
('FOL:1992448','TAG:1995736','AM_TAG_VALUE','1995535'),
('FOL:1992448','TAG:1995737','AM_TAG_VALUE','1995536'),
('FOL:1992448','TAG:1995738','AM_TAG_VALUE','1995541'),
('FOL:1992448','TAG:1995739','AM_TAG_VALUE','1995542'),
('FOL:1992448','TAG:1995740','AM_TAG_VALUE','1995543'),
('FOL:1992448','TAG:1995741','AM_TAG_VALUE','1995544'),
('FOL:1992448','TAG:1995742','AM_TAG_VALUE','1995545');

-- AMAPP.am_tag_template_association
-- tag_template_id and object_uid are primary keys
-- tag_template_id refers to what types of templates are available (tag_template_id in am_tag_template table)

INSERT INTO amapp.am_tag_template_association
(tag_template_id,object_uid,id)
VALUES
(1995523,'FOL:1992448',1995743);

-- AMAPP.AM_TAG_VALUE
-- tag_value_id is primary key
-- There are two triggers:
--   one to generate the next ID for the tag_value_id
--   one to insert into amapp.am_data_uid (meaning that we dont need to do the insert in am_data_uid manually)

INSERT INTO amapp.am_tag_value
(tag_value_id,value)
VALUES
(1995736,'https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE8581'),
(1995737,'56'),
(1995738,'2009'),
(1995739,'18849563'),
(1995740,'18849563'),
(1995741,'Bhattacharya S, Srisuma S, Demeo DL, Shapiro SD et al'),
(1995742,'Molecular biomarkers for quantitative and discrete COPD phenotypes');

- FMAPP.FM_DATA_UID
-- fm_data_id is primary key; val '1992448'

INSERT INTO fmapp.fm_data_uid
(fm_data_id,unique_id,fm_data_type)
VALUES
(1992448,'FOL:1992448','FM_FOLDER');

-- FMAPP.FM_FOLDER
-- folder_id is primary key; val '1992448'
-- trigger on folder_id to be created, and another trigger to load into fm_data_uid

INSERT INTO fmapp.fm_folder 
(folder_id,folder_name,folder_full_name,folder_level,folder_type,folder_tag,active_ind,parent_id,description)
VALUES
(1992448,'GSE8581','\FOL:1992447\FOL:1992448\',1,'STUDY',null,true,1992447,'To identify gene expression markers for COPD, we performed genome-wide expression profiling of lung tissue from 56 subjects using the Affymetrix U133 Plus 2.0 array.');


```

### Deleting the existing study before we test the scripting

Note: this assumes that there is only one study created, because it will delete all tags (does not check on study)

```
delete from amapp.am_tag_template_association where object_uid = 'FOL:1992448'; 

delete from amapp.am_tag_association where subject_uid = 'FOL:1992448';

delete from amapp.AM_DATA_UID;

delete from amapp.AM_TAG_VALUE;

delete from fmapp.fm_folder where folder_id = 1992448;

delete from fmapp.fm_data_uid where fm_data_id = 1992448;
```

### Adding a new study

Works without the need for specifying an ID

```
SET search_path TO fmapp;

-- inserting a new folder and thus generating a new ID
-- this actually creates a new entry in the fmapp.fm_data_uid table as well, so no manual insert is needed for that table
INSERT INTO fm_folder 
(folder_name,folder_level,folder_type,folder_tag,active_ind,parent_id,description)
SELECT 
'GSE8581',1,'STUDY',null,true,folder_id,'To identify gene expression markers for COPD, we performed genome-wide expression profiling of lung tissue from 56 subjects using the Affymetrix U133 Plus 2.0 array.'
from fmapp.fm_folder where folder_name='Public Studies';

-- get the id for the new folder
select folder_id from fm_folder where folder_name='GSE8581';

-- insert the lookup tags
INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT 'FOL:'||folder_id,'DIS:D029424','BIO_DISEASE',1995526 from fm_folder where folder_name='GSE8581';

INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT 'FOL:'||folder_id,'SPECIES:HOMO_SAPIENS','BIO_CONCEPT_CODE',1995537 from fm_folder where folder_name='GSE8581';

INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT 'FOL:'||folder_id,'STUDY_OBJECTIVE:DISCOVER_BIOMARKERS','BIO_CONCEPT_CODE',1995531 from fm_folder where folder_name='GSE8581';

INSERT INTO amapp.am_tag_association
(subject_uid,object_uid,object_type,tag_item_id)
SELECT 'FOL:'||folder_id,'STUDY_PHASE:PRECLINICAL','BIO_CONCEPT_CODE',1995530 from fm_folder where folder_name='GSE8581';

-- insert the value tags

-- TO-DO: insert the tags

-- apply template
INSERT INTO amapp.am_tag_template_association
(tag_template_id,object_uid)
SELECT 1995523, 'FOL:'||folder_id from fm_folder where folder_name='GSE8581';

```
