#!/bin/bash

# Shell script to copy the customized Config.groovy file

CUSTOM_DIR=./customisations
TARGET_FILE=~/.grails/transmartConfig/Config.groovy

copy_files() {
    local src_file=$1
    local dst_file=$2
    if [ ! -f $dst_file ]; then
        echo "$dst_file not found. Will copy now."
        if cp $src_file $dst_file; then
            echo "DONE! Added $dst_file"
        else
            echo "Failure, exit status $?"
        fi
    else
        echo "$dst_file already exists. "
        echo "Checking for differences."
        if [[ $(diff $src_file $dst_file | wc -l) -ne 0 ]]; then
            echo "File is different."
            diff $src_file $dst_file
            read -n 1 -p "Overwrite? (Y/N):" overwrite_file
            echo ""
            if [ "$overwrite_file" = "Y" ]; then
                if cp $src_file $dst_file; then
                    echo "DONE! Updated $dst_file"
                else
                    echo "Failure, exit status $?"
                fi
            else
                echo "Ok. Will not copy."
            fi
        else
            echo "Files identical. Will not copy."
        fi
    fi
}

echo "################################################################################"
echo "### Copying the Config.groovy file"
echo "################################################################################"

copy_files "$CUSTOM_DIR/Config.groovy" $TARGET_FILE


#TO-DO: be notified if changes to the Config-template file have been made as we might be interested in those. 