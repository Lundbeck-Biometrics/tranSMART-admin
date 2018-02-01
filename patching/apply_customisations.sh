#!/bin/bash

REFERENCES_DIR=./references
CUSTOM_DIR=./customisations
TMCORE_DIR=~/Documents/tranSMART/transmart-core

echo "################################################################################"
echo "### Apply customisation on GWAS analysis metadata available in interface    ### "
echo "################################################################################"

reference_file="$REFERENCES_DIR/_analysisdetail.gsp"
repo_file="$TMCORE_DIR/transmartApp/grails-app/views/trial/_analysisdetail.gsp"
custom_file="$CUSTOM_DIR/_analysisdetail.gsp"

if [[ $(diff $reference_file $repo_file | wc -l) -ne 0 ]]; then
    echo "Conflict between our reference and file in repo folder (can be due to changes to repo or the patch is already applied)"
    diff $reference_file $repo_file
else
    echo "Customisation can be applied"
    cp $custom_file $repo_file
    echo "DONE! Customisation for file $repo_file applied"
fi

# TO-DO: apply database customisations, like allowing for multiple dbSNP versions

echo ""
echo "### DONE ###"
