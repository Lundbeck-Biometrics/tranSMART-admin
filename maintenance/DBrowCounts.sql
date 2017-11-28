-- README
-- This script can be run in the SQL query editor in pgAdmin III
-- to get the table counts for all tables in all schemas in tranSMART DB

-- CREATE A ROW COUNT FUNCTION (SQL STYLE) 
create or replace function 
  count_rows(schema text, tablename text) returns integer
as
$body$
declare
  result integer;
  query varchar;
begin
  query := 'SELECT count(1) FROM ' || schema || '.' || tablename;
  execute query into result;
  return result;
end;
$body$
language 
  plpgsql;

-- APPLY THE ROW COUNT FUNCTION TO ALL SCHEMAS AND TABLES
select 
  table_schema,
  table_name, 
  count_rows(table_schema, table_name) as count
from 
  information_schema.tables
where 
  table_schema not in ('pg_catalog', 'information_schema') 
  and table_type='BASE TABLE'
order by 
  table_schema,
  table_name,
  count desc