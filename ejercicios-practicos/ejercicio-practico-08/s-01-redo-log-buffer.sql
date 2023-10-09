-- @Autor:  Ariadna Lázaro
-- @Fecha:  08/10/2023
-- @Descripcion:Caracteristicas del redo log buffer

Prompt conectando como usuario sys
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA08';
  v_tablename varchar2(50):='T01_REDO_LOG_BUFFER';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/


Prompt Tabla 01
create table ariadna08.t01_redo_log_buffer(
  redo_buffer_size_param_mb number,
  redo_buffer_sga_info_mb number,
  resizeable varchar2(3)
);

insert into ariadna08.t01_redo_log_buffer(
redo_buffer_size_param_mb,redo_buffer_sga_info_mb,
resizeable) values(
  (select round(value/1024/1024,2) from v$parameter where name='log_buffer'),
  (select round(bytes/1024/1024,2) from v$sgainfo where name='Redo Buffers'),
  (select resizeable from v$sgainfo where name='Redo Buffers')
);

Prompt mostrando datos de t01_redo_log_buffer
select * from ariadna08.t01_redo_log_buffer;

