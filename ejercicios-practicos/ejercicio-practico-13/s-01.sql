-- @Autor:  Ariadna Lázaro
-- @Fecha:  24/11/2023
-- @Descripcion:Configuración a modo archive

--mkdir -p /unam-bda/archivelogs/AALMBDA2/disk_a
--mkdir -p /unam-bda/archivelogs/AALMBDA2/disk_b
--chown -R oracle:oinstall /unam-bda/archivelogs
--chmod -R 750 /unam-bda/archivelogs

Prompt conectando como usuario sys
connect sys/system2 as sysdba

create pfile='$ORACLE_HOME/dbs/pfilePrevioArchive' from spfile;

alter system set log_archive_max_processes=2 scope=spfile;
alter system set log_archive_format='arch_aalmbda2_%t_%s_%r.arc' scope=spfile;
alter system set log_archive_trace=12 scope=spfile;
alter system set log_archive_dest_1='LOCATION=/unam-bda/archivelogs/AALMBDA2/disk_a MANDATORY' scope=spfile;
alter system set log_archive_dest_2='LOCATION=/unam-bda/archivelogs/AALMBDA2/disk_b' scope=spfile;
alter system set log_archive_min_succeed_dest=1 scope=spfile;

shutdown immediate

startup mount

alter database archivelog;
alter database open;

archive log list;

create pfile='$ORACLE_HOME/dbs/pfilePosteriorArchive' from spfile;