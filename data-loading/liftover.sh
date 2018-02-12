#!/bin/bash

# Convert dbSNP rs number from one build to another
# https://genome.sph.umich.edu/wiki/LiftOver

# Required files: 
# liftRsNumber.py
# RsMergeArch: ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/database/data/organism_data/RsMergeArch.bcp.gz
# SNPHistory: ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/database/data/organism_data/SNPHistory.bcp.gz

# Example usage:
# ./liftover.sh -c 1 -s '\t' -f ~/Documents/tranSMART/liftover/pgc.scz.full.2012-04.txt
# Assuming the file has a header and that the column that contains the SNP ids is in the rsid format 

while getopts 'c:s:f:' OPTION; do
  case "$OPTION" in
    c)
        echo "column number is $OPTARG"
        rsid_col="$OPTARG"
        ;;
    s)
        echo "separator is $OPTARG"
        sep="$OPTARG"
        ;;
    f)
        echo "file is $OPTARG"
        input_file=$(basename "${OPTARG}")
        input_dir=$(dirname "${OPTARG}")
        output_dir=$input_dir/liftover
      ;;
    \?)
        echo "script usage: $(basename $0) -c rsid_column_number -s separator -f input_file" >&2
        exit 1
        ;;
  esac
done

if [ ! -d "$output_dir" ]; then
    mkdir $output_dir
fi

# Get the rsids from the data file 

if [ "$sep" == "\t" ]; then
    tail -n +2 $input_dir/$input_file | cut -f $rsid_col | cut -c 3- > $output_dir/$input_file.rsids
    col_name=$(head -n 1 $input_dir/$input_file | cut -f $rsid_col)
elif [ "$sep" == " " ]; then
    tail -n +2 $input_dir/$input_file | cut -d "$sep" -f $rsid_col | cut -c 3- > $output_dir/$input_file.rsids
    col_name=$(head -n 1 $input_dir/$input_file | cut -d "$sep" -f $rsid_col)
fi

# Run the python lift script
python liftRsNumber.py $output_dir/$input_file.rsids > $output_dir/$input_file.rsids.out

# Check how many rsids have been changed
cut -f 1 $output_dir/$input_file.rsids.out | sort | uniq -c > $output_dir/$input_file.liftover.report.txt

# Add rs in front of the updated ids
cut -f 2 $output_dir/$input_file.rsids.out | sed -e 's/^/rs/' > $output_dir/$input_file.rsids.out.rs
# Add header
( echo "$col_name"; cat $output_dir/$input_file.rsids.out.rs ) > $output_dir/$input_file.rsids.out.rs.h

# Update the rsids
awkcmd='FNR==NR{a[NR]=$1;next}{$'$rsid_col'=a[FNR]}1'
awk -v OFS="$sep" $awkcmd $output_dir/$input_file.rsids.out.rs.h $input_dir/$input_file > $output_dir/$input_file.lifted.txt

#rm $output_dir/$input_file.rsids.out.rs.h

cat $output_dir/$input_file.liftover.report.txt
