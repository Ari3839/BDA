-- @Autor:  Ariadna Lázaro
-- @Fecha:  11/10/2023
-- @Descripcion:

Prompt conectando como usuario sys
connect sys/system2@aalmbda2_shared as sysdba

Prompt Tabla 02
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T02_DISPATCHER_CONFIG';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t02_dispatcher_config as
  select 1 id,dispatchers,connections,sessions,service
  from v$dispatcher_config;

Prompt Mostrando tabla02
col service format a20
set linesize window
select * from ariadna09.t02_dispatcher_config;

Prompt Tabla 03
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T03_DISPATCHER';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t03_dispatcher as
  select 1 id,name,network,status,messages,
    round(bytes/1024/1024,2) as messages_mb,
    created as circuits_created,round(idle/100/60,2)
    as idle_min
  from v$dispatcher;

Prompt Mostrando tabla03
col network format a30
select * from ariadna09.t03_dispatcher;


Prompt Tabla 04
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T04_SHARED_SERVER';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t04_shared_server as
  select 1 id,name,messages,status,
    round(bytes/1024/1024,2) as messages_mb,requests,
    round(idle/100/60,2) as idle_min,
    round(busy/100/60,2) as busy_min
  from v$shared_server;

Prompt Mostrando tabla04
select * from ariadna09.t04_shared_server;


Prompt Tabla 05
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T05_QUEUE';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t05_queue as
  select 1 id,queued,wait,totalq
  from v$queue;

Prompt Mostrando tabla05
select * from ariadna09.t05_queue;



Prompt Tabla 06
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA09';
  v_tablename varchar2(50):='T06_VIRTUAL_CIRCUIT';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna09.t06_virtual_circuit as
  select 1 id,c.circuit as circuit,d.name as name,
    c.server as server,c.status as status, c.queue as queue
  from v$circuit c join v$dispatcher d
  on c.dispatcher=d.paddr;

Prompt Mostrando tabla06
select * from ariadna09.t06_virtual_circuit;


