-- @Autor:  Ariadna Lázaro
-- @Fecha:  08/10/2023
-- @Descripcion:Caracteristicas de la pga

Prompt conectando como usuario sys
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA08';
  v_tablename varchar2(50):='T04_PGA_STATS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Tabla 04
create table ariadna08.t04_pga_stats(
  max_pga_mb number,
  pga_target_param_calc_mb number,
  pga_target_param_actual_mb number,
  pga_total_actual_mb number,
  pga_in_use_actual_mb number,
  pga_free_memory_mb number,
  pga_process_count number,
  pga_cache_hit_percentage number
);

insert into ariadna08.t04_pga_stats(max_pga_mb,
  pga_target_param_calc_mb,pga_target_param_actual_mb,
  pga_total_actual_mb,pga_in_use_actual_mb,pga_free_memory_mb,
  pga_process_count,pga_cache_hit_percentage) 
values(
  (select round(value/1024/1024,2) from v$pgastat where name='maximum PGA allocated'),
  (select round(value/1024/1024,2) from v$pgastat where name='aggregate PGA target parameter'), --------
  (select round(value/1024/1024,2) from v$parameter where name='pga_aggregate_target'),
  (select round(value/1024/1024,2) from v$pgastat where name='total PGA allocated'),
  (select round(value/1024/1024,2) from v$pgastat where name='total PGA inuse'),
  (select round(value/1024/1024,2) from v$pgastat where name='total freeable PGA memory'),
  (select round(value) from v$pgastat where name='process count'),
  (select round(value) from v$pgastat where name='cache hit percentage')
);


Prompt mostrando datos por partes
set linesize window

select max_pga_mb,pga_target_param_calc_mb,pga_target_param_actual_mb,pga_total_actual_mb
 from ariadna08.t04_pga_stats;

select pga_in_use_actual_mb,pga_free_memory_mb,pga_process_count,pga_cache_hit_percentage
 from ariadna08.t04_pga_stats;
