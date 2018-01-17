### Using `transmart-batch` for loading GWAS data in tranSMART 2017

Notes for data loaders:
* genome_version - Please note that it expects certain values, and thus if the value provided in the
gwas metadata file is not part of the list of expected values, then the loading will throw a not writable error. 
Change the value to one of the expected ones and reload.
* Should not have NAs in the data
* Formatting of metadata file - need to write with \r
