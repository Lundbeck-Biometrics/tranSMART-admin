Information on what data is stored in the database and where, and how it is used in the tranSMART application.

## Dictionaries

| Dictionary  | Usage | Database Table(s) |
| ------------- | ------------- | ------------- |
| Disease | used when creating a program and when searching  | biomart.bio_disease and maybe more?  |
| Genes, Proteins, miRNA, Metabolites | ? | biomart.bio_marker  |
| Species (example: Homo sapiens > Human) | ? | biomart.bio_taxonomy |
| Synonyms for diseases, genes, proteins, miRNA, metabolities | ? | bio_data_ext_code |
| Lists of various concepts (examples: therapeutic domain, experiment type, tissue type) | The therapeutic domain for example is used in creating a progam in the application. Data comes from tsv file in transmart-data/data/common/biomart | bio_concept_code |

TODO: look at the TSV files that are loaded in the database when tranSMART is installed: https://github.com/tranSMART-Foundation/transmart-data/data/common/ (look at the branch release 16.2 to see what our instance was installed with).

## Data Types

A good place to look into (other than the ETL scripts) in order to identify where the data goes when we load is to look at what needs to be deleted if we need to reload: https://wiki.transmartfoundation.org/display/transmartwiki/TranSMART+Guide+for+Manual+Data+Deleting

