### Load SNP database 

Note that in order to map the GWAS datasets to SNP reference information (such as chromosome, position), you need to have a SNP dictionary loaded in tranSMART. Check https://github.com/Lundbeck-Biometrics/tranSMART-ETL-dictionaries for instructions.

### Convert SNP ids to dbSNP build loaded in tranSMART

Before loading any GWAS data, ensure that your data has been processed with the same human genome and dbSNP version as the one used in tranSMART (for example, hg38 and dbSNP 150).

To convert the SNP rs ids from one version to the other, use the `lifover.sh` script.

Example:

```
./liftover.sh -c 1 -s '\t' -f pgc.mdd.full.2012-04.txt
```

### Using `transmart-batch` for loading GWAS data in tranSMART 2017

Notes for data loaders:
* genome_version - Please note that it expects certain values, and thus if the value provided in the
gwas metadata file is not part of the list of expected values, then the loading will throw a not writable error. 
Change the value to one of the expected ones and reload.
* Should not have NAs in the data
* Formatting of metadata file - need to write with \r


