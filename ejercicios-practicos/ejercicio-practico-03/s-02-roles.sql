--@Autor: 	Ariadna Lázaro
--@Fecha: 	06-sept-2023
--@Descripcion:	Roles y privilegios

whenever sqlerror exit rollback;

Prompt conectando como sysdba
connect sys/system1 as sysdba

Prompt creando tabla 2
--oracle mainteined indica que se creo con la BD
create table ariadna0301.t02_db_roles as
  select role_id,role from dba_roles
  where oracle_maintained='Y';

select * from ariadna0301.t02_db_roles;

Prompt creando rol
create role basic_user_role;
grant create table, create session, create sequence, create procedure to basic_user_role;
grant basic_user_role to ariadna0301;

Prompt conectando como user ariadna0301
connect ariadna0301/ari
--col format username a30
--col format granted_role a50
--set linesize window
Prompt comprobando roles asignados
select username, granted_role from user_role_privs;

Prompt comprobando privilegios asignados
select privilege,admin_option
from user_sys_privs;
