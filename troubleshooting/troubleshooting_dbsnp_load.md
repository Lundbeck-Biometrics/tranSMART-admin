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

Turns out that even after removing the COUNT and the indexes, we still have performance problems.

This time with the CPU usage by the Java process. After loading the data into deapp.de_snp_info, the step of loading into deapp.de_rc_snp_info is very slow and it is Java, not Postgres, that uses resources. And the load crashes at loading chromosome 4:

```
34793443 [main] INFO  org.transmartproject.pipeline.vcf.VCF  - Insert rs185641944:4:81515706 88596310 '' into DE_RC_SNP_INFO ...
Exception in thread "main" java.lang.OutOfMemoryError: GC overhead limit exceeded
        at java.nio.CharBuffer.wrap(CharBuffer.java:466)
        at java.nio.CharBuffer.wrap(CharBuffer.java:487)
        at org.postgresql.core.Utils.encodeUTF8(Utils.java:63)
        at org.postgresql.core.v3.SimpleParameterList.getV3Length(SimpleParameterList.java:307)
        at org.postgresql.core.v3.QueryExecutorImpl.sendBind(QueryExecutorImpl.java:1277)
        at org.postgresql.core.v3.QueryExecutorImpl.sendOneQuery(QueryExecutorImpl.java:1581)
        at org.postgresql.core.v3.QueryExecutorImpl.sendQuery(QueryExecutorImpl.java:1096)
        at org.postgresql.core.v3.QueryExecutorImpl.execute(QueryExecutorImpl.java:396)
        at org.postgresql.jdbc2.AbstractJdbc2Statement.executeBatch(AbstractJdbc2Statement.java:2893)
        at groovy.sql.BatchingPreparedStatementWrapper.addBatch(BatchingPreparedStatementWrapper.java:62)
        at groovy.sql.BatchingPreparedStatementWrapper$addBatch.call(Unknown Source)
        at org.transmartproject.pipeline.vcf.VCF$_loadDeRcSnpInfo_closure1_closure15.doCall(VCF.groovy:169)
        at sun.reflect.GeneratedMethodAccessor16.invoke(Unknown Source)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
        at java.lang.reflect.Method.invoke(Method.java:498)
        at org.codehaus.groovy.reflection.CachedMethod.invoke(CachedMethod.java:90)
        at groovy.lang.MetaMethod.doMethodInvoke(MetaMethod.java:233)
        at org.codehaus.groovy.runtime.metaclass.ClosureMetaClass.invokeMethod(ClosureMetaClass.java:272)
        at groovy.lang.MetaClassImpl.invokeMethod(MetaClassImpl.java:909)
        at groovy.lang.Closure.call(Closure.java:411)
        at groovy.lang.Closure.call(Closure.java:427)
        at groovy.sql.Sql.eachRow(Sql.java:1186)
        at groovy.sql.Sql.eachRow(Sql.java:1143)
        at groovy.sql.Sql.eachRow(Sql.java:1082)
        at groovy.sql.Sql$eachRow.call(Unknown Source)
        at org.codehaus.groovy.runtime.callsite.CallSiteArray.defaultCall(CallSiteArray.java:45)
        at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:108)
        at org.codehaus.groovy.runtime.callsite.AbstractCallSite.call(AbstractCallSite.java:120)
        at org.transmartproject.pipeline.vcf.VCF$_loadDeRcSnpInfo_closure1.doCall(VCF.groovy:157)
        at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
        at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:62)
        at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
```

Another approach could be splitting the VCF file into multiple files that we load one by one. The data in the deapp schema is not deleted during reload, so it should be safe to load multiple files. Also, the transmart loader code doesn't have any dependencies on the VCF header, so we can just do a simple split on the file:

```
grep -v "^#" common_all.vcf > common.vcf
split -l 4000000 common.vcf common
```
