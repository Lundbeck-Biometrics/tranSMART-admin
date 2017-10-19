# Guide for installing tranSMART 17.1 (2017) on Ubuntu server

This guide describes how to install the tranSMART platform on an Ubuntu 14.04 server with a storage drive mounted as `/datastore`.  

he guide follows the publicly available installation instructions (https://github.com/thehyve/transmart-core).

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


