# Guide for installing tranSMART 17.1 (2017) on a Ubuntu 16.04 server

This guide describes how to install the tranSMART platform on an Ubuntu 16.04 server with a storage drive mounted as `/datastore`.  

The guide follows the publicly available installation instructions (https://github.com/thehyve/transmart-core).

## Setup before installing

### Set up a transmart account

```
sudo adduser transmart
sudo adduser transmart sudo
  
# log out and log back in with your new user
```

### Check disk space

`df -h`

Additional storage should be mounted on `/datastore`. This is the drive that will be used for most of the tranSMART activities.

### Install java jdk: 

Java 8 should be installed. 

```
sudo apt-get install openjdk-8-jdk
```

If Java 7 is already installed, install Java 8, and choose the right version using the update-alternatives commands below.

```
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

Set `JAVA_HOME` in /etc/environment: 

`JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64`

Add the jdk path to `PATH` as well

`source /etc/environment`

### Install Gradle using Sdkman

```
curl -s https://get.sdkman.io | bash
#Source path provided as output
sdk version
sdk use gradle 2.13
```

To check which gradle is used, type in `sdk list gradle` (http://sdkman.io/usage.html).

If the setting of which gradle is to be used fails with the sdk use command, then switch to another version that is not installed, and then switch back to correct version of 2.13. 

### Get the source code

```
cd /datastore
sudo apt-get install git
sudo mkdir transmart-core
sudo chown transmart:transmart transmart-core/ -R
git clone https://github.com/thehyve/transmart-core transmart-core
```

## Installation

### Set up the database (transmart-data)

```
cd /datastore/transmart-core/transmart-data

# Installation of php5 on Ubuntu 16.04
sudo apt-get purge `dpkg -l | grep php| awk '{print $2}' |tr "\n" " "`
sudo add-apt-repository ppa:ondrej/php
sudo add-apt-repository ppa:ondrej/apache2
sudo apt-get update
sudo apt-get install php5.6
# Check installation
php -v

# Update dependency checks
nano /datastore/transmart-core/transmart-data/env/Makefile
# Remove php5-cli and php5-json from dependency check
# Replace java 7 with java 8

sudo make -C env ubuntu_deps_root
make -C env ubuntu_deps_regular

. ./vars
make postgres_drop
make -j4 postgres
```

If the last command fails at `ddl/postgres/i2b2demodata/study.sql`, then comment lines 51 and 52 from that file (the ones adding a constraint using `biomart`), and run the drop and postgres commands again.


### Move database location

If loading more than the demo dataset, we have to move the location of the postgres data on the mounted `/datastore`, instead of the default `/var/lib/postgresql`.

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

### Move R jobs output location

Every time an R job is run, a folder is created with the output. We have to move the jobs folder to datastore instead of the default location, otherwise the disk gets full fast.

Create a new folder for storing the output of the R jobs:

```
cd /datastore
sudo mkdir jobs
sudo chown transmart:transmart jobs
```

Copy anything needed from /var/tmp/jobs to /datastore/jobs. Or everything, like this:

```
cp -r /var/tmp/jobs/* /datastore/jobs/
```

Then remove the old folder and create a link to the new location:

```
sudo rm -r /var/tmp/jobs/
sudo ln -s /datastore/jobs /var/tmp/jobs
```

### Solr

```
cd /datastore/transmart-core/transmart-data
. ./vars
make -C solr start &
make -C solr browse_full_import rwg_full_import sample_full_import
```

Solr will then run at `http://serverurl:8983/solr`

### RServe

Install (this will take a while):

```
sudo apt-get install r-base-core
cd /datastore/transmart-core/transmart-data
. ./vars
make -C R -j8 root/bin/R
nano R/Makefile
# Update R_MIRROR from https to http
make -C R install_packages
```

Run:

```
sudo su
. ./vars
TRANSMART_USER=tomcat7 make -C R install_rserve_init
update-rc.d rserve defaults 85 # to enable the service
exit
```

### Install Tomcat (if using tomcat for deployment)

```
# Install tomcat7 by using the command:
sudo apt-get install tomcat7
# Modify config for tomcat7:
sudo nano /etc/default/tomcat7
# Modify line containing JAVA_HOME to the installed JAVA version if you have multiple java versions. Use JAVA 8.
# Modify line containing JAVA_OPTS to include -Xms512m -Xmx2g (issue described here: https://wiki.transmartfoundation.org/pages/viewpage.action?pageId=9535811)
# Restart tomcat7:
sudo service tomcat7 restart
```

Check that it works: `http://serverurl:8080/`

### Install config files

If using tomcat for deployment:

```
cd /datastore/transmart-core/transmart-data
nano vars
# Add TSUSER_HOME=/usr/share/tomcat7/
# And add TSUSER_HOME to export statement
sudo su
. ./vars
make -C config install
exit
```

Otherwise no need to set the user. The config will be copied to transmart's user home folder:

```
cd /datastore/transmart-core/transmart-data
sudo su
. ./vars
make -C config install
exit
```

### Update config file

Enable GWAVA in order to have allow the GWAS module to create QQPlots and ManhattanPlots:

```
nano ~/.grails/transmartConfig/Config.groovy
# Set: org.transmartproject.app.gwavaEnabled = true
```

(or is using deployment on tomcat: `/usr/share/tomcat7/.grails/transmartConfig/Config.groovy`)

### Build the `transmart.war` app:

Ensure that you are using Java 8 (switch JAVA_HOME if needed).
Use correct version of gradle with sdkman.

```
cd /datastore/transmart-core
gradle :transmart-server:bootRepackage
```

If encountering errors, check the version of gradle that is being used.

### Start transmart with java -jar

```
java -jar transmart-server/build/libs/transmart-server-17.1-SNAPSHOT.war > log.txt &
```

TranSMART server will run at `http://serverlurl:8080/`
Go to that URL and log in.


## (OPTIONAL) Deploy transmart.war to Tomcat

### Build for deployment to tomcat

```
cd /datastore/transmart-core
gradle :transmart-server:war
```

### Deploy transmart to tomcat

```
cd /datastore/transmart-core/transmart-server/build/libs
sudo cp transmart-server-17.1-SNAPSHOT.war /var/lib/tomcat7/webapps/transmart.war
cd /var/lib/tomcat7/webapps
# If tomcat is not already running:
sudo service tomcat7 start
```

#### Issues with deploying

Getting warnings in tomcat log like this one: WARNING: Problem with directory [/usr/share/tomcat7/shared/classes], exists: [false], isDirectory: [false], canRead: [false]

Issue described here: http://stackoverflow.com/questions/27337674/folder-issues-with-tomcat-7-on-ubuntu

And the solution is to create symbolic links:

```
cd /usr/share/tomcat7
sudo ln -s /var/lib/tomcat7/common/ common
sudo ln -s /var/lib/tomcat7/server/ server
sudo ln -s /var/lib/tomcat7/shared/ shared
```

#### Setting up config files

If getting warnings in the tomcat catalina.out log like: `WARN org.transmart.server.Application - Configuration file /usr/share/tomcat7/.grails/transmartConfig/Config.groovy does not exist.` note that the configuration files might instead be in `/home/transmart/.grails/transmartConfig/`

Rerun the `Install config files` step with the correct `TSUSER_HOME` variable and ensure correct access to the user that will run the transmart application.

```
cd /usr/share/tomcat7
chown -R tomcat7:tomcat7 .grails
```

#### Error after log in

This error can occur if you are not accessing transmart from same machine it is installed. Redirect takes us to http://localhost:8080/userLanding and Error is `localhost refused to connect`. Stop the process and update the transmart config file. Update `.grails/transmartConfig/Config.groovy` with the actual `transmarturl` (instead of `localhost`):
```
cd /usr/share/tomcat7/.grails/transmartConfig
nano Config.groovy
# update the transmart url and save
```
Start the app again and the login should work.

#### Error with build folder

Error in catalina.out that it cannot find some cache file under the `build` folder in path `/var/lib/tomcat7`.

```
cd /var/lib/tomcat7
sudo mkdir build
sudo chown tomcat7:tomcat7 build
```

Error dissapeared after creating the folder.


## Test the REST-API

TO-DO: test the RESP API and apply the fix as from 16.2 if needed


## Notes on tranSMART Deployment 

### Deploying tranSMART with JAVA 

#### Checking whether tranSMART is already running
Before deploying the tranSMART build with JAVA, please make sure to check whether tranSMART is already deployed and therefore running. Use the following command in the shell to test: 

````
ps aux | grep java
````

If tranSMART is running you should see a line similar to the one below: 

````
transma+ 28374 11.2 10.2 18758936 5052564 pts/9 Sl  12:29   3:31 java -jar transmart-server/build/libs/transmart-server-17.1-SNAPSHOT.war
````
The natural number displayed in the second column from the left is the process ID, which is of interest if you should wish to kill/terminate the tranSMART application.

#### Killing/terminating tranSMART deployed with JAVA
Killing the tranSMART application, i.e. ending deployment, can be achieved by: 

````
kill [process ID]
````

#### Initiating deployment of tranSMART with JAVA
TODO: Describe the .sh script for starting tranSMART with JAVA


## Data Loading

To load with transmart-batch:

```
cd /datastore/transmart-core/transmart-batch
nano batchdb.properties
```

Add:
```
batch.jdbc.driver=org.postgresql.Driver
batch.jdbc.url=jdbc:postgresql://localhost:5432/transmart
batch.jdbc.user=tm_cz
batch.jdbc.password=tm_cz
```

Build (this will generate a .jar file in `transmart-batch/build/libs/`):
```
gradle shadowJar
```

Transmart-batch is now ready to use (using transmart-batch.sh and corresponding params). 
Check the data loading instructions.

Note: Before you load GWAS data, ensure that you have first loaded the SNP info dictionary. That is done by a separate data loading component, for which Apache Maven is required, so better install that as well:

```
sudo apt-get install maven
```
