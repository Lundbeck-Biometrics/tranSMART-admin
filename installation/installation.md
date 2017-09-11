# Guide for installing tranSMART on Ubuntu server

This guide describes how to install the tranSMART platform on an Ubuntu 14.04 server with a storage drive mounted as `/datastore`.  

The guide follows the publicly available installation instructions (https://wiki.transmartfoundation.org/display/transmartwiki/Install+the+current+official+release) but adds information on how to resolve issues in the 16.2 tranSMART release. 


## Setup before installing

### Check disk space

`df -h`

Additional storage should be mounted on `/datastore`. This is the drive that will be used for most of the tranSMART activities.

Files used for the installation: http://library.transmartfoundation.org/release/release16_2_0.html  

### Install java jdk: 

`sudo apt-get install openjdk-7-jdk`

Set paths in /etc/environment: 

`JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64`

Add the path to `PATH` as well 

### Set up a transmart account

As described by the install guide:

```
# set the password for your new user 'transmart'
# use defaults for the other values if you wish
sudo adduser transmart
 
# add the user transmart to the sudo group
sudo adduser transmart sudo
  
# log out and log back in with your new user
```

### Download the install scripts

As described by the install guide, we need to download the install scripts. But instead of downloading in the home directory of the transmart account, we will download in `/datastore`.

`cd /datastore`

And then:

```
sudo apt-get install -y curl
sudo apt-get install -y unzip
 
# download the installation script
curl http://library.transmartfoundation.org/release/release16_2_0_artifacts/Scripts-release-16.2.zip -o Scripts-release-16.2.zip
# unzip and rename the Scripts folder
unzip Scripts-release-16.2.zip
mv Scripts-release-16.2 Scripts
```

### Prepare `/datastore` for installation

Add symbolic links from `home/transmart` to `/datastore`, for folder `Scripts` and `transmart`. 

```
ln -s /datastore/Scripts /home/transmart/Scripts 
cd /datastore/transmart
mkdir transmart
ln -s /datastore/transmart /home/transmart/transmart 
```

Change ownership for folders on `/datastore`:

```
cd /datastore 
sudo chown -R transmart:transmart transmart 
```

## Run install script

Run install script, as described by the guide:

```
./Scripts/install-ubuntu/InstallTransmart.sh 2>&1 | tee ~/install.log 
```

If any issues occur, check the error message, fix the problem, and then run the script again.

### Known issue: QDNAseq R package URL

The script will download the transmart-data artifact, which includes some config scripts that will look for an R package that cannot be downloaded anymore. 

The `transmart-data/R/other_pkg.R` file needs to be updated to use version `1.12` of QDNAseq instead of `1.10`, so: http://bioconductor.org/packages/release/bioc/src/contrib/QDNAseq_1.10.0.tar.gz 

Rerun the install script after changing the version number for the R package.

(Issue is now already reported in the comments section of the Install page: https://wiki.transmartfoundation.org/display/transmartwiki/Install+the+current+official+release)

### Known issue: check on login page

The last step in the install script checks that all services are running, and one of the checks is that the tranSMART login web page is shown. However, the check is for a string that is not found. 

The `Scripts\install-ubuntu\checks\checkWeb.sh` script searches on the login page for "tranSMART" but actually it should be "Transmart".

If you see the login page if you go in the browser, then that part is okay, and it's only if you want to run the check again then you should change the string in the `checkWeb.sh` file. 

To rerun the checks:
```
cd Scripts/install-ubuntu/checks/
./checkAll.sh 2>&1 2>&1 | tee ~/checks.log
```

(Issue is now already reported in the transmart-discuss forum: https://groups.google.com/forum/#!topic/transmart-discuss/NrjkiCCVaWE)


## Setup post-install

### Warnings in tomcat log 

Getting warnings in tomcat log like this one:
`WARNING: Problem with directory [/usr/share/tomcat7/shared/classes], exists: [false], isDirectory: [false], canRead: [false]`

Issue described here: http://stackoverflow.com/questions/27337674/folder-issues-with-tomcat-7-on-ubuntu 

And the solution is to create symbolic links:
```
cd /usr/share/tomcat7
sudo ln -s /var/lib/tomcat7/common/ common
sudo ln -s /var/lib/tomcat7/server/ server
sudo ln -s /var/lib/tomcat7/shared/ shared
```

### Move database location

If loading more than the demo dataset, we have to move the location of the postgres data on the mounted `/datastore`, instead of the default `/var/lib/postgresql`. (This problem was identified while trying to load gene expression data and received an error in the kettle job with “No space left on device”).

Stop service:
```
sudo service postgresql stop
```

Create new folder for the postgres data and move existing data there:
```
cd /datastore
sudo mkdir postgresql
sudo chown postgres postgresql
sudo chmod 700 postgresql
sudo cp -aRv /var/lib/postgresql/. /datastore/postgresql/
sudo rm -r /var/lib/postgresql/
```

Checking space status (now things should look better in var):
```
sudo du -hs /var
df
```

Create the link:
```
sudo ln -s /datastore/postgresql /var/lib/postgresql
```

Start postgresql:
```
sudo service postgresql start
```

### Move R jobs location

Seems that every time an R job is run, a folder is created with the output. We have to move the jobs folder to datastore instead of the default location, otherwise the disk gets full fast. (This problem was identified when var ran out of space.)

Create a new folder for storing the output of the R jobs:

```
cd /datastore
sudo mkdir jobs
sudo chown tomcat7 jobs
```

Copy anything needed from `/var/tmp/jobs` to `/datastore/jobs`

Note: Copy `cachedQQPlotImages` and `cachedManhattanplotImages` to the new location.

Then remove the old folder and create a link to the new location:

```
sudo rm -r /var/tmp/jobs/
sudo ln -s /datastore/jobs /var/tmp/jobs
```

### REST API config

Issue identified when running into the following problem. When requesting the access token from the R Interface client in R studio, getting the following error:
`error="invalid_grant", error_description="Invalid redirect: http://hluu3100h.lundbeck.com:8080/transmart/oauth/verify does not match one of the registered values: [http://localhost:8080/transmart/oauth/verify]"`. Issue described here by another user: https://groups.google.com/forum/#!topic/transmart-discuss/iLoegUliWPI but the config files have been moved to another folder as described here https://wiki.transmartfoundation.org/display/transmartwiki/Install+the+current+official+release


Update `/usr/share/tomcat7/.grails/transmartConfig/Config.groovy` with the actual `transmarturl` (instead of `localhost`):

```
cd /usr/share/tomcat7/.grails/transmartConfig
nano Config.groovy
# update the transmart url and save
```

And then restart tomcat:

```
sudo service tomcat7 restart
```

### SmartR fix

In smartR heatmap preprocess task, getting: `Error: class org.rosuda.REngine.Rserve.RserveException: R command failure for: source('/tmp/smart_r_scripts/heatmap/preprocess.R'): Error in library(WGCNA) : there is no package called ‘WGCNA’`

Run R on the server by typing `R` in the shell and then install package:

```
install.packages(“WGCNA”)
```

### Additional fixes

Additional post-installation fixes are required in order to use tranSMART functionality. Check the post-install-fixes folder for instructions.
