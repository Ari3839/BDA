-- @Autor:  Ariadna Lázaro
-- @Fecha:  20/11/2023
-- @Descripcion:Creación del los tablespaces

Prompt conectando como usuario sys
connect sys/system2 as sysdba

create tablespace store_tbs1
  datafile '/u01/app/oracle/oradata/AALMBDA2/store_tbs01.dbf' size 20m 
  autoextend off
  extent management local autoallocate
  segment space management auto;

create tablespace store_tbs_multiple
  datafile 
  '/u01/app/oracle/oradata/AALMBDA2/store_tbs_multiple_01.dbf' size 20m,
  '/u01/app/oracle/oradata/AALMBDA2/store_tbs_multiple_02.dbf' size 20m,
  '/u01/app/oracle/oradata/AALMBDA2/store_tbs_multiple_03.dbf' size 20m 
  autoextend off
  extent management local autoallocate
  segment space management auto;

create bigfile tablespace store_tbs_big
  datafile '/u01/app/oracle/oradata/AALMBDA2/store_tbs_big.dbf' size 100m
  autoextend off
  extent management local autoallocate
  segment space management auto;

create tablespace store_tbs_zip
  datafile'/u01/app/oracle/oradata/AALMBDA2/store_tbs_zip' size 10m
  default index compress advanced high;

create temporary tablespace store_tbs_temp
  tempfile '/u01/app/oracle/oradata/AALMBDA2/store_tbs_temp'
  size 16M
  reuse;

create tablespace store_tbs_custom
  datafile '/u01/app/oracle/oradata/AALMBDA2/store_tbs_custom_01.dbf' size 10m
  reuse
  autoextend on next 1m maxsize 30m
  nologging
  offline
  blocksize 8k
  extent management local uniform size 64k
  segment space management auto;