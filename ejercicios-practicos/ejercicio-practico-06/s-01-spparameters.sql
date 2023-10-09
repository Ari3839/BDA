-- @Autor:	Ariadna Lázaro
-- @Fecha:	17/09/2023
-- @Descripcion:Comparar parametros desde spfile y v$parameters

Prompt conectando como sys
connect sys/system2 as sysdba

--en caso de error
whenever sqlerror exit rollback

Prompt creando pfile
create pfile='/unam-bda/ejercicios-practicos/ejercicio-practico-06/e-02-spparameter-pfile.txt' from spfile;

Prompt creando usuario
declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA06';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count>0 then
    execute immediate 'drop user '||v_username||' cascade';
  end if;
end;
/

create user ariadna06 identified by ariadna quota unlimited on users;

Prompt asignando privilegios
grant create session, create table, create sequence, create procedure to ariadna06;

Prompt creando tabla
create table ariadna06.t01_spparameters as
  select name,value
  from v$spparameter
  where value is not null;

select * from ariadna06.t01_spparameters;
