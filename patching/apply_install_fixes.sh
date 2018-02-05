#!/bin/bash

# Shell script that applies fixes to the installation of the public tranSMART code base

REFERENCES_DIR=./references
CUSTOM_DIR=./customisations
if [ "$(uname)" == "Darwin" ]; then
    TMCORE_DIR=~/Documents/tranSMART/transmart-core
elif [ "$(uname)" == "Linux" ]; then
    TMCORE_DIR=/datastore/transmart-core
fi

echo "################################################################################"
echo "### UPDATING EXISTING TRANSMART FILES"
echo "################################################################################"

update_files() {
    local reference_file=$1
    local repo_file=$2
    local custom_file=$3
    local overwrite_file=""
    echo "Fixing the installation file: $repo_file"
    if [[ $(diff $reference_file $repo_file | wc -l) -ne 0 ]]; then
        echo "Conflict between our reference and file in repo folder (can be due to changes to repo or the patch is already applied)"
        diff $reference_file $repo_file
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

}

update_files "$REFERENCES_DIR/transmart-data_env_Makefile" \
    "$TMCORE_DIR/transmart-data/env/Makefile" \
    "$CUSTOM_DIR/transmart-data_env_Makefile"

update_files "$REFERENCES_DIR/transmart-data_ddl_postgres_i2b2demodata_study.sql" \
    "$TMCORE_DIR/transmart-data/ddl/postgres/i2b2demodata/study.sql" \
    "$CUSTOM_DIR/transmart-data_ddl_postgres_i2b2demodata_study.sql"

update_files "$REFERENCES_DIR/transmart-data_R_Makefile" \
    "$TMCORE_DIR/transmart-data/R/Makefile" \
    "$CUSTOM_DIR/transmart-data_R_Makefile"

echo ""
echo "### DONE ###"
