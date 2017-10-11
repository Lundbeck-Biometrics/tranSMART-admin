# Guide for setting up an Ubuntu server dedicated to tranSMART data loading

This guide assumes that an Ubuntu 14.04 server is available, with a storage drive mounted as `/datastore`. 

From Windows you can use MobaXTerm for connecting to the server. 

## Installation

### Install Java JDK:

`sudo apt-get install openjdk-7-jdk`

Update paths:

`sudo nano /etc/environment`

The file should contain:
```
JAVA_HOME="/usr/lib/jvm/java-7-openjdk-amd64"
PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/usr/lib/jvm/java-7-openjdk-amd64"
```

Apply changes:

`source /etc/environment`

### Install Posgres client

```
sudo apt-get install postgresql-client
# The following command should show you which PostgreSQL version is installed
psql -V
# Install pgadmin for a PostgreSQL graphical administration tool
sudo apt-get install pgadmin3
```

### Install the Pentaho Data Integration software

```
wget https://downloads.sourceforge.net/project/pentaho/Data%20Integration/4.4.0-stable/pdi-ce-4.4.0-stable.zip?r=&ts=1507720665&use_mirror=netix
sudo unzip pdi-ce-4.4.0-stable.zip?r= -d /datastore/
cd /datastore/data-integration
chmod +x *.sh
```

### Install Git

`sudo apt-get install git`

## Configuration

### Get the tranSMART-ETL scripts

```
cd /datastore
sudo git clone https://github.com/Lundbeck-Biometrics/tranSMART-ETL.git
```

### Configure Kettle/Spoon

Start the Spoon interface

```
cd /datastore/data-integration
./spoon.sh
# This will open the graphical interface
# You can go to File > Open and then navigate to /datastore/tranSMART-ETL folder and choose a Kettle job
```

If the above works, close Spoon and then update the kettle properties file (by default found in ~/.kettle) with the tranSMART database info:

```
cd ~/.kettle
cp /datastore/tranSMART-ETL/Kettle/postgres/kettle.properties .
nano kettle.properties
# Check that the configuration coresponds to the setup, and update as needed
```

Run Spoon again and check that the values from the kettle.properties file are updated.

Move kettle.properties file to a shared place, otherwise the default location is a user's home folder, which would mean that each user would have to configure that file separately.

```
cd /datastore
sudo mkdir config
sudo cp -r ~/.kettle .
```

Add KETTLE_HOME to the system wide config file (affecting all users):

```
sudo nano /etc/environment
# Add KETTLE_HOME="/datastore/config" after JAVA_HOME
export KETTLE_HOME=/datastore/config
```

### Add database in pgAdmin

Connect to the tranSMART server database through a tunnel in another terminal session:

`ssh -L 9001:localhost:5432 transmart@transmartserver`

(Replace `transmartserver` with the actual server name or IP Address)

Then  open pgAdmin and create a new database connection

```
pgadmin3
# Use localhost, port 9001, with user tm_cz
```

## Data Loading

### Establish a database connection

Connect to the tranSMART server database through a tunnel in another terminal session

`ssh -L 9001:localhost:5432 transmart@transmartserver`

(Replace `transmartserver` with the actual server name or IP Address)

### Start Spoon

```
cd /datastore/data-integration
./spoon.sh
# This will open the graphical interface
# You can go to File > Open and then navigate to /datastore/tranSMART-ETL folder and choose a Kettle job
```

### Load data

TO-DO
