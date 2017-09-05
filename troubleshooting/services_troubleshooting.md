## Guide for troubleshooting

### Search is not working 

Check if Solr search is running and restart if it is not. 
This is documented in the installation page: https://wiki.transmartfoundation.org/display/transmartwiki/Install+the+current+official+release#Installthecurrentofficialrelease-running-toolsRunningSOLR,Rserve,andTomcat 

```
ps aux | grep start.jar
cd ~/transmart/transmart-data
. ./vars
nohup make -C solr start > ~/transmart/transmart-data/solr.log 2>&1 &
```

### R is not working

Issue with running advanced workflows - getting SIGPIPE error, after “Gathering high dimensional data” step.  Or timeout when running a workflow.

Restart Rserve using: 

```
cd ~/transmart/transmart-data 
sudo -u tomcat7 bash -c 'source vars; make -C R start_Rserve'  
```

### The web application is not responsive (keeps loading)

Restart tomcat:

```
sudo service tomcat7 restart
```
