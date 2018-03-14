#!/bin/bash

# Shell script that applies customisations to the public tranSMART code base
# The customisation can include:
#   (1) copying files 
#   (2) updating files
#   (3) changes to the database

REFERENCES_DIR=./references
CUSTOM_DIR=./customisations
DBPORT=5432
if [ "$(uname)" == "Darwin" ]; then
    # Mac env
    TMCORE_DIR=~/Documents/tranSMART/transmart-core
elif [ "$(uname)" == "Linux" ]; then
    # Ubuntu env
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

echo "###"
echo "### Copy Lundbeck stylesheet"
echo "###"

copy_files "$CUSTOM_DIR/lundbeck.css" "$TMCORE_DIR/transmartApp/grails-app/assets/stylesheets/lundbeck.css"

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
echo "### Apply fix for bug in GWAS Search Controller not being able to show the items over the first 500 immediately"
echo "### (Pull request created to main repo with branch gwas_performance_postgreSQL_fix)"
echo "###"

update_files "$REFERENCES_DIR/GwasSearchController.groovy" \
    "$TMCORE_DIR/transmart-gwas-plugin/grails-app/controllers/com/recomdata/grails/plugin/gwas/GwasSearchController.groovy" \
    "$CUSTOM_DIR/GwasSearchController.groovy"

echo "###"
echo "### Apply fix for mad Oracle pagination in GWAS Region Search Service"
echo "### (Pull request created to main repo with branch gwas_performance_postgreSQL_fix)"
echo "###"

update_files "$REFERENCES_DIR/RegionSearchService.groovy" \
    "$TMCORE_DIR/transmart-gwas-plugin/grails-app/services/com/recomdata/grails/plugin/gwas/RegionSearchService.groovy" \
    "$CUSTOM_DIR/RegionSearchService.groovy"

echo "###"
echo "### Apply customisation on Browse interface"
echo "###"

update_files "$REFERENCES_DIR/rwg_index.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/RWG/index.gsp" \
    "$CUSTOM_DIR/rwg_index.gsp"

echo "###"
echo "### Apply customisation on Admin interface"
echo "###"

update_files "$REFERENCES_DIR/admin.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/layouts/admin.gsp" \
    "$CUSTOM_DIR/admin.gsp"

echo "###"
echo "### Apply customisation on Login interface"
echo "###"

update_files "$REFERENCES_DIR/login_main.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/layouts/main.gsp" \
    "$CUSTOM_DIR/login_main.gsp"

echo "###"
echo "### Apply customisation on Utilities menu"
echo "###"

update_files "$REFERENCES_DIR/_utilitiesMenu.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/layouts/_utilitiesMenu.gsp" \
    "$CUSTOM_DIR/_utilitiesMenu.gsp"

echo "###"
echo "### Apply customisation on Gene Signature/List interfaces"
echo "###"

update_files "$REFERENCES_DIR/genesig_list.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/geneSignature/list.gsp" \
    "$CUSTOM_DIR/genesig_list.gsp"

echo "###"
echo "### Apply customisation on Welcome message in Browse tab"
echo "###"

update_files "$REFERENCES_DIR/_welcome.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/RWG/_welcome.gsp" \
    "$CUSTOM_DIR/_welcome.gsp"

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

echo "###"
echo "### Apply customization for GWAS metadata"
echo "### (branch gwas_metadata_customization)"
echo "###"

update_files "$REFERENCES_DIR/BioAssayAnalysisExt.groovy" \
    "$TMCORE_DIR/biomart-domain/grails-app/domain/org/transmart/biomart/BioAssayAnalysisExt.groovy" \
    "$CUSTOM_DIR/BioAssayAnalysisExt.groovy"

update_files "$REFERENCES_DIR/BioAssayAnalysisDAO.groovy" \
    "$TMCORE_DIR/transmart-batch/src/main/groovy/org/transmartproject/batch/biodata/BioAssayAnalysisDAO.groovy" \
    "$CUSTOM_DIR/BioAssayAnalysisDAO.groovy"

update_files "$REFERENCES_DIR/BioExperimentDAO.groovy" \
    "$TMCORE_DIR/transmart-batch/src/main/groovy/org/transmartproject/batch/biodata/BioExperimentDAO.groovy" \
    "$CUSTOM_DIR/BioExperimentDAO.groovy"

