# Load SNP dictionary
# Needed in order to have the SNP and genes info shown in the tables in the GWAS module

cd /datastore/transmart/transmart-data/env/tranSMART-ETL
java -Xmx1024m -cp target/loader-jar-with-dependencies.jar org.transmartproject.pipeline.vcf/VCF > snp.out > snp.err

# Note: haven't tested the above! We previously loaded the data by building the project on own machine and then 
# loading to the server. But since the jar is already on the tranSMART server, the above should work.
