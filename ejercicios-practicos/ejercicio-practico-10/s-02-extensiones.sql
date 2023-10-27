-- @Autor:  Ariadna Lázaro
-- @Fecha:  25/10/2023
-- @Descripcion:Consultas de extensiones

Prompt conectando como sys para eliminar tablas preexistentes
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA1001';
  v_tablename varchar2(50):='STR_DATA';
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
  v_owner varchar2(20) := 'ARIADNA1001';
  v_tablename varchar2(50):='T02_STR_DATA_EXTENTS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/


Prompt conectando como ariadna1001
connect ariadna1001/ariadna

Prompt creando tabla str_data
create table str_data(
  str char(1024)
) segment creation immediate pctfree 0;


Prompt consulta
select lengthb(str), length(str) from str_data where str='a';

--Calculo aprox del num. de registros para llenar 1 extension
--tamaño registro 1024 bytes.
--tamaño del bloque = 8192 bytes.
--bloque/registro=n
--n=8 !al contar el espacio del header, cabrían aprox. 7 registros

--Tamaño default p/extension 65536 bytes
--extension/bloque=N
--N=65536/8192
--N=8 8 bloques por extensión

--Total de registros por extension= 7*8=56

Prompt insertando datos
declare
  v_query varchar2(100);
begin
  v_query:='insert into str_data(str) values (:ph1)';
  for v_index in 1 .. 56 loop
    execute immediate v_query using dbms_random.string('a',1024);
  end loop;
end;
/
commit;

--Prompt comprobando insersiones
select * from user_extents where segment_name='STR_DATA';

Prompt mostrando registros por bloque
create table t02_str_data_extents as
  select substr(rowid,1,15) as codigo_bloque,count(*) total_registros
  from str_data
  group by substr(rowid,1,15)
  order by codigo_bloque;
--8 registros llenan una extensión.
--Más de 8 registros->1 bloque en una 2da extension

Prompt mostrando registros por bloque de t02
select * from t02_str_data_extents;