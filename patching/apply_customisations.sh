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

echo "################################################################################"
echo "### COPYING NEW FILES"
echo "################################################################################"

copy_files() {
    local src_file=$1
    local dst_file=$2
    if [ ! -f $dst_file ]; then
        echo "$dst_file not found. Will copy now."
        cp $src_file $dst_file
        echo "DONE! Added $dst_file"
    else
        echo "$dst_file already exists. "
        echo "Checking for differences."
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
}

echo "###"
echo "### Copy TMService helper script"
echo "###"

copy_files "$CUSTOM_DIR/TMService.sh" "$TMCORE_DIR/TMService.sh"

echo "###"
echo "### Copy transmart-batch database properties file"
echo "###"

copy_files "$CUSTOM_DIR/batchdb.properties" "$TMCORE_DIR/transmart-batch/batchdb.properties"

echo "###"
echo "### Copy transmart-data vars file"
echo "###"

copy_files "$CUSTOM_DIR/vars" "$TMCORE_DIR/transmart-data/vars"

echo "################################################################################"
echo "### UPDATING EXISTING TRANSMART FILES"
echo "################################################################################"

update_files() {
    local reference_file=$1
    local repo_file=$2
    local custom_file=$3
    local overwrite_file=""

    echo "Updating the file: $repo_file"

    if [[ $(diff $reference_file $repo_file | wc -l) -ne 0 ]]; then
        echo "Conflict between our reference and file in repo folder (can be due to changes to repo or the patch is already applied)"
        if [[ $(diff $custom_file $repo_file | wc -l) -ne 0 ]]; then
            echo "File is different from the reference file and from our patch"
            echo "Here's the difference from the reference file:"
            diff $reference_file $repo_file
            echo "Here's the difference from the patch file:"
            diff $custom_file $repo_file
            read -n 1 -p "Overwrite with customisation? (Y/N):" overwrite_file
            echo ""
            if [ "$overwrite_file" = "Y" ]; then
                cp $custom_file $repo_file 
                echo "DONE! Updated $repo_file"
            else
                echo "Ok. Will not copy."
            fi
        else
            echo "Patch seems to be already applied as file in repo is identical with the patch. Will not copy."
        fi
    else
        echo "Customisation can be applied"
        cp $custom_file $repo_file
        echo "DONE! Customisation for file $repo_file applied"
    fi
}

echo "###"
echo "### Apply customisation on GWAS analysis metadata available in interface"
echo "###"

update_files "$REFERENCES_DIR/_analysisdetail.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/trial/_analysisdetail.gsp" \
    "$CUSTOM_DIR/_analysisdetail.gsp"

echo "###"
echo "### Apply customisation on GWAS region search available in interface"
echo "###"

update_files "$REFERENCES_DIR/_regionFilter.gsp" \
    "$TMCORE_DIR/transmart-gwas-plugin/grails-app/views/GWAS/_regionFilter.gsp" \
    "$CUSTOM_DIR/_regionFilter.gsp"

echo "###"
echo "### Apply customisation on GWAS interface"
echo "###"

update_files "$REFERENCES_DIR/gwas_index.gsp" \
    "$TMCORE_DIR/transmart-gwas-plugin/grails-app/views/GWAS/index.gsp" \
    "$CUSTOM_DIR/gwas_index.gsp"

echo "###"
echo "### Apply customisation on GWAS data types available as filters in the interface"
echo "###"

update_files "$REFERENCES_DIR/GWASController.groovy" \
    "$TMCORE_DIR/transmart-gwas-plugin/grails-app/controllers/com/recomdata/grails/plugin/gwas/GWASController.groovy" \
    "$CUSTOM_DIR/GWASController.groovy"

echo "###"
echo "### Apply customisation of transmart-batch.sh script"
echo "###"

update_files "$REFERENCES_DIR/transmart-batch.sh" \
    "$TMCORE_DIR/transmart-batch/transmart-batch.sh" \
    "$CUSTOM_DIR/transmart-batch.sh"

echo "###"
echo "### Remove dependencies to outside domains"
echo "###"

update_files "$REFERENCES_DIR/_commonheader.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/layouts/_commonheader.gsp" \
    "$CUSTOM_DIR/_commonheader.gsp"

# TO-DO: add any GWAS fixes that havent been applied yet on the public repo

# echo "APPLY CHANGES TO DATABASE"

# TO-DO: apply database customisations, like adding the monitoring schema

echo ""
echo "### DONE ###"
