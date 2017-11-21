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

If Java 7 is already installed, install Java 8, and choose the right version using the update-alternatives commands below.

```
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
sudo update-alternatives --config java
sudo update-alternatives --config javac
```

If not installed, can just install by:

```
sudo apt-get install openjdk-8-jdk
```

TO-DO: decide which Java version we are using???

Set paths in /etc/environment: 

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
If the setting of which gradle is to be used fails with the sdk use command, then 

### Get the source code

```
cd /datastore
sudo apt-get install git
sudo git clone https://github.com/thehyve/transmart-core
sudo chown transmart:transmart transmart-core/ -R
```

## Installation

### Build the `transmart.war` app:

```
cd /datastore/transmart-core
gradle :transmart-server:bootRepackage
```

If encountering errors, check the version of gradle that is being used.

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

# Update dependency check for php
nano /datastore/transmart-core/transmart-data/env/Makefile
# Remove php5-cli and php5-json from dependency check

sudo make -C env ubuntu_deps_root
make -C env ubuntu_deps_regular

sudo su postgres
. ./vars
make postgres_drop
make -j4 postgres
```

If the last command fails at `ddl/postgres/i2b2demodata/study.sql`, then comment lines 51 and 52 from that file (the ones adding a constraint using `biomart`), and run the drop and postgres commands again.

### Install prerequisites

```
sudo apt-get install php
```

TO-DO: instructions for installation of tomcat

### Solr

```
cd /datastore/transmart-core/transmart-data
. ./vars
make -C solr start &
make -C solr browse_full_import rwg_full_import sample_full_import
```

Solr will then run at http://yourserverurl:8983/solr

### RServe

```
cd /datastore/transmart-core/transmart-data/R
make -C R -j8 root/bin/R
nano Makefile
# Update R_MIRROR from https to http
make -C R install_packages
sudo TRANSMART_USER=transmart make -C R install_rserve_init
```

### Install config files

```
nano vars
# Add TSUSER_HOME=$HOME/
# And add TSUSER_HOME to export statement
. ./vars
make -C config install
```

### Start transmart

```
java -jar transmart-server/build/libs/transmart-server-17.1-SNAPSHOT.war > log.txt &
```

TranSMART server will run at http://yourserverlurl:8080/
Go to that URL and log in.

#### Error after log in
Redirect takes us to http://localhost:8080/userLanding and Error is `localhost refused to connect`. Stop the process and update the transmart config file. Update `/home/transmart/.grails/transmartConfig/Config.groovy` with the actual `transmarturl` (instead of `localhost`):
```
cd /usr/share/tomcat7/.grails/transmartConfig
nano Config.groovy
# update the transmart url and save
```
Start the java app again and the login should work.

### Deploy transmart to tomcat

If the above app runs without problems, then we can now deploy the app to Tomcat.

```
cd /datastore/transmart-core/transmart-server/build/libs
sudo cp transmart-server-17.1-SNAPSHOT.war /var/lib/tomcat7/webapps/transmart.war
cd /var/lib/tomcat7/webapps
sudo chown tomcat7:tomcat7 transmart.war
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

Getting warnings in the tomcat catalina.out log like: `WARN org.transmart.server.Application - Configuration file /usr/share/tomcat7/.gails/transmartConfig/Config.groovy does not exist.`

Our configuration file is actually in `/home/transmart/.grails/transmartConfig/`

```
cd /usr/share/tomcat7
sudo ln -s /home/transmart/.grails/ .grails
```

## Test the REST-API

TO-DO: test the RESP API and apply the fix as from 16.2 if needed


## Post-install setup

TO-DO: move database location and R jobs output location
