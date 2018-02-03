#!/bin/bash

REFERENCES_DIR=./references
CUSTOM_DIR=./customisations
TMCORE_DIR=~/Documents/tranSMART/transmart-core

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

# TO-DO: apply database customisations, like allowing for multiple dbSNP versions

echo ""
echo "### DONE ###"
