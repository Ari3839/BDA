-- @Autor:  Ariadna Lázaro
-- @Fecha:  24/11/2023
-- @Descripcion:Datos undo pt2

Prompt conectando como usuario sys
connect sys/system2 as sysdba

--D
show parameter undo_tablespace;

select name,value from v$parameter where name='undo_tablespace';



--E
select to_char(begin_time,'dd/mm/yyyy hh24:mi:ss') as begin_time,
to_char(end_time,'dd/mm/yyyy hh24:mi:ss') as end_time,undotsn,
undoblks,txncount,maxqueryid,maxquerylen,activeblks,unexpiredblks,
expiredblks,tuned_undoretention
from v$undostat
order by begin_time desc
fetch first 20 rows only;

--F
--¿Cuántos bloques podrían ser sobrescritos sin causar mayores inconvenientes?
--¿Cuántos bloques NO pueden ser sobrescritos aun?

--G.
select to_char(u.begin_time,'dd/mm/yyyy hh24:mi:ss') as begin_time,
to_char(u.end_time,'dd/mm/yyyy hh24:mi:ss') as end_time,undotsn,
t.TS#,t.name
from v$undostat u join v$tablespace t
on u.undotsn=t.TS#
where t.name='UNDOTBS2';


--H
select df.tablespace_name,
sum(df.blocks) as bloques_totales,
(select sum(blocks)
  from dba_free_space
  where tablespace_name='UNDOTBS2'
  group by tablespace_name) as bloques_disponibles,
round((select sum(blocks)
  from dba_free_space
  where tablespace_name='UNDOTBS2'
  group by tablespace_name)
/sum(df.blocks) * 100, 2) as porcentaje_libres
from dba_free_space fs join dba_data_files df 
on fs.tablespace_name = df.tablespace_name
where df.tablespace_name='UNDOTBS2'
group by df.tablespace_name;


--I
Prompt creando al usuario ariadna072
create user ariadna072 identified by ariadna quota unlimited on users;
grant create procedure, create session, create table to ariadna072;

create table ariadna072.ariadna072_cadena_2 (
  id number constraint ariadna072_cadena_2_pk primary key,
  cadena varchar2(1024)
) nologging;

create sequence ariadna072.sec_aalm_cadena_2;

prompt Insertando 50,000 registros
declare
  v_sql varchar2(100):='insert into ariadna072.ariadna072_cadena_2 (id, cadena) values(:ph1,:ph2)';
begin
  for v_index in 1..50000
  loop
    execute immediate v_sql using ariadna072.sec_aalm_cadena_2.nextval,dbms_random.string('P',1024);
  end loop;
end;
/
show errors
commit;

--J
select to_char(begin_time,'dd/mm/yyyy hh24:mi:ss') as begin_time,
to_char(end_time,'dd/mm/yyyy hh24:mi:ss') as end_time,undotsn,
undoblks,txncount,maxqueryid,maxquerylen,activeblks,unexpiredblks,
expiredblks,tuned_undoretention
from v$undostat
order by begin_time desc
fetch first 20 rows only;

Prompt probando el borrado de datos con error porque no hay espacio para undo
delete from ariadna072.ariadna072_cadena_2;

Prompt Borrando en rangos de 5000 registros

delete from ariadna072.ariadna072_cadena_2 where id<=5000;
delete from ariadna072.ariadna072_cadena_2 where id<=10000;
delete from ariadna072.ariadna072_cadena_2 where id<=15000;
delete from ariadna072.ariadna072_cadena_2 where id<=20000;
delete from ariadna072.ariadna072_cadena_2 where id<=25000;
--ERROR ORA 30036
delete from ariadna072.ariadna072_cadena_2 where id<=30000;
delete from ariadna072.ariadna072_cadena_2 where id<=35000;
delete from ariadna072.ariadna072_cadena_2 where id<=40000;
delete from ariadna072.ariadna072_cadena_2 where id<=45000;
delete from ariadna072.ariadna072_cadena_2 where id<=50000;

Prompt rollback
rollback;

--select count(*) from ariadna072.ariadna072_cadena_2;