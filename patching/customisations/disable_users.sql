-- Disable default users

UPDATE searchapp.search_auth_principal SET enabled='f' WHERE id=2;
UPDATE searchapp.search_auth_principal SET enabled='f' WHERE id=3;
UPDATE searchapp.search_auth_principal SET enabled='f' WHERE id=701145587;
