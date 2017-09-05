# Guide for installing tranSMART on Lundbeck Ubuntu server

This guide describes how to install the tranSMART platform on an Ubuntu server, and contains configuration specific to the setup of the server in Lundbeck.  

The guide follows the publicly available installation instructions (https://wiki.transmartfoundation.org/display/transmartwiki/Install+the+current+official+release) but adds information on how to resolve issues in the 16.2 tranSMART release. 


## Setup before installing

### Check disk space

`df -h`

Additional storage should be mounted on `/datastore`. This is the drive that will be used for most of the tranSMART activities.

Files used for the installation: http://library.transmartfoundation.org/release/release16_2_0.html 
(Also saved on the BiRWE drive: \BiRWE_Programs\tranSMART Release Artifacts Version 16.2) 

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
