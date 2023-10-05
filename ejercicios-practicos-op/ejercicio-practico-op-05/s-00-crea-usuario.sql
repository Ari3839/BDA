-- @Autor:  Ariadna Lázaro
-- @Fecha:  03/10/2023
-- @Descripcion:Creación del user para el ejercicio

Prompt conectando como usuario sys
connect sys/system2 as sysdba

declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA05OP';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count >0 then
    execute immediate 'drop user '||v_username|| 'cascade';
  end if;
end;
/
Prompt creando al usuario ariadna05op
create user ariadna05op identified by ariadna quota unlimited on users;
grant create sequence, create procedure, create session, create table to ariadna05op;

disconnect
