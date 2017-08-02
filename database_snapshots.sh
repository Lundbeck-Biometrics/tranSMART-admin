#
# Commands that can be used for creating backups of the transmart database
# and restoring (if needed), or comparing changes.
# These commands can be useful when performing data loading activities.
#
# Just pick which ones you need and run. Don't run the sh script as is!
#
# PSQL documentation on backups:https://www.postgresql.org/docs/9.6/static/backup.html
#
# NOTE1: the restore commands have not yet been tested on our tranSMART instance (TODO)
#
# NOTE2: might be a good idea to stop running processes that use the database while working
# with creating dumps and restoring
# sudo service tomcat7 stop
# sudo service postgresql stop
# sudo service postgresql start
# sudo service tomcat7 start
#

# Login on the transmart server

# Go to where the database tables are stored and log in as postgres

cd /datastore/postgresql/tablespaces/
sudo su postgres

#################################################################################
# BACKUPS
#################################################################################


# Backup Method 1: Use compressed dumps

pg_dump -d transmart | gzip > transmart_version.sql.gz

# Restore for Backup Method 1
# Might need to clean up database first

gunzip -c transmart_version.sql.gz | psql -d transmart

# Backup Method 2: Use the custom dump format

pg_dump -Fc transmart > transmart_version.tar

# Restore for Backup Method 2

pg_restore --create --clean -d transmart_version.tar

#################################################################################
# DIFFS between database dumps (can be used to see what changed after a data load)
#################################################################################

pg_dump -d transmart > transmart_v1
pg_dump -d transmart > transmart_v2
diff transmart_v1 transmart_v2 > transmart_compare.txt

# Can then copy the diff file locally (for easier inspection)
# From your computer use scp, replacing transmartserver with the IP address of the server

scp transmart@transmartserver:/datastore/postgresql/tablespaces/transmart_compare.txt .

# Remove dumps if they are not needed, as they can occupy quite some space if a lot of data was loaded
