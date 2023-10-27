-- @Autor:  Ariadna Lázaro
-- @Fecha:  25/10/2023
-- @Descripcion:Consultas de segmentos

Prompt conectando como sys para eliminar tablas preexistentes
connect sys/system1 as sysdba

declare
  v_count number;
  v_owner varchar2(20) := 'ARIADNA1001';
  v_tablename varchar2(50):='EMPLEADO';
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
  v_tablename varchar2(50):='T01_EMP_SEGMENTS';
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

Prompt creando tabla empleado
create table empleado(
  empleado_id number(10) constraint empleado_pk primary key,
  nombre_completo  varchar2(150),
  num_cuenta varchar2(15) constraint empleado_num_cuenta_uix unique,
  expediente blob
) segment creation deferred;

Prompt Comprobando que aún no se crean las estructuras logicas
select *
from user_segments
where segment_name like '%EMPLEADO%';

Prompt insertando registro 1.
insert into empleado(empleado_id,nombre_completo,num_cuenta,expediente)
values (1,'Harry Styles','123456',empty_blob());

select *
from user_segments
where segment_name like '%EMPLEADO%';

Prompt Creando una extensión de forma manual
alter table empleado allocate extent;

Prompt Segmentos creados
select *
from user_segments
where segment_name like '%EMPLEADO%';

create table t01_emp_segments as
  select us.segment_name as segment_name,
  us.segment_type as segment_type,
  us.tablespace_name as tablespace_name,
  round(us.bytes/1024) as segment_kbs,
  us.blocks as blocks,us.extents as extents
  from user_segments us, user_lobs ul
  where us.segment_name like '%EMPLEADO%'
    and ul.table_name ='EMPLEADO'
    or us.segment_name=ul.segment_name 
    or us.segment_name=ul.index_name;

Prompt comprobando registros
select * from t01_emp_segments;

select sum(segment_kbs) from t01_emp_segments;

select sum(blocks) from t01_emp_segments;