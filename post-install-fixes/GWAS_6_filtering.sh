# Workaround for filling in the pvalue from the data loaded in the field p_value_char

update biomart.bio_assay_analysis_eqtl
set p_value=cast(p_value_char as decimal);

update biomart.bio_assay_analysis_gwas
set p_value=cast(p_value_char as decimal);

