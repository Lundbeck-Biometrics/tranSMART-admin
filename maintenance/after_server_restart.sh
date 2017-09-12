# After server restart we should check that the following services are running and start them if they are not
# Based on instructions here: https://wiki.transmartfoundation.org/display/transmartwiki/Install+the+current+official+release#Installthecurrentofficialrelease-running-toolsRunningSOLR,Rserve,andTomcat

# Check to see that SOLR is running with:
ps aux | grep start.jar
# If it is not found, start it with:
cd ~/transmart/transmart-data
. ./vars 
nohup make -C solr start > ~/transmart/transmart-data/solr.log 2>&1 & 

# Check to see that Rserve is running with:
ps aux | grep Rserve
# If it is not found, start it with:
cd ~/transmart/transmart-data
sudo -u tomcat7 bash -c 'source vars; make -C R start_Rserve' 

# Check to see that Tomcat7 is running with:
sudo service tomcat7 status
# If is is running, restart it with:
sudo service tomcat7 restart
# If is is not running, start it with:
sudo service tomcat7 start

# Go to the transmart web app and check that login works
# Click on the GWAS tab - this will check if Solr is running
# Run an advanced workflow to test that Rserve is working
