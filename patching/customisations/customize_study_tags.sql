-- UPDATE EXISTING CELLS

UPDATE amapp.am_tag_item SET required = 0
WHERE (tag_template_id=1995523 AND 
       code_type_name in ('COUNTRY', 'STUDY_DATE', 'STUDY_PUBMED_ID', 'STUDY_PUBLICATION_STUDY_PUBLICATION_DOI'));

UPDATE amapp.am_tag_item SET view_in_grid = 1
WHERE (tag_template_id=1995523 AND 
       code_type_name='STUDY_DESCRIPTION');

-- DELETE TAGS

DELETE FROM amapp.am_tag_item
WHERE (tag_template_id=1995523 AND 
       code_type_name in ('STUDY_DESIGN', 'STUDY_BIOMARKER_TYPE', 'STUDY_ACCESS_TYPE', 
                          'STUDY_PUBLICATION_STUDY_PUBLICATION_AUTHOR_LIST', 
                          'STUDY_PUBLICATION_STUDY_PUBLICATION_TITLE', 
                          'STUDY_PUBLICATION_STUDY_PUBLICATION_STATUS'));

-- UPDATE DISPLAY ORDER TO PREPARE FOR NEW TAGS

UPDATE amapp.am_tag_item set display_order = 8
WHERE (tag_template_id=1995523 AND 
       code_type_name='STUDY_PHASE');

UPDATE amapp.am_tag_item set display_order = 9
WHERE (tag_template_id=1995523 AND 
       code_type_name='STUDY_OBJECTIVE');

-- INSERT NEW TAGS

INSERT INTO amapp.am_tag_item 
VALUES 
(1995523,1995700,0,5,'Lundbeck Compound (if applicable)',0, 1,'LU_COMPOUND', 1, FALSE, 81, null ,'CUSTOM', 1, 'FREETEXT', 0),
(1995523,1995701,0,6,'Lundbeck Compound Target (if applicable)', 0, 1, 'LU_COMPOUND_TARGET', 1, FALSE, 82, null,'CUSTOM', 1, 'FREETEXT', 0),
(1995523,1995702,0,7,'Lundbeck Generic Name (if applicable)', 0, 1,'LU_GENERIC_NAME', 1, FALSE, 83, null,'CUSTOM', 1, 'FREETEXT', 0),
(1995523,1995703,1,10,'Study owner', 0, 1, 'STUDY_OWNER', 1, FALSE, 84, null,'CUSTOM', 1, 'FREETEXT', 0),
(1995523,1995704,0,15,'Types of samples',0, 1,'AVAIL_SAMPLE_TYPES', 1, FALSE, 85, null ,'CUSTOM', 1, 'FREETEXT', 0),
(1995523,1995705,0,14,'Strain (if any)', 0, 1, 'STRAIN', 1, FALSE, 86, null,'CUSTOM', 1, 'FREETEXT', 0);

