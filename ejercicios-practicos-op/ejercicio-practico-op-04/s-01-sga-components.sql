-- @Autor:	Ariadna Lázaro
-- @Fecha:	26/09/2023
-- @Descripcion:Uso de parámetros de memoria

Prompt Conectando como sys
connect sys/system2 as sysdba

Prompt Tabla1
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T01_SGA_COMPONENTS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t01_sga_components(
  memory_target_param number(10,2),
  fixed_size number(10,2),
  variable_size number(10,2),
  database_buffers number(10,2),
  redo_buffers number(10,2),
  total_sga number(10,2)
);

insert into ariadna04op.t01_sga_components(memory_target_param,
  fixed_size,variable_size,database_buffers,redo_buffers,total_sga)
values(
  (select round(value/1024/1024,2) from v$system_parameter where name='memory_target'),
  (select round(value/1024/1024,2) from v$sga where name='Fixed Size'),
  (select round(value/1024/1024,2) from v$sga where name='Variable Size'),
  (select round(value/1024/1024,2) from v$sga where name='Database Buffers'),
  (select round(value/1024/1024,2) from v$sga where name='Redo Buffers'),
  (select round(sum(value/1024/1024),2) from v$sga)
);

set linesize window
select * from ariadna04op.t01_sga_components;

Prompt Tabla2
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T02_SGA_DYNAMIC_COMPONENTS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t02_sga_dynamic_components as
select component as component_name,
  round(current_size/1024/1024,2) as current_size_mb,
  oper_count as operation_count,
  last_oper_type as last_operation_type,
  last_oper_time as las_operation_time
from v$sga_dynamic_components
order by current_size_mb desc;

col component_name format a28;
select * from ariadna04op.t02_sga_dynamic_components;


Prompt Tabla3
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T03_SGA_MAX_DYNAMIC_COMPONENT';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t03_sga_max_dynamic_component as  
select component as component_name,
  round(current_size/1024/1024,2) as current_size_mb 
  from v$sga_dynamic_components
  where current_size=(
    select max(current_size) from v$sga_dynamic_components);

select * from ariadna04op.t03_sga_max_dynamic_component;


Prompt Tabla4
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T04_SGA_MIN_DYNAMIC_COMPONENT';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t04_sga_min_dynamic_component as  
select component as component_name,
  round(current_size/1024/1024,2) as current_size_mb 
  from v$sga_dynamic_components
  where current_size=(
    select min(current_size) from v$sga_dynamic_components
    where current_size>0);

select * from ariadna04op.t04_sga_min_dynamic_component;


Prompt Tabla5
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T05_SGA_MEMORY_INFO';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t05_sga_memory_info as
select name,
  round(bytes/1024/1024,2) as current_size_mb 
  from v$sgainfo 
  where name='Maximum SGA Size'
  or name='Free SGA Memory Available';

col name format a28;

select * from ariadna04op.t05_sga_memory_info;


Prompt Tabla6
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T06_SGA_RESIZEABLE_COMPONENTS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t06_sga_resizeable_components as
select * from v$sgainfo where resizeable='Yes';

select * from ariadna04op.t06_sga_resizeable_components;


Prompt Tabla7
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA04OP';
  v_tablename varchar2(50):='T07_SGA_RESIZE_OPS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna04op.t07_sga_resize_ops as
select component,oper_type,parameter,
  round(initial_size/1024/1024,2) as initial_size_mb,
  round(target_size/1024/1024,2) as target_size_mb,
  round(final_size/1024/1024,2) as final_size_mb,
  round(final_size/1024/1024-initial_size/1024/1024,2) as increment_mb,
  status,start_time,end_time
from v$sga_resize_ops
order by component,end_time;

col component format a30;
col parameter format a26;

select component,oper_type,parameter from ariadna04op.t07_sga_resize_ops;
select initial_size_mb,target_size_mb,final_size_mb,increment_mb,
  status,start_time,end_time from ariadna04op.t07_sga_resize_ops;

commit;

exit;
