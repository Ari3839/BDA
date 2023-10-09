-- @Autor:  Ariadna Lázaro
-- @Fecha:  08/10/2023
-- @Descripcion:Caracteristicas del shared pool y parseos

Prompt conectando como usuario sys
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA08';
  v_tablename varchar2(50):='T02_SHARED_POOL';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/


Prompt Tabla 02
create table ariadna08.t02_shared_pool(
  shared_pool_param_mb number,
  shared_pool_sga_info_mb number,
  resizeable varchar2(3),
  shared_pool_component_total number,
  shared_pool_free_memory number
);

insert into ariadna08.t02_shared_pool(shared_pool_param_mb,
shared_pool_sga_info_mb,resizeable,shared_pool_component_total,
shared_pool_free_memory) values(
  (select round(value/1024/1024,2) from v$parameter where name='shared_pool_size'),
  (select round(bytes/1024/1024,2) from v$sgainfo where name='Shared Pool Size'),
  (select resizeable from v$sgainfo where name='Shared Pool Size'),
  (select count(*) from v$sgastat where pool='shared pool'),
  (select round(bytes/1024/1024,2) from v$sgastat where name='free memory' 
    and pool='shared pool') 
);

Prompt mostrando datos de t02_shared_pool
set linesize window
select * from ariadna08.t02_shared_pool;

Prompt Tabla 03
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA08';
  v_tablename varchar2(50):='T03_LIBRARY_CACHE_HITS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna08.t03_library_cache_hits as
  select 1 id,reloads,invalidations,pins,pinhits,pinhitratio
    from v$librarycache
    where namespace='SQL AREA';

Prompt mostrando datos de t03_library_cache_hits
select * from ariadna08.t03_library_cache_hits;


Prompt Tabla test
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA08';
  v_tablename varchar2(50):='TEST_ORDEN_COMPRA';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

create table ariadna08.test_orden_compra(id number);

Prompt Ejecutando consultas con sentencias sql estáticas.
set timing on
declare
  v_orden_compra ariadna08.test_orden_compra%rowtype;
begin
  for i in 1..50000 loop
    begin
      execute immediate
      'select * from ariadna08.test_orden_compra where id='||i
      into v_orden_compra;
    exception
      when no_data_found then
        null;
    end;
  end loop;
end;
/
set timing off


Prompt capturando nuevamente estadísticas del library cache
insert into ariadna08.t03_library_cache_hits(id, reloads, invalidations,
  pins, pinhits, pinhitratio)
select 2 as id, reloads, invalidations, pins, pinhits, pinhitratio
  from v$librarycache
  where namespace='SQL AREA';

commit;

Prompt reiniciando instancia
shutdown
startup

Prompt insertando tercer registro
insert into ariadna08.t03_library_cache_hits(id, reloads, invalidations,
  pins, pinhits, pinhitratio)
select 3 as id, reloads, invalidations, pins, pinhits, pinhitratio
  from v$librarycache
  where namespace='SQL AREA';

commit;

Prompt Ejecutando consultas con placeholders.
set timing on
declare
  v_orden_compra ariadna08.test_orden_compra%rowtype;
begin
  for i in 1..50000 loop
  begin
    execute immediate
    'select * from ariadna08.test_orden_compra where id=:id'
    into v_orden_compra using i;
    exception
      when no_data_found then
      null;
    end;
  end loop;
end;
/
set timing off

Prompt insertando cuarto registro
insert into ariadna08.t03_library_cache_hits(id, reloads, invalidations,
  pins, pinhits, pinhitratio)
select 4 as id, reloads, invalidations, pins, pinhits, pinhitratio
  from v$librarycache
  where namespace='SQL AREA';

commit;

Prompt mostrando datos
select * from ariadna08.t03_library_cache_hits;
