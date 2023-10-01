--@Autor: 	Ariadna Lázaro
--@Fecha: 	06-sept-2023
--@Descripcion:	Buscar la version de la BD

whenever sqlerror exit rollback;

Prompt conectando como sys
connect sys/system1 as sysdba

--Codigo idempotente
declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA0301';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count>0 then
    execute immediate 'drop user '||v_username||' cascade';
  end if;
end;
/

Prompt creando usuario 0301
create user ariadna0301 identified by ari quota unlimited on users;
grant create session, create table to ariadna0301;

create table ariadna0301.t01_db_version as
  select product,version,version_full
  from product_component_version;

