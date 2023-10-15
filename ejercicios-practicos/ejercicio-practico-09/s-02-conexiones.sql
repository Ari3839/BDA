-- @Autor:  Ariadna Lázaro
-- @Fecha:  11/10/2023
-- @Descripcion:Diferentes modos de conexión

Prompt conectando como usuario sys
connect sys/system2 as sysdba

Prompt Tabla 01
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T01_SESSION_DATA';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t01_session_data as
  select 1 id,sid,logon_time,username,status,server,osuser,
    machine,type,process,port
  from v$session where username='SYS' and type='USER';
commit;

connect sys/system2@aalmbda2_dedicated as sysdba

insert into ariadna09.t01_session_data(id,sid,logon_time,
username,status,server,osuser,machine,type,process,port)
values(2,
  (select sid from v$session where username='SYS' and type='USER'),
  (select logon_time from v$session where username='SYS' and type='USER'),
  (select username from v$session where username='SYS' and type='USER'),
  (select status from v$session where username='SYS' and type='USER'),
  (select server from v$session where username='SYS' and type='USER'),
  (select osuser from v$session where username='SYS' and type='USER'),
  (select machine  from v$session where username='SYS' and type='USER'),
  (select type from v$session where username='SYS' and type='USER'),
  (select process from v$session where username='SYS' and type='USER'),
  (select port from v$session where username='SYS' and type='USER')
);
commit;

connect sys/system2@aalmbda2_shared as sysdba

insert into ariadna09.t01_session_data(id,sid,logon_time,
username,status,server,osuser,machine,type,process,port)
values(3,
  (select sid from v$session where username='SYS' and type='USER'),
  (select logon_time from v$session where username='SYS' and type='USER'),
  (select username from v$session where username='SYS' and type='USER'),
  (select status from v$session where username='SYS' and type='USER'),
  (select server from v$session where username='SYS' and type='USER'),
  (select osuser from v$session where username='SYS' and type='USER'),
  (select machine  from v$session where username='SYS' and type='USER'),
  (select type from v$session where username='SYS' and type='USER'),
  (select process from v$session where username='SYS' and type='USER'),
  (select port from v$session where username='SYS' and type='USER')
);
commit;

Prompt Mostrando datos de t01_session_data
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
set linesize window
Prompt Mostrando datos generados
col username format a10
col osuser format a10
col machine format a15
col process format a10
select * from ariadna09.t01_session_data;
