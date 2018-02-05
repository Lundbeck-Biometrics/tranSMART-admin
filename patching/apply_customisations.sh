#!/bin/bash

# Shell script that applies customisations to the public tranSMART code base
# The customisation can include:
#   (1) copying files 
#   (2) updating files
#   (3) changes to the database

REFERENCES_DIR=./references
CUSTOM_DIR=./customisations
if [ "$(uname)" == "Darwin" ]; then
    TMCORE_DIR=~/Documents/tranSMART/transmart-core
elif [ "$(uname)" == "Linux" ]; then
    TMCORE_DIR=/datastore/transmart-core
fi

echo "COPYING FILES"

echo "################################################################################"
echo "### Copy TMService helper script"
echo "################################################################################"

src_file="$CUSTOM_DIR/TMService.sh"
dst_file="$TMCORE_DIR/TMService.sh"

if [ ! -f $dst_file ]; then
    echo "$dst_file not found. Will copy now."
    cp $src_file $dst_file
    echo "DONE! Added $dst_file"
else
    echo "$dst_file already exists. Checking for differences."
    if [[ $(diff $src_file $dst_file | wc -l) -ne 0 ]]; then
        echo "File is different. Overwrite?"
        read -n 1 -p "Overwrite? (Y/N):" overwrite_file
        echo ""
        if [ "$overwrite_file" = "Y" ]; then
            cp $src_file $dst_file 
            echo "DONE! Updated $dst_file"
        else
            echo "Ok. Will not copy."
        fi
    else
        echo "Files identical. Will not copy."
    fi
fi


echo "UPDATING EXISTING TRANSMART FILES"

echo "################################################################################"
echo "### Apply customisation on GWAS analysis metadata available in interface"
echo "################################################################################"

reference_file="$REFERENCES_DIR/_analysisdetail.gsp"
repo_file="$TMCORE_DIR/transmartApp/grails-app/views/trial/_analysisdetail.gsp"
custom_file="$CUSTOM_DIR/_analysisdetail.gsp"

if [[ $(diff $reference_file $repo_file | wc -l) -ne 0 ]]; then
    echo "Conflict between our reference and file in repo folder (can be due to changes to repo or the patch is already applied)"
    diff $reference_file $repo_file
    overwrite_file=""
    read -n 1 -p "Overwrite with customisation? (Y/N):" overwrite_file
    echo ""
    if [ "$overwrite_file" = "Y" ]; then
        cp $custom_file $repo_file 
        echo "DONE! Updated $repo_file"
    else
        echo "Ok. Will not copy."
    fi
else
    echo "Customisation can be applied"
    cp $custom_file $repo_file
    echo "DONE! Customisation for file $repo_file applied"
fi

echo "################################################################################"
echo "### Enabling GWAVA to allow for ManhattanPlots and QQPlots in GWAS module"
echo "################################################################################"

target_file="$TMCORE_DIR/transmart-data/config/Config-template.groovy"
#target_file="~/.grails/transmartConfig/Config.groovy"

if grep -Fq "gwavaEnabled = false" $target_file; then
    echo "Gwava is disabled in Config file $target_file. Enabling..."
    if [ "$(uname)" == "Darwin" ]; then
        sed -i '' -e 's/org.transmartproject.app.gwavaEnabled = false/org.transmartproject.app.gwavaEnabled = true/' $target_file
    elif [ "$(uname)" == "Linux" ]; then
        sed -i 's/org.transmartproject.app.gwavaEnabled = false/org.transmartproject.app.gwavaEnabled = true/' $target_file
    fi
    echo "DONE! Enabled GWAVA in file $target_file"
else
    if grep -Fq "gwavaEnabled = true" $target_file; then
        echo "Gwava is already enabled in file $target_file"
    else
        echo "Can't find config for GWAVA in file $target_file"
    fi
fi

# echo "APPLY CHANGES TO DATABASE"

# TO-DO: apply database customisations, like allowing for multiple dbSNP versions, and adding the monitoring schema

echo ""
echo "### DONE ###"
