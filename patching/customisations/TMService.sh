#!/bin/bash

# Shell script that allows for starting, stopping, and querying the status
# of the tranSMART web-application deployment

# Getting status on all TM services
solrid=$(ps -eo pid,command | grep start.jar | grep -v grep | awk '{print $1}')
rserveid=$(ps -eo pid,command | grep Rserve | grep -v grep | awk '{print $1}')
transmartid=$(ps -eo pid,command | grep transmart-server-17.1-SNAPSHOT.war | grep -v grep | awk '{print $1}')

# If no arguments are passed then you get the status on all tranSMART services
if (($# == 0)); then

 if ((test -n "$solrid") || (test -n "$rserveid") || (test -n "$transmartid")); then
  echo ""
  echo "[INFO] Some tranSMART services are running (listed below):"
  echo ""

  if test -n "$solrid"; then
   echo "SOLR [OK]"
  fi

  if test -n "$rserveid"; then
   echo "RSERVE [OK]"
  fi

  if test -n "$transmartid"; then
   echo "TRANSMART [OK]"
  fi

  else
   echo ""
   echo "[INFO] No tranSMART services are running. Bye!"
  fi
 echo ""

fi

# if passing 1 or more than 2 arguments
if (($# == 1 | $# > 2)); then

 echo ""
 echo "ERROR: Either no or two arguments [SERVICES] and [SERVICE_COMMAND] must be passed!"
 echo ""
 echo "INFO: [SERVICES]        <solr|rserve|transmart>"
 echo "INFO: [SERVICE_COMMAND] <start|stop>"
 echo ""
 exit 1
fi

if (($# == 2)); then

 # Next check will be on whether the arguments are valid!
 srvc=$1
 srvcmd=$2

 # Check whether the passed SERVICES is correct
 case $srvc in
  ("solr"|"rserve"|"transmart")

  # Check whether the passed SERVICE command is correct
  case $srvcmd in
   ("start"|"stop")

   # CASE: SOLR - BEGIN
   case $srvc in
    "solr")

     case $srvcmd in
      "start")
      echo ""
      echo "[INFO]Attempting to start solr..."
      # Check whether solr is already running
      if (test -n "$solrid"); then
       echo "[INFO] Solr is already running. Will not restart service. Bye!"
      else
       cd transmart-data/
       {
       . ./vars
       make -C solr start &
       } >/dev/null
       cd ..
       echo ""
       echo "[INFO] PRESS ANY KEY TO RETURN TO PROMPT"
       echo ""
      fi
      ;;
      "stop")
      echo ""
      echo "[INFO] Attempting to stop solr..."
      echo ""
      # Check whether solr is running
      if (test -n "$solrid"); then
       echo "[INFO] Solr is currently running. Processid is $solrid."
       kill $solrid
       echo "[INFO] Solr is stopped. Bye!"
       echo ""
      else
       echo ""
       echo "[INFO] Solr is not currently running. Bye!"
       echo ""
      fi
      ;;
     esac
     ;; # CASE: SOLR - END

     # CASE: RSERVE - BEGIN
    "rserve")
     case $srvcmd in
      "start")
      echo ""
      echo "[INFO] Attempting to start Rserve..."
      # Check whether Rserve is already running
      if (test -n "$rserveid"); then
       echo ""
       echo "[INFO] Rserve is already running. Will not restart service. Bye!"
      else
       /datastore/transmart-core/transmart-data/R/root/bin/R CMD Rserve --no-save &
      fi
      ;;
      "stop")
      echo ""
      echo "[INFO] Attempting to stop Rserve..."
      # Check whether Rserve is running
      if (test -n "$rserveid"); then
       echo "[INFO] Rserve is currently running. Processid is $rserveid."
       kill $rserveid
       echo "[INFO] Rserve is stopped. Bye!"
       echo ""
      else
       echo ""
       echo "[INFO] Rserve is not currently running. Bye!"
       echo ""
      fi
      ;;
     esac
     ;; # CASE: RSERVE - END

    # CASE: TRANSMART - BEGIN
    "transmart")
     case $srvcmd in
      "start")
      echo ""
      echo "[INFO] Attempting to start tranSMART web application..."
      # Check whether tranSMART is already running
      if (test -n "$transmartid"); then
       echo ""
       echo "[INFO] tranSMART web application is already running. Will not restart service. Bye!"
      else
       java -jar transmart-server/build/libs/transmart-server-17.1-SNAPSHOT.war &
      fi
      ;;
      "stop")
      echo ""
      echo "[INFO] Attempting to stop tranSMART web application..."
      # Check whether tranSMART is running
      if (test -n "$transmartid"); then
       echo "[INFO] tranSMART web application is currently running. Processid is $transmartid."
       kill $transmartid
       echo "[INFO] tranSMART web application is stopped. Bye!"
       echo ""
      else
       echo ""
       echo "[INFO] tranSMART web application is not currently running. Bye!"
       echo ""
      fi
      ;;
     esac
     ;; # CASE: TRANSMART - END
     *)
     echo "[WARNING:] Should not be possible!"
     exit 2
     ;;
   esac
   ;;
   *)
   echo "SERVICE_COMMAND value is not valid. Must be start or stop. Bye!"
   exit 2
   ;;
  esac
  ;;
  *)
  echo "SERVICES value is not valid. Must be solr, rserve, or transmart. Bye!"
  exit 2
  ;;
 esac
fi
