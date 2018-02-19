### Troubleshooting the dbSNP load

Issue: the loading of the dbSNP dictionary (common_all dbSNP v150 hg38) has been running for almost 7 days, and is still loading chr11 into de_snp_info.

CPU is used 100% by postgres. Memory usage is not a problem. 

Looking into the code, it is probably the COUNT that is done for each SNP, in order to check if the SNP info already exists in the table. 
This can be very expensive, and with Postgres it would be better to use the `EXISTS` instead of `COUNT` (https://blog.jooq.org/2016/09/14/avoid-using-count-in-sql-when-you-could-use-exists/).

Could for now try to load directly without doing the check if the SNP already exists. 

```
Number of lines in VCF file: 37463704
Number of lines in VCF file that contain #: 57
37463704 - 57 = 37463647
37463647 = corresponds to the number of rows in the TSV file created by transmart-loader and also the number of rows in the vcf38 table.  
```

Log in as postgres

```
sudo su postgres
psql -d transmart
```

Show running queries:

```
SELECT pid, age(query_start, clock_timestamp()), usename, query 
FROM pg_stat_activity 
WHERE query != '<IDLE>' AND query NOT ILIKE '%pg_stat_activity%' 
ORDER BY query_start desc;
```

No duplicates, so would be safe to just copy and skip the counting:

```
select rs_id, chrom, pos, count(*) from tm_lz.vcf38 group by rs_id, chrom, pos having count(*) > 1;

 rs_id | chrom | pos | count
-------+-------+-----+-------
(0 rows)

```

Type `\q` to exit psql.

Another potential contributor to the performance issues could be the index (https://use-the-index-luke.com/sql/dml/insert). Each time we add a row, the index would need to update. 

If we plan to remove the count for checking if we already have a SNP in the table, then we don't need the index when we load the dictionary. 

Drop index before load:

```
DROP INDEX deapp.de_snp_chrompos_ind;
```

Recreate index after load:

```
CREATE INDEX deapp.de_snp_chrompos_ind ON de_snp_info USING btree (chrom, chrom_pos);
ALTER INDEX deapp.de_snp_chrompos_ind SET TABLESPACE indx;
```

Same for de_rc_snp_info table.

Check which indexes are currently available:
```
select *
from pg_indexes
where tablename like 'de_rc_snp_info%';

transmart-# where tablename like 'de_rc_snp_info%';
 schemaname |   tablename    |          indexname           | tablespace |                                             indexdef
------------+----------------+------------------------------+------------+--------------------------------------------------------------------------------------------------
 deapp      | de_rc_snp_info | ind_vcf_rsid                 | indx       | CREATE INDEX ind_vcf_rsid ON deapp.de_rc_snp_info USING btree (rs_id)
 deapp      | de_rc_snp_info | ind_vcf_pos                  | indx       | CREATE INDEX ind_vcf_pos ON deapp.de_rc_snp_info USING btree (pos)
 deapp      | de_rc_snp_info | de_rsnp_hgrs_ind             | indx       | CREATE UNIQUE INDEX de_rsnp_hgrs_ind ON deapp.de_rc_snp_info USING btree (hg_version, rs_id)
 deapp      | de_rc_snp_info | de_rsnp_chrompos_ind         | indx       | CREATE INDEX de_rsnp_chrompos_ind ON deapp.de_rc_snp_info USING btree (chrom, pos)
 deapp      | de_rc_snp_info | de_rsnp_chrom_comp_idx       | indx       | CREATE INDEX de_rsnp_chrom_comp_idx ON deapp.de_rc_snp_info USING btree (chrom, hg_version, pos)
 deapp      | de_rc_snp_info | de_rc_snp_info_rs_id_idx     | indx       | CREATE INDEX de_rc_snp_info_rs_id_idx ON deapp.de_rc_snp_info USING btree (rs_id)
 deapp      | de_rc_snp_info | de_rc_snp_info_entrez_id_idx | indx       | CREATE INDEX de_rc_snp_info_entrez_id_idx ON deapp.de_rc_snp_info USING btree (entrez_id)
 deapp      | de_rc_snp_info | de_rc_snp_info_chrom_pos_idx | indx       | CREATE INDEX de_rc_snp_info_chrom_pos_idx ON deapp.de_rc_snp_info USING btree (chrom, pos)
 deapp      | de_rc_snp_info | de_r_s_i_ind4                | indx       | CREATE INDEX de_r_s_i_ind4 ON deapp.de_rc_snp_info USING btree (snp_info_id)
(9 rows)

```

Drop indexes:

```
DROP INDEX deapp.ind_vcf_rsid;
DROP INDEX deapp.ind_vcf_pos;
DROP INDEX deapp.de_rsnp_hgrs_ind;
DROP INDEX deapp.de_rsnp_chrompos_ind;
DROP INDEX deapp.de_rsnp_chrom_comp_idx;
DROP INDEX deapp.de_rc_snp_info_rs_id_idx;
DROP INDEX deapp.de_rc_snp_info_entrez_id_idx;
DROP INDEX deapp.de_rc_snp_info_chrom_pos_idx;
DROP INDEX deapp.de_r_s_i_ind4;
```

Recreate index after reload:

```
CREATE INDEX deapp.ind_vcf_rsid ON deapp.de_rc_snp_info USING btree (rs_id);
CREATE INDEX deapp.ind_vcf_pos ON deapp.de_rc_snp_info USING btree (pos);
CREATE UNIQUE INDEX deapp.de_rsnp_hgrs_ind ON deapp.de_rc_snp_info USING btree (hg_version, rs_id);
CREATE INDEX deapp.de_rsnp_chrompos_ind ON deapp.de_rc_snp_info USING btree (chrom, pos);
CREATE INDEX deapp.de_rsnp_chrom_comp_idx ON deapp.de_rc_snp_info USING btree (chrom, hg_version, pos);
CREATE INDEX deapp.de_rc_snp_info_rs_id_idx ON deapp.de_rc_snp_info USING btree (rs_id);
CREATE INDEX deapp.de_rc_snp_info_entrez_id_idx ON deapp.de_rc_snp_info USING btree (entrez_id);
CREATE INDEX deapp.de_rc_snp_info_chrom_pos_idx ON deapp.de_rc_snp_info USING btree (chrom, pos);
CREATE INDEX deapp.de_r_s_i_ind4 ON deapp.de_rc_snp_info USING btree (snp_info_id);
ALTER INDEX deapp.ind_vcf_rsid SET TABLESPACE indx;
ALTER INDEX deapp.ind_vcf_pos SET TABLESPACE indx;
ALTER INDEX deapp.de_rsnp_hgrs_ind SET TABLESPACE indx;
ALTER INDEX deapp.de_rsnp_chrompos_ind SET TABLESPACE indx;
ALTER INDEX deapp.de_rsnp_chrom_comp_idx SET TABLESPACE indx;
ALTER INDEX deapp.de_rc_snp_info_rs_id_idx SET TABLESPACE indx;
ALTER INDEX deapp.de_rc_snp_info_entrez_id_idx SET TABLESPACE indx;
ALTER INDEX deapp.de_rc_snp_info_chrom_pos_idx SET TABLESPACE indx;
ALTER INDEX deapp.de_r_s_i_ind4 SET TABLESPACE indx;
```
