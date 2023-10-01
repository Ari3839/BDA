-- @Autor: 	Ariadna Lázaro
-- @Fecha:	17/09/2023
-- @Descripción:Modificar parametros desde instancia

Prompt conectando como sys
connect sys/system2 as sysdba

--En caso de error
whenever sqlerror exit rollback

Prompt modificando parametros
--a
alter session set nls_date_format='dd/mm/yyy hh24:mi:ss';
--b
alter system set db_writer_processes=2 scope=spfile;
--c 10M
alter system set log_buffer=10485760 scope=spfile;
--d
alter system set db_files=250 scope=spfile;
--e
alter system set dml_locks=2500 scope=spfile;
--f
alter system set transactions=600 scope=spfile;
--g 2M
alter session set hash_area_size=2097152;
alter system set hash_area_size=2097152 scope=spfile;
--h 1M
alter session set sort_area_size=1048576;
--i
alter system set sql_trace=TRUE scope=memory;
--j 
alter system set optimizer_mode=FIRST_ROWS_100 scope=both;
--k
alter session set cursor_invalidation=DEFERRED;

Prompt creando tablas
create table ariadna06.t03_update_param_session as
  select name,value from v$parameter
  where name in (
    'cursor_invalidation','optimizer_mode','sql_trace',
    'sort_area_size','hash_area_size','nls_date_format',
    'db_writer_processes','db_files','dml_locks',
    'log_buffer','transactions'
) and value is not null;

create table ariadna06.t04_update_param_instance as
  select name,value from v$system_parameter
  where name in (
    'cursor_invalidation','optimizer_mode','sql_trace',
    'sort_area_size','hash_area_size','nls_date_format',
    'db_writer_processes','db_files','dml_locks',
    'log_buffer','transactions'
) and value is not null;

create table ariadna06.t05_update_param_spfile as
  select name,value from v$spparameter
  where name in (
    'cursor_invalidation','optimizer_mode','sql_trace',
    'sort_area_size','hash_area_size','nls_date_format',
    'db_writer_processes','db_files','dml_locks',
    'log_buffer','transactions'
) and value is not null;

Prompt Consultando valores
col name format a30
col value format a30
select * from ariadna06.t03_update_param_session;
select * from ariadna06.t04_update_param_instance;
select * from ariadna06.t05_update_param_spfile;

#Prompt Creando pfile
#create pfile='/unam-bda/ejercicios-practicos/ejercicio-practico-06/e-03-spparameter-pfile.txt' from spfile;

Prompt Mostrando contenido del archivo e-03-spparameter-pfile.txt
!cat /unam-bda/ejercicios-practicos/ejercicio-practico-06/e-03-spparameter-pfile.txt | grep "*."

exit
