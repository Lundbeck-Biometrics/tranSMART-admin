# Guide for installing tranSMART 17.1 (2017) on a Ubuntu 14.04 server

This guide describes how to install the tranSMART platform on an Ubuntu 14.04 server with a storage drive mounted as `/datastore`.  

The guide follows the publicly available installation instructions (https://github.com/thehyve/transmart-core).

## Setup before installing

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
Set paths in /etc/environment: 

`JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64`

Add the jdk path to `PATH` as well 

`source /etc/environment`

### Install Gradle using Sdkman

```
curl -s https://get.sdkman.io | bash
sdk version
sdk use gradle 2.13
```

To check which gradle is used, type in `sdk list gradle` (http://sdkman.io/usage.html).

### Set up a transmart account

```
sudo adduser transmart
sudo adduser transmart sudo
  
# log out and log back in with your new user
```

### Get the source code

```
cd /datastore
git clone https://github.com/thehyve/transmart-core
```

Update permissions on that folder (below is a bit dangerous but seems to be needed, at least partially, for building the project):

`chmod -R 0777 transmart-core`


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
sudo make -C env ubuntu_deps_root
make -C env ubuntu_deps_regular

sudo su postgres
. ./vars
make postgres_drop
make -j4 postgres
```

TO-DO: continue with instructions from transmart-data and then from the transmart-core repo instructions
