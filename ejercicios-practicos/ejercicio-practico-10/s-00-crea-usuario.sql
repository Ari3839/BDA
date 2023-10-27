-- @Autor:  Ariadna Lázaro
-- @Fecha:  25/10/2023
-- @Descripcion:Creacion del usuario para trabajar el ejercicio

--Instrucciones de ejecución
--sqlplus /nolog
--@s-01-aalm-creacion-usuarios.sql

prompt Conectándose a aalmbda1 como usuario SYS
connect sys/system1 as sysdba

declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA1001';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count >0 then
    execute immediate 'drop user '||v_username|| 'cascade';
  end if;
end;
/
Prompt creando al usuario
create user ariadna1001 identified by ariadna quota unlimited on users;
grant create procedure, create session, create table to ariadna1001;

prompt Listo
exit
