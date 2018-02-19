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
CREATE INDEX de_snp_chrompos_ind ON de_snp_info USING btree (chrom, chrom_pos);
```
