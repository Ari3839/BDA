-- @Autor:  Ariadna Lázaro
-- @Fecha:  28/sept/2023
-- @Descripcion:Generalidades del db buffer cache

Prompt Conectando como sys
connect sys/system2 as sysdba

Prompt Tabla1
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA07';
  v_tablename varchar2(50):='T01_DB_BUFFER_CACHE';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna07.t01_db_buffer_cache (
  block_size number,
  current_size number,
  buffers number,
  target_buffers number,
  prev_size number,
  prev_buffers number,
  default_pool_size number);

insert into ariadna07.t01_db_buffer_cache(block_size,current_size,buffers,
  target_buffers,prev_size,prev_buffers,default_pool_size) values(
    (select block_size from v$buffer_pool),
    (select current_size from v$buffer_pool),
    (select buffers from v$buffer_pool),
    (select target_buffers from v$buffer_pool),
    (select prev_size from v$buffer_pool),
    (select prev_buffers from v$buffer_pool),
    (select value from v$parameter where name='db_cache_size')
  );

Prompt Mostrando datos tabla t01_db_buffer_cache
set linesize window
select * from ariadna07.t01_db_buffer_cache;


Prompt Tabla2
declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA07';
  v_tablename varchar2(50):='T02_DB_BUFFER_SYSSTATS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/
create table ariadna07.t02_db_buffer_sysstats (
  db_blocks_gets_from_cache number,
  consistent_gets_from_cache number,
  physical_reads_cache number,
  cache_hit_radio number);

insert into ariadna07.t02_db_buffer_sysstats(
  db_blocks_gets_from_cache,consistent_gets_from_cache,
  physical_reads_cache,cache_hit_radio) 
values(
	(select value from v$sysstat
      where name ='db block gets from cache'),
	(select value
      from v$sysstat where name ='consistent gets from cache'),
	(select value
      from v$sysstat where name ='physical reads cache'),
	(select round(1-((select value from v$sysstat where name ='physical reads cache')/
	((select value from v$sysstat where name ='db block gets from cache') + 
	 (select value from v$sysstat where name ='consistent gets from cache'))),6)
	as cache_hit_radio from dual)
);

Prompt Mostrando datos tabla t02_db_buffer_sysstats
select * from ariadna07.t02_db_buffer_sysstats;

exit
