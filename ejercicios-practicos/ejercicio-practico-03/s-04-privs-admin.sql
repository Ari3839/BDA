--@Autor: 	Ariadna Lázaro
--@Fecha: 	06-sept-2023
--@Descripcion:	Usuarios de administracion

whenever sqlerror exit rollback;

Prompt conectando como sys
connect sys/Hola1234# as sysdba

--Codigo idempotente
declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA0302';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count>0 then
    execute immediate 'drop user '||v_username||' cascade';
  end if;
end;
/


declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA0303';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count>0 then
    execute immediate 'drop user '||v_username||' cascade';
  end if;
end;
/


declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA0304';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count>0 then
    execute immediate 'drop user '||v_username||' cascade';
  end if;
end;
/



Prompt creando usuarios
create user ariadna0302 identified by ariadna quota unlimited on users;
grant create session,create table to ariadna0302;
grant sysdba to ariadna0302;

create user ariadna0303 identified by ariadna quota unlimited on users;
grant create session to ariadna0303;
grant sysoper to ariadna0303;

create user ariadna0304 identified by ariadna quota unlimited on users;
grant create session to ariadna0304;
grant sysbackup to ariadna0304;


Prompt creando tabla
create table ariadna0302.t04_priv_admin as
  select username,sysdba,sysoper,sysbackup
  from v$pwfile_users;

Prompt mostrando datos
col username format a30
select * from ariadna0302.t04_priv_admin;
