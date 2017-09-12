# Might be a good idea to delete the old output R job analyses from time to time

# To check how much space they occupy at the moment:
du -hs /datastore/jobs

# To remove all jobs
cd /datastore/jobs
# sudo rm -r *

# TODO: the above will remove everything from the folder, but we actually don't 
# want to remove the cachedQQPlotImages and cachedManhattanplotImages folders 
# as they will not automatically be created and are needed for the GWAS module

# TODO: example of removing the oldest jobs only

# TODO: Consider creating a cron task for this
