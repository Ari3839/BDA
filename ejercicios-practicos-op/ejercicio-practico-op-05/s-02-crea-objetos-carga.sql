-- @Autor:  Ariadna Lázaro
-- @Fecha:  03/10/2023
-- @Descripcion: Procedimiento que busca un caracter en una tabla

--Comprobando si ya existe la tabla 
Prompt Conectando como sys para ver si ya existe t03
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA05OP';
  v_tablename varchar2(50):='T03_RANDOM_DATA';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/


declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA05OP';
  v_sequencename varchar2(50):='SEQ_T03_RANDOM_DATA';
begin
  select count(*) into v_count from all_objects
  where object_name=v_sequencename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop sequence '||v_owner||'.'||v_sequencename;
  end if;
end;
/

Prompt Conectando como usuario del ejericico
connect ariadna05op/ariadna

Prompt Tabla 3
create table t03_random_data(
  id number(18,0),
  r_varchar varchar2(1024),
  r_char char(18),
  r_integer number(10,0),
  r_double number(20,10),
  r_date date,
  r_timestamp timestamp
);

create sequence seq_t03_random_data;

begin
  for v_index in 1..80000 loop
    insert into t03_random_data(
      id,r_varchar,r_char,r_integer,r_double,r_date,r_timestamp
    )
    values(
      seq_t03_random_data.nextval,
      sys.dbms_random.string('P',1024),
      sys.dbms_random.string('U',18),
      trunc(sys.dbms_random.value(1,9999999999)),
      trunc(sys.dbms_random.value(1,9999999999),10),
      to_date(trunc(sys.dbms_random.value(1721424,5373484)),'J') +
      sys.dbms_random.normal,
      current_timestamp
    );
  end loop;
end;
/


create or replace procedure spv_query_random_data is
  cursor cur_consulta is
    select *
    from t03_random_data
    order by id;
  v_caracter char(1) := 'A';
  v_total number;
  v_count number;
  v_rows number;
begin
  v_total := 0;
  v_rows :=0;
  for r in cur_consulta loop
    --obtiene el número de ocurrencias en cada registro.
    select regexp_count(r.r_varchar,v_caracter) into v_count from dual;
    v_total := v_count + v_total;
    v_rows := v_rows +1;
  end loop;
  dbms_output.put_line('Carácter seleccionado: '||v_caracter);
  dbms_output.put_line('Total de ocurrencias: '||v_total);
  dbms_output.put_line('Total de registros procesados: '||v_rows);
end;
/
show errors

commit;

Prompt Conectando como sys para ingresar otro registro en t01
connect sys/system2 as sysdba

insert into ariadna05op.t01_memory_areas(id,sample_date,
  redo_buffer_mb,buffer_cache_mb,shared_pool_mb,large_pool_mb,
  java_pool_mb,total_sga_mb1,total_sga_mb2,
  total_sga_mb3,total_pga_mb1,total_pga_mb2,max_pga) values(2,
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

commit;

Prompt mostrando registros de t01
set linesize window
select id,sample_date,redo_buffer_mb,buffer_cache_mb,
  shared_pool_mb,large_pool_mb,java_pool_mb
from ariadna05op.t01_memory_areas;

select total_sga_mb1,total_sga_mb2,total_sga_mb3,
  total_pga_mb1,total_pga_mb2,max_pga
from ariadna05op.t01_memory_areas;
