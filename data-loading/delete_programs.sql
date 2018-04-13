-- This will remove the program node. Note however that it will not remove the nodes under it (like study folders)

delete from amapp.am_tag_template_association where object_uid = 'FOL:1992447'; 

delete from amapp.am_tag_association where subject_uid = 'FOL:1992447';

delete from fmapp.fm_folder where folder_id = 1992447;

delete from fmapp.fm_data_uid where fm_data_id = 1992447;
