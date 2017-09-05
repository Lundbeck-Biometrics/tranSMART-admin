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


### Move `scripts` folder to `/datastore`
