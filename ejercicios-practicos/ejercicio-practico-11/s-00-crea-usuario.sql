-- @Autor:  Ariadna Lázaro
-- @Fecha:  20/11/2023
-- @Descripcion:Creación del user para el ejercicio

Prompt conectando como usuario sys
connect sys/system2 as sysdba

declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA11';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count >0 then
    execute immediate 'drop user '||v_username|| 'cascade';
  end if;
end;
/
Prompt creando al usuario ariadna11
create user ariadna11 identified by ariadna quota unlimited on users;
grant create procedure, create session, create table to ariadna11;
--exit