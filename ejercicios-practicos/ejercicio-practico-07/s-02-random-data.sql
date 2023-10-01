-- @Autor:  Ariadna Lázaro
-- @Fecha:  28/sept/2023
-- @Descripcion:Uso del db buffer cache por objeto

--Comprobando si ya existe la tabla 3
Prompt Conectando como sys para comprobar t03
connect sys/system2 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA07';
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
  v_owner varchar2(20) := 'ARIADNA07';
  v_tablename varchar2(50):='T04_DB_BUFFER_STATUS';
begin
  select count(*) into v_count from all_tables 
  where table_name=v_tablename and owner=v_owner;
  if v_count >0 then
    execute immediate 'drop table '||v_owner||'.'||v_tablename;
  end if;
end;
/

Prompt Conectando como ariadna07
connect ariadna07/ariadna

Prompt creando tabla t03_random_data
  create table t03_random_data(id number,
  random_string varchar2(1024)
);

Prompt creando tabla t04_db_buffer_status
create table t04_db_buffer_status(id number 
  generated always as identity,
  total_bloques number,
  status varchar2(10),
  evento varchar2(30)
);


--Generación de cadenas aleatorias de 1024 bytes
declare
  v_rows number;
  v_query varchar2(100);
begin
  v_rows := 1000*10;
  v_query :='insert into t03_random_data
  (id, random_string) values (:ph1,:ph2)';
  for v_index in 1 .. v_rows loop
    execute immediate v_query
    using v_index, dbms_random.string('P',1016);
  end loop;
end;
/
commit;

Prompt Conectando como sys
connect sys/system2 as sysdba

insert into ariadna07.t04_db_buffer_status (total_bloques,status,evento)
  select count(*) total_bloques,status, 'Después de carga' as evento
  from v$bh
  where objd = (
    select data_object_id
    from dba_objects
    where object_name='T03_RANDOM_DATA'
    and owner = 'ARIADNA07')
  group by status;
commit;

Prompt registros hasta el momento de t04
select * from ariadna07.t04_db_buffer_status;

alter system flush buffer_cache;

insert into ariadna07.t04_db_buffer_status (total_bloques,status,evento)
  select count(*) total_bloques,status, 'Después de vaciar buffer' as evento
  from v$bh
  where objd = (
    select data_object_id
    from dba_objects
    where object_name='T03_RANDOM_DATA'
    and owner = 'ARIADNA07')
  group by status;
commit;

Prompt registros hasta el momento de t04
select * from ariadna07.t04_db_buffer_status;

Prompt Reiniciando instancia.
shutdown immediate;
startup;

insert into ariadna07.t04_db_buffer_status (total_bloques,status,evento)
  select count(*) total_bloques,status, 'Después del reinicio' as evento
  from v$bh
  where objd = (
    select data_object_id
    from dba_objects
    where object_name='T03_RANDOM_DATA'
    and owner = 'ARIADNA07')
  group by status;
commit;

Prompt registros hasta el momento de t04
select * from ariadna07.t04_db_buffer_status;

Prompt Modificar un registro de la tabla
update ariadna07.t03_random_data 
  set random_string= upper(random_string)
  where id = 5001;
--ojo, no hacer commit

Prompt registros hasta el momento de t04
select * from ariadna07.t04_db_buffer_status;

insert into ariadna07.t04_db_buffer_status (total_bloques,status,evento)
  select count(*) total_bloques,status, 'Después del cambio 1' as evento
  from v$bh
  where objd = (
    select data_object_id
    from dba_objects
    where object_name='T03_RANDOM_DATA'
    and owner = 'ARIADNA07')
  group by status;

Prompt registros hasta el momento de t04
select * from ariadna07.t04_db_buffer_status;

Prompt En otra terminal crear una sesión con el usuario ariadna07
Prompt consultar 3 veces el registro modificado
pause "select random_string from t03_random_data where id=5001", [enter] para continuar

insert into ariadna07.t04_db_buffer_status (total_bloques,status,evento)
  select count(*) total_bloques,status, 'Después de 3 consultas' as evento
  from v$bh
  where objd = (
    select data_object_id
    from dba_objects
    where object_name='T03_RANDOM_DATA'
    and owner = 'ARIADNA07')
  group by status;
 commit;

Prompt Mostrando los datos finales de t04
select * from ariadna07.t04_db_buffer_status;


exit
