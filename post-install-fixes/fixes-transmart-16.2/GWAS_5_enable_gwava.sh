# Issue: an error occurs when trying to see the QQPlot on loaded data in the GWAS module, complaining about the path
# Solution: Enable gwava and check that we have the expected folders

cd /usr/share/tomcat7/.grails/transmartConfig
nano Config.groovy
# edit the value of the gwavaEnabled property from false to true if not already set

cd /var/tmp/jobs
ls
# check that we have the following folders: cachedQQplotImages and cachedManhattanplotImages
