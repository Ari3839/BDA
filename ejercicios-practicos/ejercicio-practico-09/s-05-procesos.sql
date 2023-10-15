-- @Autor:  Ariadna Lázaro
-- @Fecha:  14/10/2023
-- @Descripcion:Consultas de procesos fg y bg

Prompt conectando como usuario sys
connect sys/system2@AALMBDA2_POOLED as sysdba

insert into ariadna09.t01_session_data(id,sid,logon_time,
username,status,server,osuser,machine,type,process,port)
values(4,
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

Prompt mostrando datos de t01
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
set linesize window
Prompt Mostrando datos generados
col username format a10
col osuser format a10
col machine format a15
col process format a10
select * from ariadna09.t01_session_data;

Prompt Tabla 07
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T07_FOREGROUND_PROCESS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t07_foreground_process as
  select p.SOSID as sosid, p.pname as pname, 
    s.OSUSER as os_username,s.username as bd_username,
    s.server as server,round(p.PGA_MAX_MEM/1024/1024,2) 
    as PGA_MAX_MEM_MB,p.tracefile as tracefile
  from v$process p left join v$session s
  on p.addr = s.paddr
  where p.background is null
  order by bd_username,os_username;

Prompt mostrando datos de t07
col os_username format a20
col bd_username format a20
col tracefile format a40
select * from ariadna09.t07_foreground_process;

Prompt Tabla 08
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T08_F_PROCESS_ACTUAL';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t08_f_process_actual as
  select p.SOSID as sosid, p.pname as pname, 
    s.OSUSER as os_username,s.username as bd_username,
    s.server as server,round(p.PGA_MAX_MEM/1024/1024,2) 
    as PGA_MAX_MEM_MB,p.tracefile as tracefile
  from v$process p left join v$session s
  on p.addr = s.paddr
  where sys_context('USERENV','SID') = s.sid
  and p.background is null
  order by bd_username,os_username;

Prompt mostrando datos de t08
select * from ariadna09.t08_f_process_actual;

Prompt Tabla 09
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T09_BACKGROUND_PROCESS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t09_background_process as
  select p.SOSID as sosid, p.pname as pname, 
    s.OSUSER as os_username,s.username as bd_username,
    s.server as server,round(p.PGA_MAX_MEM/1024/1024,2) 
    as PGA_MAX_MEM_MB,p.tracefile as tracefile
  from v$process p left join v$session s
  on p.addr = s.paddr
  where p.background is not null
  order by bd_username,os_username;

Prompt mostrando datos de t09
select * from ariadna09.t09_background_process;
