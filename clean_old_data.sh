# Might be a good idea to delete the old output R job analyses from time to time
# TODO: Consider creating a cron task for this

# To check how much space they occupy at the moment:
du -hs /datastore/jobs

# To remove all jobs
cd /datastore/jobs
sudo rm -r *

# TODO: example of removing the oldest jobs only