update_files "$REFERENCES_DIR/UpdateGwasTop500Tasklet.groovy" \
    "$TMCORE_DIR/transmart-batch/src/main/groovy/org/transmartproject/batch/gwas/analysisdata/UpdateGwasTop500Tasklet.groovy" \
    "$CUSTOM_DIR/UpdateGwasTop500Tasklet.groovy"

update_files "$REFERENCES_DIR/GwasMetadataEntry.groovy" \
    "$TMCORE_DIR/transmart-batch/src/main/groovy/org/transmartproject/batch/gwas/metadata/GwasMetadataEntry.groovy" \
    "$CUSTOM_DIR/GwasMetadataEntry.groovy"

echo "###"
echo "### Apply customisation on GWAS analysis metadata available in interface"
echo "### (branch gwas_metadata_customization)"
echo "###"

update_files "$REFERENCES_DIR/_analysisdetail.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/trial/_analysisdetail.gsp" \
    "$CUSTOM_DIR/_analysisdetail.gsp"

echo "###"
echo "### Apply customisation on GWAS interface to remove link to metadata popup from GWAS study level"
echo "### (branch gwas_metadata_customization)"
echo "###"

update_files "$REFERENCES_DIR/_experiments.gsp" \
    "$TMCORE_DIR/transmart-gwas-plugin/grails-app/views/GWAS/_experiments.gsp" \
    "$CUSTOM_DIR/_experiments.gsp"

# TO-DO: add any GWAS fixes that havent been applied yet on the public repo

# TO-DO: apply changes for including the Lundbeck stylesheet

echo "###"
echo "### Include Lundbeck styling"
echo "###"

update_files "$REFERENCES_DIR/browseTab.css" \
    "$TMCORE_DIR/transmartApp/grails-app/assets/stylesheets/browseTab.css" \
    "$CUSTOM_DIR/browseTab.css"

update_files "$REFERENCES_DIR/analysetab.css" \
    "$TMCORE_DIR/transmartApp/grails-app/assets/stylesheets/analysetab.css" \
    "$CUSTOM_DIR/analysetab.css"

update_files "$REFERENCES_DIR/admintab.css" \
    "$TMCORE_DIR/transmartApp/grails-app/assets/stylesheets/admintab.css" \
    "$CUSTOM_DIR/admintab.css"

update_files "$REFERENCES_DIR/genesigmain.gsp" \
    "$TMCORE_DIR/transmartApp/grails-app/views/layouts/genesigmain.gsp" \
    "$CUSTOM_DIR/genesigmain.gsp"

echo "################################################################################"
echo "### COPY IMAGES"
echo "################################################################################"

#cp "$CUSTOM_DIR/lutransmartlogo.png" "$TMCORE_DIR/transmartApp/grails-app/assets/images/lutransmartlogo.png"
cp "$CUSTOM_DIR/provider_logo.png" "$TMCORE_DIR/transmartApp/grails-app/assets/images/provider_logo.png"

echo "################################################################################"
echo "### APPLY CHANGES TO DATABASE"
echo "################################################################################"

echo "###"
echo "### Disable default users that are not needed"
echo "###"

# Will not check if the users are already disabled since the execution will not fail
# but will let the user decide if we should go through this process

disable_users=""
read -n 1 -p "Disable default users? (Y/N):" disable_users
if [ "$disable_users" = "Y" ]; then
    psql -U tm_cz -d transmart -h localhost -p $DBPORT -f $CUSTOM_DIR/disable_users.sql
    echo "DONE! Disabled users"
else
    echo "Ok. Will not disable."
fi 

echo "###"
echo "### Add metadata columns using fix_gwas_metadata_analysis_ext.sql"
echo "###"

# Will not check if this is already applied
# but will let the user decide if we should go through this process

fix_gwas_ext=""
read -n 1 -p "Add extra columns in BIOMART.BIO_ASSAY_ANALYSIS_EXT? (Y/N):" fix_gwas_ext
if [ "$fix_gwas_ext" = "Y" ]; then
    psql -U postgres -d transmart -h localhost -p $DBPORT -f $CUSTOM_DIR/fix_gwas_metadata_bio_assay_analysis_ext.sql
    echo "DONE! Added columns"
else
    echo "Ok. Will not add column."
fi

# TO-DO: add the monitoring schema

echo ""
echo "### DONE ###"
echo "### Don't forget to rebuild the transmart-core project after applying customizations: 'gradle :transmart-server:bootRepackage' 
and in transmart-batch build using 'gradle shadowJar' ###"
