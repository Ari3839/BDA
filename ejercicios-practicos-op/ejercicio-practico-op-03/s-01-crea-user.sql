Prompt conectando como usuario sys
connect sys/system1 as sysdba

declare
  v_count number;
  v_username varchar2(20) := 'ARIADNA03OP';
begin
  select count(*) into v_count from all_users where username=v_username;
  if v_count >0 then
    execute immediate 'drop user '||v_username|| 'cascade';
  end if;
end;
/
Prompt creando al usuario ariadna03op
create user ariadna03op identified by ariadna quota unlimited on users;
grant create session, create table to ariadna03op;
