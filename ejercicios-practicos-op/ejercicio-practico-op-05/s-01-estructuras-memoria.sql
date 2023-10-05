-- @Autor:  Ariadna Lázaro
-- @Fecha:  03/10/2023
-- @Descripcion: Valores de diferentes estructuras de memoria

--Comprobando si ya existe la tabla 
Prompt Conectando como sys
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA05OP';
  v_tablename varchar2(50):='T01_MEMORY_AREAS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt tabla 1
create table ariadna05op.t01_memory_areas(
  id number,
  sample_date date,
  redo_buffer_mb number,
  buffer_cache_mb number,
  shared_pool_mb number,
  large_pool_mb number,
  java_pool_mb number,
  total_sga_mb1 number,
  total_sga_mb2 number,
  total_sga_mb3 number,
  total_pga_mb1 number,
  total_pga_mb2 number,
  max_pga number
);

insert into ariadna05op.t01_memory_areas(id,sample_date,
  redo_buffer_mb,buffer_cache_mb,shared_pool_mb,large_pool_mb,
  java_pool_mb,total_sga_mb1,total_sga_mb2,
  total_sga_mb3,total_pga_mb1,total_pga_mb2,max_pga) values(1,
    (select current_date from dual),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Redo Buffers'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Buffer Cache Size'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Shared Pool Size'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Large Pool Size'),
    (select round(bytes/1024/1024,2) from v$sgainfo 
      where name='Java Pool Size'),
    (select trunc(
      (
        (select sum(value) from v$sga)-
        (select current_size from v$sga_dynamic_free_memory)
      )/1024/1024,2) 
    from dual),
    (select trunc(
      (
        (select sum(current_size) from v$sga_dynamic_components) +
        (select value from v$sga where name ='Fixed Size') +
        (select value from v$sga where name ='Redo Buffers')
      ) /1024/1024,2) 
    from dual),
    (select trunc(
      (select sum(bytes) from v$sgainfo where name not in (
        'Granule Size',
        'Maximum SGA Size',
        'Startup overhead in Shared Pool',
        'Free SGA Memory Available',
        'Shared IO Pool Size')
      ) /1024/1024,2) 
    from dual),
    (select trunc(value/1024/1024,2) memoria_pga_1
      from v$pgastat where name ='aggregate PGA target parameter'),
    (select trunc(current_size/1024/1024,2) memoria_pga_2
      from v$sga_dynamic_free_memory),
    (select round(value/1024/1024,2) from v$pgastat 
      where name='maximum PGA allocated')
);

Prompt mostrando tabla t01 por partes
set linesize window

select id,sample_date,redo_buffer_mb,buffer_cache_mb,
  shared_pool_mb,large_pool_mb,java_pool_mb
from ariadna05op.t01_memory_areas;

select total_sga_mb1,total_sga_mb2,
  total_sga_mb3,total_pga_mb1,total_pga_mb2,max_pga
from ariadna05op.t01_memory_areas;

Prompt tabla 2
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA05OP';
  v_tablename varchar2(50):='T02_MEMORY_PARAM_VALUES';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna05op.t02_memory_param_values(
  id number,
  sample_date date,
  memory_target number,
  sga_target number, 
  pga_aggregate_target number, 
  shared_pool_size number,
  large_pool_size number, 
  java_pool_size number, 
  db_cache_size number
);

insert into ariadna05op.t02_memory_param_values (id,sample_date,
  memory_target,sga_target,pga_aggregate_target,
  shared_pool_size,large_pool_size,java_pool_size,db_cache_size) 
values (1,
    (select current_date from dual),
    (select round(value/1024/1024,2) from v$parameter 
      where name='memory_target'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='sga_target'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='pga_aggregate_target'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='shared_pool_size'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='large_pool_size'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='java_pool_size'),
    (select round(value/1024/1024,2) from v$parameter 
      where name='db_cache_size')
  ); 


Prompt mostrando datos hasta el momento de t02_memory_param_values
select * from ariadna05op.t02_memory_param_values;
